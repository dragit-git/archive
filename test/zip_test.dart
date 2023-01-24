import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:test/test.dart';

import '_test_util.dart';

Future<void> extractArchiveToDisk(ArchiveDirectory archive, String root) async {
  for (final e in archive) {
    final path = '$root/${e.fullPathName}';
    if (e is ArchiveDirectory) {
      await Directory(path)
          .create(recursive: true);
      await extractArchiveToDisk(e, root);
    } else {
      final f = e as ArchiveFile;
      final output = OutputStreamFile(path)
      ..open();
      f.writeContent(output);
      final bytes = f.readBytes();
      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThan(0));
    }
  }
}

void main() async {
  group('Zip', () {
    test('decode', () async {
      final archive = ZipDecoder().decodeStream(
          InputStreamMemory(File('test/_data/zip/android-javadoc.zip').readAsBytesSync()));

      final t1 = Stopwatch()..start();
      await extractArchiveToDisk(archive, '$testOutputPath/android-javadoc');
      t1.stop();
      //print(t1.elapsedMilliseconds);
    });
  });
}
