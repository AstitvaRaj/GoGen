import 'dart:ffi';
import 'dart:io';

import '../parser/ast_parser.dart';

abstract class FileGenerator {
  late String golangDirectory;

  late Pointer<node> pointer;

  String? goModuleName;

  FileGenerator(this.golangDirectory, this.pointer, {this.goModuleName});

  void createFile(String fileName) {
    var diarectory = Directory(golangDirectory);
    if (!diarectory.existsSync()) {
      diarectory.createSync(recursive: true);
    }
    File file = File("$golangDirectory\\$fileName");
     file.createSync();
    file.writeAsStringSync(getFileContent());
  }

  String getFileContent();
}
