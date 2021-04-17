import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

class Downloadable {
  final String downloadLink;
  final String fileAddress;

  Downloadable({
    required this.downloadLink,
    required this.fileAddress,
  });

  bool _isDownloading = false;
  CancelToken _cancelToken = CancelToken();
  StreamController<double> _progressController =
      StreamController<double>.broadcast();

  bool get downloading => _isDownloading;

  bool get downloaded => File(fileAddress).existsSync();

  File get file => File(fileAddress);

  late Dio dio;

  List<VoidCallback> _listerners = [];
  void notifyListeners() {
    _listerners.forEach((f) => f());
  }

  Stream<double> download(VoidCallback onDownloadComplete) {
    if (_isDownloading) {
      _listerners.add(onDownloadComplete);
      return _progressController.stream;
    } else {
      _listerners.add(onDownloadComplete);
      _isDownloading = true;
      dio = Dio();
      dio.download(
        downloadLink,
        fileAddress,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double percentage = (received / total);
            _progressController.sink.add(percentage);
          }
        },
        deleteOnError: true,
      )..then((_) {
          _isDownloading = false;
          _progressController.sink.close();
          notifyListeners();
          _listerners.clear();
        });
      return _progressController.stream;
    }
  }

  void cancel() {
    _cancelToken.cancel();
  }
}
