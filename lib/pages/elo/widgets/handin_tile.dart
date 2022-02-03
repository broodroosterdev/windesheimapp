import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:wind/model/handin_details.dart';
import 'package:wind/pages/elo/widgets/confirm_delete_dialog.dart';
import 'package:wind/pages/elo/widgets/download_icon.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/download/download_manager.dart';
import 'package:wind/services/download/download_task.dart';
import 'package:wind/utils/time.dart';

class HandinTile extends StatefulWidget {
  final HandinDetails details;

  const HandinTile(this.details, {Key? key}) : super(key: key);

  @override
  State<HandinTile> createState() => _HandinTileState();
}

class _HandinTileState extends State<HandinTile> {
  String get filePath => "/${widget.details.id}/${widget.details.submitFilename}";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: widget.details.hasSubmission
          ? const Icon(Icons.file_present)
          : const Icon(Icons.file_upload),
      title: Text(widget.details.submitFilename ?? 'Nog geen document ingeleverd'),
      subtitle: Text(widget.details.hasSubmission
          ? buildSubtitle()
          : 'Gebruik de site om een document in te leveren'),
      trailing: SizedBox(
        height: 24,
        width: 24,
        child: downloadIndicator(context),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  void onLongPress() async {
    if (widget.details.hasSubmission && isDownloaded()) {
      var shouldDelete = await showDialog(
          context: context,
          builder: (context) => const ConfirmDeleteDialog());
      if(shouldDelete) {
        await File(tempDir.path + filePath).delete();
        setState(() {});
      }
    }
  }

  String buildSubtitle() {
    return 'Inleverdatum: ${Time.getFormattedDate(widget.details.submitDate!)} ${Time.getFormattedTime(widget.details.submitDate!)}  \n' +
        (widget.details.plagiarism == null ? '' : 'Plagiaat: ${widget.details.plagiarism}%');
  }

  void onTap() async {
    if (widget.details.submitUrl == null) {
      return;
    }
    if (downloadManager.hasTask(widget.details.id)) {
      downloadManager.cancelTask(widget.details.id);
    } else if (isDownloaded()) {
      await OpenFile.open(tempDir.path + filePath);
    } else {
      downloadManager.addTask(
        widget.details.id,
        DownloadTask(widget.details.submitUrl!, filePath),
      );
    }
  }

  bool isDownloaded() {
    return File(tempDir.path + filePath).existsSync();
  }

  Widget downloadIndicator(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: downloadManager,
        child: Consumer<DownloadManager>(
            builder: (context, model, _) => ChangeNotifierProvider.value(
                value: model.getTask(widget.details.id),
                child: Consumer<DownloadTask?>(
                  builder: (context, model, _) => getDownloadIcon(task: model),
                ))));
  }

  Widget getDownloadIcon({DownloadTask? task}) {
    if(widget.details.submitUrl != null){
      return DownloadIcon(task, filePath);
    } else {
      return const Icon(null);
    }
  }
}
