import 'package:flutter/material.dart';
import 'package:wind/model/handin_details.dart';
import 'package:wind/utils/time.dart';

class HandinTile extends StatelessWidget {
  final HandinDetails details;

  const HandinTile(this.details, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: details.submitFilename == null
          ? const Icon(Icons.upload_file)
          : const Icon(Icons.file_present),
      title: Text(details.submitFilename ?? 'Nog geen document ingeleverd'),
      subtitle: Text(details.submitDate != null
          ? buildSubtitle()
          : 'Gebruik de site om een document in te leveren'),
      trailing:
          details.submitFilename == null ? null : const Icon(Icons.open_in_new),
      onTap: onTap,
    );
  }

  String buildSubtitle() {
    return 'Inleverdatum: ${Time.getFormattedDate(details.submitDate!)} ${Time.getFormattedTime(details.submitDate!)}  \n' +
        (details.plagiarism == null ? '' : 'Plagiaat: ${details.plagiarism}%');
  }

  void onTap() {
    if (details.submitUrl == null) {
      return;
    }
    //TODO: Add download for handin
  }
}
