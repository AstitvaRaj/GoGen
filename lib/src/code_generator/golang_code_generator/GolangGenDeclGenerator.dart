import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:go_gen/src/code_generator/golang_code_generator/import_generator.dart';
import 'package:go_gen/src/code_generator/golang_code_generator/type_generator.dart';
import 'package:go_gen/src/parser/ast_parser.dart';
import '../gen_decl_generator.dart';

class GolangGenDeclGenerator implements GenDeclGenerator {
  late Pointer<genDecl> _genDeclr;

  GolangGenDeclGenerator(Pointer<genDecl> genDeclr) {
    _genDeclr = genDeclr;
  }
  @override
  String generateDecl() {
    switch (_genDeclr.ref.token.cast<Utf8>().toDartString()) {
      case "type":
        return GolangTypeGenerator(_genDeclr).generateStructType();
      default:
        break;
    }
    return "";
  }
}
