import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wind/model/studycontent.dart';
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
      onTap: () async {
        if(widget.studyContent.type == ItemType.Folder) {
          Navigator.of(context).pushNamed('/studycontent',
              arguments: {
                'studyRouteId': widget.studyRouteId,
                'parentId': widget.studyContent.id
              });
        } else if(widget.studyContent.type == ItemType.File){
          if(isDownloading){
            cancelToken!.cancel();
            setState(() {
              isDownloading = false;
              downloadProgress = 0;
            });
          } else {
            isDownloading = true;
            cancelToken = CancelToken();
            await ELO.downloadFile(
              "https://elo.windesheim.nl" + widget.studyContent.url!,
                await getTemporaryDirectory() + widget.studyContent.path,
                cancelToken!,
                (count, total){
              setState(() {
                downloadProgress = count / total;
              });
            });
          }

        }
      },
      leading: widget.studyContent.type == ItemType.Folder ? Icon(Icons.folder) : Icon(Icons.file_present),
      trailing: getDownloadIcon(),
      title: Text(widget.studyContent.name),
    );
  }

  Widget? getDownloadIcon(){
    if(widget.studyContent.type == ItemType.Link){
      return Icon(Icons.open_in_new);
    } else if(widget.studyContent.type == ItemType.File){
      if(!isDownloading){
        return Icon(Icons.download_sharp);
      } else if(isDownloading){
        if(downloadProgress != 1)
          return CircularProgressIndicator(value: downloadProgress);
        else
          return Icon(Icons.download_done_sharp);
      }
    } else {
      return null;
    }
  }
}