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
            body:
                "Met Wind kun je makkelijk Windesheim diensten gebruiken op je telefoon.",
            image: SvgPicture.asset(
              "assets/study.svg",
              height: MediaQuery.of(context).size.height / 3,
            )),
        PageViewModel(
            title: "Over de app",
            body:
                "Deze app is geen officiele Windesheim app. Het gebruik hiervan is op eigen risico! Raadpleeg bij belangrijke zaken daarom altijd de officiële websites.",
            image: SvgPicture.asset(
              "assets/app.svg",
              height: MediaQuery.of(context).size.height / 3,
            )),
        PageViewModel(
            title: "Waarschuwing",
            body:
                "Om te voorkomen dat je constant moet inloggen, worden je email en wachtwoord opgeslagen. Gebruik de app alleen op apparaten die je vertrouwt. Als je vragen hebt hierover, neem contact op met de ontwikkelaar.",
            image: SvgPicture.asset(
              "assets/warning.svg",
              height: MediaQuery.of(context).size.height / 3,
            )),
        PageViewModel(
            title: "Login met je Windesheim account",
            body:
                "Voordat je gebruik kan maken van de app, moet je inloggen met je Windesheim account",
            footer: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const LoginPage(
                          redirectRoute: "/setup",
                        )));
              },
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 20),
              ),
            ),
            image: SvgPicture.asset(
              "assets/login.svg",
              height: MediaQuery.of(context).size.height / 3,
            ))
      ],
      next: const Icon(Icons.arrow_forward_rounded),
      showSkipButton: false,
      showDoneButton: false,
      showNextButton: true,
    );
  }
}
