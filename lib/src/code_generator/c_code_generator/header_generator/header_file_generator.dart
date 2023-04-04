import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:go_gen/src/code_generator/c_code_generator/file_generator.dart';
import 'package:go_gen/src/code_generator/c_code_generator/header_generator/gen_decl_generator.dart';
import 'package:go_gen/src/code_generator/file_generator.dart';
import 'package:go_gen/src/parser/ast_parser.dart';

import '../function_generator.dart';

class CHeaderFileGenerator extends FileGenerator {
  CHeaderFileGenerator(super.golangDirectory, super.pointer);



  @override
  String getFileContent() {
    String fileData = '';
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

    print('HEAEDER FILE___________________________________________$fileData');
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
              '$fileData ${CFunctionGenerator(Pointer.fromAddress(s).cast<node>().ref.fieldStruct.cast<funcDecl>(),headerGen: true).generateFunction()}\n';
         
          break;

        case "*ast.GenDecl":
          fileData =
              '$fileData ${CHeaderGenDeclGenerator(Pointer.fromAddress(s).cast<node>().ref.fieldStruct.cast<genDecl>()).generateDecl()}\n';
          break;
        default:
          break;
      }
    }

    FileGenerator cCodeFileGenerator = CFileGenerator(golangDirectory, pointer);
    cCodeFileGenerator.createFile('c_binding.c');
    return fileData;
  }
}
