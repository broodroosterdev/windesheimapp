import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/download/download_task.dart';

class DownloadIcon extends StatelessWidget {
  final DownloadTask? task;
  final String path;

  const DownloadIcon(this.task, this.path, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (task != null) {
      return Stack(
        children: [
          SizedBox(
            height: 26,
            width: 26,
            child: CircularProgressIndicator(
                value: task!.progress, color: Theme.of(context).colorScheme.secondary, strokeWidth: 3.0),
          ),
          SizedBox(
            height: 26,
            width: 26,
            child: Center(child: Icon(Icons.downloading_sharp, color: Theme.of(context).colorScheme.primary)),
          )
        ],
      );
    } else if (isDownloaded()) {
      return Icon(Icons.file_download_done_sharp, color: Theme.of(context).colorScheme.secondary);
    } else {
      return Icon(Icons.download_sharp, color: Theme.of(context).colorScheme.primary);
    }
  }

  bool isDownloaded() {
    return File(tempDir.path + path).existsSync();
  }
}
