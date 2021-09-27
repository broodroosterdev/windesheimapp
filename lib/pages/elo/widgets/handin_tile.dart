import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wind/model/handin_details.dart';

class HandinTile extends StatelessWidget {
  final HandinDetails details;

  HandinTile(this.details);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: details.submitFilename == null ? Icon(Icons.upload_file) : Icon(Icons.file_present),
      title: Text(details.submitFilename ?? 'Nog geen document ingeleverd'),
      subtitle: Text(details.submitDate != null ? buildSubtitle() : 'Gebruik de site om een document in te leveren'),
      trailing: details.submitFilename == null ? null : Icon(Icons.open_in_new),
      onTap: onTap,
    );
  }

  String buildSubtitle(){
    final DateFormat formatter = DateFormat('dd-MM-yyyy H:mm');
    return 'Inleverdatum: ${formatter.format(details.submitDate!)}\n' + (details.plagiarism == null ? '' : 'Plagiaat: ${details.plagiarism}%');
  }

  void onTap(){
    if(details.submitUrl == null)
      return;
  }
}
