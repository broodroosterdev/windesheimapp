import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:wind/model/handin_details.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/download/download_manager.dart';
import 'package:wind/services/download/download_task.dart';
import 'package:wind/utils/time.dart';

class HandinTile extends StatelessWidget {
  final HandinDetails details;

  String get filePath => "/${details.id}/${details.submitFilename}";

  const HandinTile(this.details, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: details.hasSubmission
          ? const Icon(Icons.file_present)
          : const Icon(Icons.file_upload),
      title: Text(details.submitFilename ?? 'Nog geen document ingeleverd'),
      subtitle: Text(details.hasSubmission
          ? buildSubtitle()
          : 'Gebruik de site om een document in te leveren'),
      trailing: SizedBox(
        height: 24,
        width: 24,
        child: downloadIndicator(context),
      ),
      onTap: onTap,
    );
  }

  String buildSubtitle() {
    return 'Inleverdatum: ${Time.getFormattedDate(details.submitDate!)} ${Time.getFormattedTime(details.submitDate!)}  \n' +
        (details.plagiarism == null ? '' : 'Plagiaat: ${details.plagiarism}%');
  }

  void onTap() async {
    if (details.submitUrl == null) {
      return;
    }
    if (downloadManager.hasTask(details.id)) {
      downloadManager.cancelTask(details.id);
    } else if (isDownloaded()) {
      await OpenFile.open(tempDir.path + filePath);
    } else {
      downloadManager.addTask(
        details.id,
        DownloadTask(details.submitUrl!, filePath),
      );
    }
  }

  Widget downloadIndicator(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: downloadManager,
        child: Consumer<DownloadManager>(
            builder: (context, model, _) => ChangeNotifierProvider.value(
                value: model.getTask(details.id),
                child: Consumer<DownloadTask?>(
                  builder: (context, model, _) => getDownloadIcon(task: model),
                ))));
  }

  Widget getDownloadIcon({DownloadTask? task}) {
    if (task != null) {
      return Stack(
        children: [
          SizedBox(
            height: 26,
            width: 26,
            child: CircularProgressIndicator(
                value: task.progress, color: Colors.yellow, strokeWidth: 3.0),
          ),
          const SizedBox(
            height: 26,
            width: 26,
            child: Center(child: Icon(Icons.downloading)),
          )
        ],
      );
    } else if (isDownloaded()) {
      return const Icon(Icons.file_download_done_sharp);
    } else {
      if(details.submitUrl != null){
        return const Icon(Icons.download_sharp);
      } else {
        return const Icon(null);
      }
    }
  }

  bool isDownloaded() {
    return File(tempDir.path + filePath).existsSync();
  }
}
