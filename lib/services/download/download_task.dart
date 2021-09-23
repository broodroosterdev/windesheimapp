import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wind/services/api/elo.dart';

import '../../providers.dart';

class DownloadTask extends ChangeNotifier {
  final String url;
  final String path;
  double progress = 0;
  late CancelToken cancelToken;

  DownloadTask(this.url, this.path);

  Future<void> startDownload() async{
    cancelToken = CancelToken();
    await ELO.downloadFile(
        "https://elo.windesheim.nl" + url,
        tempDir.path + path,
        cancelToken,
        (count, total) {
          progress = count / total;
          notifyListeners();
        },
    );
  }

  void cancelDownload(){
    cancelToken.cancel();
  }
}