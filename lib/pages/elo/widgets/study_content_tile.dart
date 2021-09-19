import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wind/model/studycontent.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/api/elo.dart';

class StudyContentTile extends StatefulWidget {
  StudyContent studyContent;
  int studyRouteId;
  StudyContentTile({Key? key, required this.studyContent, required this.studyRouteId}) : super(key: key);

  @override
  _StudyContentTileState createState() => _StudyContentTileState();
}

class _StudyContentTileState extends State<StudyContentTile> {
  bool isDownloading = false;
  double downloadProgress = 0;
  CancelToken? cancelToken;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () async {
        if(widget.studyContent.type == ItemType.File){
          if(isDownloaded()){
            await File(tempDir.path + widget.studyContent.path!).delete();
            setState(() {});
          }
        }
      },
      onTap: () async {
        if(widget.studyContent.type == ItemType.Folder) {
          Navigator.of(context).pushNamed('/studycontent',
              arguments: {
                'studyRouteId': widget.studyRouteId,
                'parentId': widget.studyContent.id
              });
        } else if(widget.studyContent.type == ItemType.File){
          if(isDownloading) {
            cancelToken!.cancel();
            setState(() {
              isDownloading = false;
              downloadProgress = 0;
            });
          } else if(isDownloaded()){
            await OpenFile.open(tempDir.path + widget.studyContent.path!);
          } else {
            setState(() {
              isDownloading = true;
            });
            cancelToken = CancelToken();
            await ELO.downloadFile(
              "https://elo.windesheim.nl" + widget.studyContent.url!,
                tempDir.path + widget.studyContent.path!,
                cancelToken!,
                (count, total){
              setState(() {
                downloadProgress = count / total;
              });
            });
            setState(() {
              isDownloading = false;
              downloadProgress = 0;
            });
          }

        }
      },
      leading: widget.studyContent.type == ItemType.Folder ? Icon(Icons.folder) : Icon(Icons.description),
      trailing: getDownloadIcon(),
      title: Text(widget.studyContent.name),
    );
  }

  Widget? getDownloadIcon(){
    if(widget.studyContent.type == ItemType.Link){
      return Icon(Icons.open_in_new);
    } else if(widget.studyContent.type == ItemType.File) {
      if(isDownloading){
        return SizedBox(
          height: 24,
            width: 24,
            child: CircularProgressIndicator(value: downloadProgress, color: Colors.yellow),
        );
      } else if(isDownloaded()) {
        return Icon(Icons.file_download_done_sharp);
      } else {
        return Icon(Icons.download_sharp);
      }
    } else {
      return null;
    }
  }

  bool isDownloaded(){
    return File(tempDir.path + widget.studyContent.path!).existsSync();
  }
}