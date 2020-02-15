import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

class Downloadable{

  final String downloadLink;
  final String fileAddress;

  Downloadable({
    this.downloadLink,
    this.fileAddress,
  });

  bool _isDownloading = false;
  CancelToken _cancelToken = CancelToken();
  StreamController<double> _progressController = StreamController<
      double>.broadcast();
  Future<Response> _download;

  bool get downloading => _isDownloading;

  Future<bool> get downloaded async => File(fileAddress).exists();
  
  File get file => File(fileAddress);

  Dio dio;

  List<VoidCallback> _listerners = [];
  void notifyListeners() {
    _listerners.forEach((f)=>f());
  }

  Stream<double> download(VoidCallback onDownloadComplete) {
    if(_isDownloading){
      _listerners.add(onDownloadComplete);
    } else {
      _listerners.add(onDownloadComplete);
      _isDownloading = true;
      dio = Dio();
      _download = dio.download(
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
      )
        ..then((_) {
          _isDownloading = false;
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
