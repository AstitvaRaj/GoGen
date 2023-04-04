import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:go_gen/src/parser/ast_parser.dart';

import '../../gen_decl_generator.dart';
import 'struct_generator.dart';

class CHeaderGenDeclGenerator implements GenDeclGenerator {
  late Pointer<genDecl> _genDeclr;

  CHeaderGenDeclGenerator(Pointer<genDecl> genDeclr) {
    _genDeclr = genDeclr;
  }
  
  @override
  String generateDecl() {
    switch (_genDeclr.ref.token.cast<Utf8>().toDartString()) {
      case "type":
        return CHeaderStructGenerator(_genDeclr).generateStructType();
      default:
        break;
    }
    return "";
  }
}
