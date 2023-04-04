import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:go_gen/src/code_generator/golang_code_generator/struct_info_container.dart';
import 'package:go_gen/src/parser/ast_parser.dart';

class GolangTypeGenerator {
  late final Pointer<genDecl> _genDeclPtr;
  late Uint64List _specs;
  GolangTypeGenerator(this._genDeclPtr);

  String generateStructType() {
    return _generateStruc();
  }

  String _generateStruc() {
    String struct = '';
    _specs = _genDeclPtr.ref.specs
        .cast<Uint64>()
        .asTypedList(_genDeclPtr.ref.specsLength);
    for (var pointer in _specs) {
      struct = _generateFields(pointer);
    }
    return struct;
  }

  String _generateFields(int pointer) {
    String fields = 'type ';
    var fieldMap = {};
    Pointer<typeSpec> typeSpecs = Pointer.fromAddress(pointer)
        .cast<node>()
        .ref
        .fieldStruct
        .cast<typeSpec>();
    String structName = typeSpecs.ref.name.cast<Utf8>().toDartString();
    fields = '$fields $structName struct{ \n';
    structMap[structName] = fieldMap;
    Pointer<structType> struct =
        typeSpecs.ref.types.cast<node>().ref.fieldStruct.cast<structType>();
    var length = struct.ref.fields
        .cast<node>()
        .ref
        .fieldStruct
        .cast<fieldList>()
        .ref
        .listLen;
    Uint64List fieldsList = struct.ref.fields
        .cast<node>()
        .ref
        .fieldStruct
        .cast<fieldList>()
        .ref
        .list
        .cast<Uint64>()
        .asTypedList(length);
    for (var pointer in fieldsList) {
      Pointer<field> ptr = Pointer.fromAddress(pointer);
      String fieldsTrimmed = _getFields(ptr).trim();
      fieldMap[fieldsTrimmed.split(' ')[0]] = fieldsTrimmed.split(' ')[1];
      fields = '$fields $fieldsTrimmed\n';
    }

    fields = '$fields }\n';

    return fields;
  }

  String _getFields(Pointer<field> fieldPtr) {
    String fieldData = '';

    int varLength =
        fieldPtr.cast<node>().ref.fieldStruct.cast<field>().ref.nameLen;

    Uint64List list = fieldPtr
        .cast<node>()
        .ref
        .fieldStruct
        .cast<field>()
        .ref
        .names
        .cast<Uint64>()
        .asTypedList(varLength);
    
    Pointer<Utf8> ptr = Pointer.fromAddress(list[0]).cast<node>().ref.fieldStruct.cast<ident>().ref.name.cast<Utf8>();

    fieldData = '${ptr.toDartString()} ${fieldPtr
        .cast<node>()
        .ref
        .fieldStruct
        .cast<field>()
        .ref
        .types
        .cast<node>()
        .ref
        .fieldStruct
        .cast<ident>()
        .ref
        .name
        .cast<Utf8>()
        .toDartString()}\n';
    return fieldData;
  }
}
