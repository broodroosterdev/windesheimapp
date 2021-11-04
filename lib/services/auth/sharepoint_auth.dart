import 'package:dio/dio.dart';
import 'package:xml/xml.dart';

//Large part of code contained in this file
// is from the node-sp-auth npm package:
// https://github.com/s-KaiNet/node-sp-auth

class SharepointAuth {
  static const String userRealmEndpoint =
      "https://login.microsoftonline.com/GetUserRealm.srf";

  static const String msOnlineSts =
      "https://login.microsoftonline.com/extSTS.srf";

  static const String siteUrl =
      "https://liveadminwindesheim.sharepoint.com/sites/wip";

  static const String spFormsEndpoint =
      "https://liveadminwindesheim.sharepoint.com/_forms/default.aspx?wa=wsignin1.0";

  static Future<SharePointCookie> login(String email, String password) async {
    var response = await Dio().post(userRealmEndpoint,
        data: {'login': email},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));

    var userRealm = response.data;
    var securityToken = await getSecurityToken(email, password,
        userRealm['AuthURL'], userRealm['CloudInstanceIssuerUri']);

    var tokenResponse = await postToken(securityToken);
    late String fedAuth;
    late String rtFa;

    for (var header in tokenResponse.value.headers.map['set-cookie']!) {
      if (header.contains('rtFa')) {
        rtFa = header.substring(0, header.indexOf(';'));
      }
      if (header.contains('FedAuth')) {
        fedAuth = header.substring(0, header.indexOf(';'));
      }
    }

