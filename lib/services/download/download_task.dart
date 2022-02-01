import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wind/services/api/elo.dart';

import '../../providers.dart';

class DownloadTask extends ChangeNotifier {
  final String url;
  final String path;
  double? progress;
  late CancelToken cancelToken;

  DownloadTask(this.url, this.path);

  Future<void> startDownload() async {
    cancelToken = CancelToken();
    bool downloadSuccess = await ELO.downloadFile(
      "https://elo.windesheim.nl" + url,
      tempDir.path + path + '.download',
      cancelToken,
      (count, total) {
        progress = count / total;
        notifyListeners();
      },
    );
    if (downloadSuccess) {
      await File(tempDir.path + path + '.download').rename(tempDir.path + path);
    }
  }

  void cancelDownload() {
    cancelToken.cancel();
  }
}
