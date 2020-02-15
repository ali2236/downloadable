import 'package:downloadable/downloadable.dart';

main() async{

  var tempFolder = '';

  var downloadable = Downloadable(
    downloadLink: 'www.example.com/files/downloadable.file',
    fileAddress: tempFolder + '/files/downloadable.file',
  );

  var downloaded = await downloadable.downloaded;

  if(!downloaded){

    var onDownloadComplete = (){
      print('download complete!');
    };

    var progressStream = downloadable.download(onDownloadComplete);

    progressStream.listen((p){
      print('${p*100}%...');
    });
  }

}