    final authCookie = fedAuth + '; ' + rtFa;
    return SharePointCookie(tokenResponse.expiresAt, authCookie);
  }

  static Future<TokenResponse> postToken(String xml) async {
    final doc = XmlDocument.parse(xml);

    final securityTokenResponse =
        doc.getElement('S:Envelope')!.getElement('S:Body')!.firstChild;
    final binaryToken = securityTokenResponse!
        .getElement('wst:RequestedSecurityToken')!
        .firstChild!
        .innerText;
    final expires = DateTime.parse(securityTokenResponse
            .getElement('wst:Lifetime')!
            .getElement('wsu:Expires')!
            .innerText)
        .millisecondsSinceEpoch;

    Response<String> response = await Dio().post(spFormsEndpoint,
        data: binaryToken,
        options: Options(
          validateStatus: (int? status) {
            return status != null && status >= 200 && status < 303;
          },
          headers: {
            'User-Agent':
                'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ));

    return TokenResponse(expires, response);
  }

  static Future<String> getSecurityToken(String username, String password,
      String adfsUrl, String relyingParty) async {
    final assertion =
        await getSamlAssertion(username, password, adfsUrl, relyingParty);

    const rootSiteUrl = "https://liveadminwindesheim.sharepoint.com";
    final tokenRequest = getOnlineSamlWsfed(rootSiteUrl, assertion.value);

    final response = await Dio().post(msOnlineSts,
        data: tokenRequest,
        options: Options(contentType: 'application/soap+xml; charset=utf-8'));

    return response.data;
  }

  static Future<SamlAssertion> getSamlAssertion(String username,
      String password, String adfsUrl, String relyingParty) async {
    final String adfsHost = Uri.parse(adfsUrl).host;
    final String usernameMixedUrl =
        "https://$adfsHost/adfs/services/trust/13/usernamemixed";

    final String samlBody =
        getAdfsSamlWsfed(usernameMixedUrl, username, password, relyingParty);
    var response = await Dio().post(usernameMixedUrl,
        data: samlBody,
        options: Options(contentType: 'application/soap+xml; charset=utf-8'));

    final doc = XmlDocument.parse(response.data);
    final tokenResponseCollection =
        doc.getElement('s:Envelope')!.getElement('s:Body');
    final securityTokenResponse =
        tokenResponseCollection!.firstChild!.firstChild;
    final samlAssertion = securityTokenResponse!
        .getElement('trust:RequestedSecurityToken')!
        .firstChild;
    final notBefore = samlAssertion!.firstChild!.getAttribute('NotBefore');
    final notAfter = samlAssertion.firstChild!.getAttribute('NotOnOrAfter');
    return SamlAssertion(
        samlAssertion.toXmlString(
            indent: '', preserveWhitespace: (_) => false, newLine: ''),
        notBefore!,
        notAfter!);
  }

  static String getAdfsSamlWsfed(
      String to, String username, String password, String relyingParty) {
    return """
    <s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope" xmlns:a="http://www.w3.org/2005/08/addressing" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
      <s:Header>
        <a:Action s:mustUnderstand="1">http://docs.oasis-open.org/ws-sx/ws-trust/200512/RST/Issue</a:Action>
        <a:ReplyTo>
          <a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address>
        </a:ReplyTo>
        <a:To s:mustUnderstand="1">$to</a:To>
        <o:Security s:mustUnderstand="1" xmlns:o="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
          <o:UsernameToken u:Id="uuid-7b105801-44ac-4da7-aa69-a87f9db37299-1">
            <o:Username>$username</o:Username>
            <o:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">$password</o:Password>
          </o:UsernameToken>
        </o:Security>
      </s:Header>
      <s:Body>
      <trust:RequestSecurityToken xmlns:trust="http://docs.oasis-open.org/ws-sx/ws-trust/200512">
        <wsp:AppliesTo xmlns:wsp="http://schemas.xmlsoap.org/ws/2004/09/policy">
          <wsa:EndpointReference xmlns:wsa="http://www.w3.org/2005/08/addressing">
            <wsa:Address>$relyingParty</wsa:Address>
          </wsa:EndpointReference>
        </wsp:AppliesTo>
        <trust:KeyType>http://docs.oasis-open.org/ws-sx/ws-trust/200512/Bearer</trust:KeyType>
        <trust:RequestType>http://docs.oasis-open.org/ws-sx/ws-trust/200512/Issue</trust:RequestType>
      </trust:RequestSecurityToken>
    </s:Body>
    </s:Envelope>
    """;
  }

  static String getOnlineSamlWsfed(String endpoint, String token) {
    return """
    <s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope" xmlns:a="http://www.w3.org/2005/08/addressing" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
    <s:Header>
      <a:Action s:mustUnderstand="1">http://schemas.xmlsoap.org/ws/2005/02/trust/RST/Issue</a:Action>
      <a:ReplyTo>
        <a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address>
      </a:ReplyTo>
      <a:To s:mustUnderstand="1">https://login.microsoftonline.com/extSTS.srf</a:To>
      <o:Security s:mustUnderstand="1" xmlns:o="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">$token</o:Security>
    </s:Header>
    <s:Body>
      <t:RequestSecurityToken xmlns:t="http://schemas.xmlsoap.org/ws/2005/02/trust">
        <wsp:AppliesTo xmlns:wsp="http://schemas.xmlsoap.org/ws/2004/09/policy">
          <a:EndpointReference>
            <a:Address>$endpoint</a:Address>
          </a:EndpointReference>
        </wsp:AppliesTo>
        <t:KeyType>http://schemas.xmlsoap.org/ws/2005/05/identity/NoProofKey</t:KeyType>
        <t:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Issue</t:RequestType>
        <t:TokenType>urn:oasis:names:tc:SAML:1.0:assertion</t:TokenType>
      </t:RequestSecurityToken>
    </s:Body>
  </s:Envelope>
    """;
  }
}

class SamlAssertion {
  String value;
  String notBefore;
  String notAfter;

  SamlAssertion(this.value, this.notBefore, this.notAfter);
}

class TokenResponse {
  int expiresAt;
  Response<String> value;

  TokenResponse(this.expiresAt, this.value);
}

class SharePointCookie {
  int expiresAt;
  String cookie;

  SharePointCookie(this.expiresAt, this.cookie);
}
