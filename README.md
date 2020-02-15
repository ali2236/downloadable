# downloadable

Downloadable is a file that might be in internal storage or still not downloaded.

#### how to crate a downloadable

```dart
var downloadable = Downloadable(
  downloadLink: 'www.example.com/files/downloadable.file',
  fileAddress: tempFolder + '/files/downloadable.file',
); 
```

#### check if its downloaded

```dart

var downloaded = await downloadable.downloaded;

```

#### start a download

```dart
if(
!downloaded){

var onDownloadComplete = (){
    print('download complete!');  
  };
  
  var progressStream = downloadable.download(onDownloadComplete);
  
  progressStream.listen((p){
    print('${p*100}%...');
  });
  
}
```

#### Cancel a download

```dart
downloadable.cancel();
```