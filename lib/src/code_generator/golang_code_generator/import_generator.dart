import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:go_gen/src/code_generator/import_generator.dart';

import '../../parser/ast_parser.dart';

class GolangImportGenerator implements ImportGenerator {
  late genDecl _genDecl;

  String? goModuleName;

  // GolangImportGenerator(Pointer<genDecl> genDecl) {
  //   _genDecl = genDecl.ref;
  // }

  GolangImportGenerator({this.goModuleName});

  @override
  String generateImportStmt() =>
      _generatePreamble() + _generateImportStatement();

  // String _generateStruc() {
  //   String header = '';
  //   if (_genDecl.specsLength == 0) {
  //     return header;
  //   }
  //   header = 'import (\n';
  //   Uint64List pointers =
  //       _genDecl.specs.cast<Uint64>().asTypedList(_genDecl.specsLength);
  //   late importSpec spec;
  //   for(int element in pointers) {
  //     spec = Pointer.fromAddress(element).cast<node>().ref.fieldStruct.cast<importSpec>().ref;
  //     switch (spec.kind.cast<Utf8>().toDartString()) {
  //       case "STRING":
  //         header = '$header ${spec.value.cast<Utf8>().toDartString()}\n';
  //         break;
  //       default:
  //         return '';
  //     }
  //   }
  //   header = '$header )';
  //   return header;
  // }

  String _generatePreamble() =>
      "package main\n\n//#include \"c_binding.h\" \n//#include<stdlib.h>\nimport \"C\"\n\n";

  String _generateImportStatement() {
    print("fsdffffffffffffffffffff$goModuleName" );
    if (goModuleName!.isEmpty) {
      return "";
    }
    return "import custompackage \"$goModuleName\"\n";
  }
}
