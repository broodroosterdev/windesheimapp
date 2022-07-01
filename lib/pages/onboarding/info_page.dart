import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wind/pages/login.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welkom bij Wind!",
          body: "Met Wind kun je makkelijk alle Windesheim diensten gebruiken op je telefoon.",
          image: SvgPicture.asset("assets/study.svg", height: MediaQuery.of(context).size.height / 3,)
        ),
        PageViewModel(
            title: "Bekijk je roosters",
            body: "Zie in een oogopslag wanneer je een les hebt, waar je naar toe moet of wie de les geeft.",
            image: SvgPicture.asset("assets/schedule.svg", height: MediaQuery.of(context).size.height / 3,)
        ),
        PageViewModel(
            title: "Bekijk je lesmateriaal op de ELO",
            body: "Voor je les begint nog snel even de lesstof bekijken. Of in de trein de studiewijzer doorlezen, het kan allemaal.",
            image: SvgPicture.asset("assets/books.svg", height: MediaQuery.of(context).size.height / 3,)
        ),
        PageViewModel(
            title: "Login met je Windesheim account",
            body: "Voordat je gebruik kan maken van de app, log je in met je Windesheim account",
            footer: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginPage(redirectRoute: "/setup",)));
              },
              child: const Text("Login"),
            ),
            image: SvgPicture.asset("assets/login.svg", height: MediaQuery.of(context).size.height / 3,)
        )
      ],
      next: const Icon(Icons.arrow_forward_rounded),
      skip: const Text("Sla over"),
      showSkipButton: true,
      showDoneButton: false,
      showNextButton: true,
    );
  }
}
