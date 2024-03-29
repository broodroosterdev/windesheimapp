import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wind/model/studycontent.dart';
import 'package:wind/pages/elo/widgets/confirm_delete_dialog.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/download/download_manager.dart';
import 'package:wind/services/download/download_task.dart';

import 'download_icon.dart';

class StudyContentTile extends StatefulWidget {
  final StudyContent studyContent;
  final int studyRouteId;

  const StudyContentTile(
      {Key? key, required this.studyContent, required this.studyRouteId})
      : super(key: key);

  @override
  _StudyContentTileState createState() => _StudyContentTileState();
}

class _StudyContentTileState extends State<StudyContentTile> {
  void onLongPress() async {
    if (widget.studyContent.type == ItemType.file && isDownloaded()) {
        var shouldDelete = await showDialog(
            context: context,
            builder: (context) => const ConfirmDeleteDialog());
        if(shouldDelete) {
          await File(tempDir.path + widget.studyContent.path!).delete();
          setState(() {});
        }
      }
  }

  void onTap() async {
    if (widget.studyContent.type == ItemType.folder) {
      Navigator.of(context).pushNamed('/studycontent', arguments: {
        'studyRouteId': widget.studyRouteId,
        'parentId': widget.studyContent.id
      });
    } else if (widget.studyContent.type == ItemType.link) {
      if (await canLaunch(widget.studyContent.url!)) {
        await launch(widget.studyContent.url!);
      }
    } else if (widget.studyContent.type == ItemType.file) {
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
    } else if (widget.studyContent.type == ItemType.page) {
      Navigator.of(context).pushNamed('/studydocument', arguments: {
        'url': widget.studyContent.url!,
        'name': widget.studyContent.name
      });
    } else if (widget.studyContent.type == ItemType.handin) {
      Navigator.of(context).pushNamed('/studyhandin', arguments: {
        'resourceId': widget.studyContent.resourceId!,
        'name': widget.studyContent.name
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: downloadManager,
        child: Consumer<DownloadManager>(
            builder: (context, model, _) => ChangeNotifierProvider.value(
                        value: model.getTask(widget.studyContent.id),
                        child: Consumer<DownloadTask?>(
                            builder: (context, model, _) => ListTile(
                                  onLongPress: onLongPress,
                                  onTap: onTap,
                                  leading: Icon(getTileIcon(), color: Theme.of(context).primaryColor),
                                  trailing: getDownloadIcon(task: model),
                                  title: Text(widget.studyContent.name),
                                )))
        ),
    );
  }

  IconData getTileIcon() {
    switch (widget.studyContent.type) {
      case ItemType.folder:
        return Icons.folder;
      case ItemType.link:
        return Icons.insert_link;
      case ItemType.handin:
        return Icons.archive;
      default:
        return Icons.description;
    }
  }

  Widget? getDownloadIcon({DownloadTask? task}) {
    if (widget.studyContent.type == ItemType.link) {
      return Icon(Icons.open_in_new, color: Theme.of(context).colorScheme.secondary);
    } else if (widget.studyContent.type == ItemType.file) {
      return DownloadIcon(task, widget.studyContent.path!);
    } else {
      return null;
    }
  }

  bool isDownloaded() {
    return File(tempDir.path + widget.studyContent.path!).existsSync();
  }
}
