import 'package:flutter/cupertino.dart';

import 'download_task.dart';

class DownloadManager extends ChangeNotifier {
  Map<int, DownloadTask> tasks = {};

  void addTask(int id, DownloadTask task) {
    tasks.putIfAbsent(id, () => task);
    task.startDownload().then((_) {
      tasks.remove(id);
      notifyListeners();
    });
    notifyListeners();
  }

  void cancelTask(int id) {
    getTask(id)?.cancelDownload();
    tasks.remove(id);
    notifyListeners();
  }

  bool hasTask(int id) {
    return tasks.containsKey(id);
  }

  DownloadTask? getTask(int id) {
    return tasks[id];
  }
}
