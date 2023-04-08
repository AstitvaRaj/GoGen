import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:go_gen/src/code_generator/file_generator.dart';
import '../../parser/ast_parser.dart';
import 'function_generator.dart';
import 'import_generator.dart';

class CFileGenerator extends FileGenerator {
  CFileGenerator(super.golangDirectory, super.pointer);

  @override
  String getFileContent() {
    String fileData = '';
    fileData = CImportGenerator().generateImportStmt();
    Pointer<package> p = super.pointer.ref.fieldStruct.cast<package>();
    var fileList = p.ref.file.cast<Uint64>().asTypedList(p.ref.fileLen);
    for (var element in fileList) {
      print(Pointer.fromAddress(element)
          .cast<node>()
          .ref
          .kind
          .cast<Utf8>()
          .toDartString());
      fileData =
          '$fileData ${_singleFile(Pointer.fromAddress(element).cast())}';
    }
    return '$fileData\nint main(){return 0;}';
  }

  String _singleFile(Pointer<node> nodes) {
    String fileData = '';
    var fileDecl = nodes.ref.fieldStruct
        .cast<file>()
        .ref
        .decl
        .cast<Uint64>()
        .asTypedList(nodes.ref.fieldStruct.cast<file>().ref.declLen);
    for (var s in fileDecl) {
      switch (Pointer.fromAddress(s)
          .cast<node>()
          .ref
          .kind
          .cast<Utf8>()
          .toDartString()) {
        case "*ast.FuncDecl":
          fileData =
              '$fileData __declspec(dllexport) ${CFunctionGenerator(Pointer.fromAddress(s).cast<node>().ref.fieldStruct.cast<funcDecl>()).generateFunction()}\n';
          break;
        default:
          break;
      }
    }
    return fileData;
  }
}
