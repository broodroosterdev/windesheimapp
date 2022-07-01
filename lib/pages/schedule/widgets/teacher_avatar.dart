import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/auth/auth_manager.dart';

class TeacherAvatar extends StatelessWidget {
  const TeacherAvatar(this.name, {this.size = 24, this.border = false, Key? key}) : super(key: key);

  final String name;
  final int size;
  final bool border;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthManager.getSharepointCookie(),
        builder: (context, AsyncSnapshot<String> snapshot) => Avatar(
            name: name,
            useCache: true,
            shape: AvatarShape.circle((size) / 2),
            sources: nameHasEmail() && snapshot.hasData ? [
                GenericSource(NetworkImage(
                nameToUrl(),
                headers: {'Cookie': snapshot.data!},
              ))
            ] : null,
          ),
      );
  }

  bool nameHasEmail(){
    return teacherMailMap.containsKey(name);
  }

  String nameToUrl(){
    String url = "https://liveadminwindesheim.sharepoint.com/_layouts/15/userphoto.aspx?size=S&username=${teacherMailMap[name]}";

    return url;
  }
}
