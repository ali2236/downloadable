import 'dart:io';

import 'package:downloadable/downloadable.dart';
import 'package:test/test.dart';

void main() {
  group('downloadTest', () {
    test('downloadable image', () async{
      var image = Downloadable(
        downloadLink:
            'https://www.aligator.ir/static/upload/images/anime/monster.jpg',
        fileAddress: 'monster-downloadable.jpg',
      );

      var file = image.file;

      if(file.existsSync()){
        file.deleteSync();
      }

      await image.download(() => {
        print('download complete')
      }).toList();
    });
  });
}
