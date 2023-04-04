import 'dart:ffi';
import 'package:ffi/ffi.dart';

import '../../parser/ast_parser.dart';
import '../file_generator.dart';
import 'GolangGenDeclGenerator.dart';
import 'func_generator.dart';
import 'import_generator.dart';

class GolangFileGenerator extends FileGenerator {
  GolangFileGenerator(super.golangDirectory, super.pointer,{super.goModuleName});

  @override
  String getFileContent() {
    String fileData = '';
    fileData = GolangImportGenerator(goModuleName: super.goModuleName).generateImportStmt();
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

    fileData = "$fileData\nfunc main(){}";
    return fileData;
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
              '$fileData ${GolangFunctionGenerator(Pointer.fromAddress(s).cast<node>().ref.fieldStruct.cast<funcDecl>()).generateFunction()}\n';
          break;
        case "*ast.GenDecl":
          fileData =
              '$fileData ${GolangGenDeclGenerator(Pointer.fromAddress(s).cast<node>().ref.fieldStruct.cast<genDecl>()).generateDecl()}\n';
          break;
        default:
          break;
      }
    }

    return fileData;
  }
}
