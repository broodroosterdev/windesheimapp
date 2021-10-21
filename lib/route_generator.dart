import 'package:flutter/material.dart';
import 'package:wind/pages/elo/study_content_page.dart';
import 'package:wind/pages/elo/study_document_page.dart';
import 'package:wind/pages/elo/study_handin_page.dart';
import 'package:wind/pages/elo/study_routes_page.dart';
import 'package:wind/pages/login.dart';
import 'package:wind/pages/schedule/lesson_details_page.dart';
import 'package:wind/pages/schedule/rooster.dart';
import 'package:wind/pages/settings/add_schedule_page.dart';
import 'package:wind/pages/settings/settings_page.dart';
import 'package:wind/pages/study/study_page.dart';
import 'package:wind/services/auth/auth_manager.dart';

import 'model/les.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //Get the arguments passed into the Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        if (AuthManager.loggedIn) {
          return MaterialPageRoute(builder: (_) => SchedulePage());
        } else {
          return MaterialPageRoute(builder: (_) => LoginPage());
        }
      case '/rooster':
        return MaterialPageRoute(builder: (_) => SchedulePage());
      case '/lesson-details':
        final arguments = args as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => LessonDetailsPage(
                lesson: arguments['lesson'] as Les,
                color: arguments['color'] as Color));
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case '/add-schedule':
        return MaterialPageRoute(builder: (_) => AddSchedulePage());
      case '/studyroutes':
        return MaterialPageRoute(builder: (_) => StudyRoutesPage());
      case '/studycontent':
        final arguments = args as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => StudyContentPage(
                studyRouteId: arguments['studyRouteId'],
                parentId: arguments['parentId']));
      case '/studydocument':
        final arguments = args as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) =>
                StudyDocumentPage(arguments['url'], arguments['name']));
      case '/studyhandin':
        final arguments = args as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) =>
                StudyHandinPage(arguments['resourceId'], arguments['name']));
      case '/study':
        return MaterialPageRoute(builder: (_) => StudyPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
