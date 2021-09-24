import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wind/model/studycontent.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/api/elo.dart';
import 'package:wind/services/download/download_manager.dart';
import 'package:wind/services/download/download_task.dart';

class StudyContentTile extends StatefulWidget {
  StudyContent studyContent;
  int studyRouteId;

  StudyContentTile(
      {Key? key, required this.studyContent, required this.studyRouteId})
      : super(key: key);

  @override
  _StudyContentTileState createState() => _StudyContentTileState();
}

class _StudyContentTileState extends State<StudyContentTile> {
  void onLongPress() async {
    if (widget.studyContent.type == ItemType.File) {
      if (isDownloaded()) {
        await File(tempDir.path + widget.studyContent.path!).delete();
        setState(() {});
      }
    }
  }

  void onTap() async {
    if (widget.studyContent.type == ItemType.Folder) {
      Navigator.of(context).pushNamed('/studycontent', arguments: {
        'studyRouteId': widget.studyRouteId,
        'parentId': widget.studyContent.id
      });
    } else if (widget.studyContent.type == ItemType.Link) {
      if (await canLaunch(widget.studyContent.url!)) {
        await launch(widget.studyContent.url!);
      }
    } else if (widget.studyContent.type == ItemType.File) {
      if (downloadManager.hasTask(widget.studyContent.id)) {
        downloadManager.cancelTask(widget.studyContent.id);
      } else if (isDownloaded()) {
        await OpenFile.open(tempDir.path + widget.studyContent.path!);
      } else {
        downloadManager.addTask(
          widget.studyContent.id,
          DownloadTask(widget.studyContent.url!, widget.studyContent.path!),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: downloadManager,
        child: Consumer<DownloadManager>(
            builder: (context, model, _) =>
                model.hasTask(widget.studyContent.id)
                    ? ChangeNotifierProvider.value(
                        value: model.getTask(widget.studyContent.id)!,
                        child: Consumer<DownloadTask>(
                            builder: (context, model, _) => ListTile(
                                  onLongPress: onLongPress,
                                  onTap: onTap,
                                  leading: getTileIcon(),
                                  trailing: getDownloadIcon(task: model),
                                  title: Text(widget.studyContent.name),
                                )))
                    : ListTile(
                        onLongPress: onLongPress,
                        onTap: onTap,
                        leading: getTileIcon(),
                        trailing: getDownloadIcon(),
                        title: Text(widget.studyContent.name),
                      )));
  }

  Widget? getTileIcon() {
    switch (widget.studyContent.type) {
      case ItemType.Folder:
        return Icon(Icons.folder);
      case ItemType.Link:
        return Icon(Icons.insert_link);
      default:
        return Icon(Icons.description);
    }
  }

  Widget? getDownloadIcon({DownloadTask? task = null}) {
    if (widget.studyContent.type == ItemType.Link) {
      return Icon(Icons.open_in_new);
    } else if (widget.studyContent.type == ItemType.File) {
      if (task != null) {
        return SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
              value: task.progress, color: Colors.yellow, strokeWidth: 3.0),
        );
      } else if (isDownloaded()) {
        return Icon(Icons.file_download_done_sharp);
      } else {
        return Icon(Icons.download_sharp);
      }
    } else {
      return null;
    }
  }

  bool isDownloaded() {
    return File(tempDir.path + widget.studyContent.path!).existsSync();
  }
}
