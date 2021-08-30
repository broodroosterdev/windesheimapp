import 'dart:convert';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:windesheimapp/internal/auth_failure.dart';
import 'package:windesheimapp/services/auth/api_auth.dart';
import 'package:windesheimapp/services/auth/auth_manager.dart';
import 'package:windesheimapp/services/auth/elo_auth.dart';

import '../main.dart';
import '../preferences.dart';
import '../providers.dart';

@deprecated
class LoginConfirmPage extends StatefulWidget {
  final String email;
  final String password;

  const LoginConfirmPage(
      {Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  _LoginConfirmPageState createState() => _LoginConfirmPageState();
}

class _LoginConfirmPageState extends State<LoginConfirmPage> {
  late Future<dartz.Either<AuthFailure, void>> eloResponse;
  late Future<dartz.Either<AuthFailure, void>> apiResponse;

  @override
  void initState() {
    super.initState();

    eloResponse = AuthManager.loginElo(widget.email, widget.password);
    apiResponse = AuthManager.loginApi(widget.email, widget.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 18, 19, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/logo.png')),
            const Text("Windesheim",
                style: TextStyle(
                    color: Color.fromRGBO(255, 203, 5, 1.0),
                    fontFamily: 'Noto Sans',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 36)),
            const Text("ELO:"),
            FutureBuilder<dartz.Either<AuthFailure, void>>(
                future: eloResponse,
                builder: (BuildContext context,
                    AsyncSnapshot<dartz.Either<AuthFailure, void>> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.fold((error) {
                      return Text(error.message);
                    }, (code) {
                      return const Icon(Icons.check_circle_outline, size: 36.0, color: Colors.lightGreenAccent);
                    });
                  } else if (snapshot.hasError) {
                    return const Text("Error occurred");
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            const Text("API:"),
            FutureBuilder<dartz.Either<AuthFailure, void>>(
                future: apiResponse,
                builder: (BuildContext context,
                    AsyncSnapshot<dartz.Either<AuthFailure, void>> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.fold((error) {
                      return Text(error.message);
                    }, (code) {
                      return const Icon(Icons.check_circle_outline, size: 36.0, color: Colors.lightGreenAccent);
                    });
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Text("Error occurred");
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            ElevatedButton(
                onPressed: () {
                  AuthManager.logout();
                  navigatorKey.currentState!
                      .pushNamedAndRemoveUntil("/", (r) => false);
                },
                child: const Text('Uitloggen'),
            ),
            ElevatedButton(
              onPressed: () {
                navigatorKey.currentState!.pushNamed("/rooster");
              },
              child: const Text('Continue'),
            )
          ],
        ),
      ),
    );
  }
}
