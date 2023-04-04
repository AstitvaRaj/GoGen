import 'package:ffi/ffi.dart';
import 'package:go_gen/src/parser/ast_parser.dart';
import 'dart:ffi';
import '../function_generator.dart';
import 'data_type_map.dart';
import 'func_body_generator.dart';

class GolangFunctionGenerator implements FunctionGenerator {
  late Pointer<funcDecl> funcPtr;
  late Pointer<funcType> funcTypePtr;
  late Pointer<fieldList> fieldListPtr;
  late Pointer<field> fieldPtr;
  late Pointer<ident> identPtr;

  GolangFunctionGenerator(this.funcPtr) {
    funcTypePtr =
        funcPtr.ref.funcTypes.cast<node>().ref.fieldStruct.cast<funcType>();
    print(funcPtr.ref.name.cast<Utf8>().toDartString());
  }

  @override
  String generateBody() {
    String body = '';
    if (generateReturnType().isEmpty) {
      body =
          'custompackage.${funcPtr.ref.name.cast<Utf8>().toDartString()} (${generateParams()})\n';
    } else {
      body = GolangFunctionBodyGenerator(
              funcPtr.ref.name.cast<Utf8>().toDartString(),
              generateReturnType().trim(),
              generateParams())
          .generateBody();
    }
    return '$body\n}';
  }

  @override
  String generateFunction() => generateHeader()  + generateBody();

  @override
  String generateHeader() =>
      '//export Go_${funcPtr.ref.name.cast<Utf8>().toDartString()}\nfunc Go_${funcPtr.ref.name.cast<Utf8>().toDartString()}(${generateParams()}) (${generateReturnType()}){\n';
      

  @override
  String generateParams() {
    String params = '';
    var funcParams = funcPtr.ref.funcTypes
        .cast<node>()
        .ref
        .fieldStruct
        .cast<funcType>()
        .ref
        .params
        .cast<node>()
        .ref
        .fieldStruct
        .cast<fieldList>();
    var paramList =
        funcParams.ref.list.cast<Uint64>().asTypedList(funcParams.ref.listLen);
    for (var paramPtr in paramList) {
      var fieldPtr = Pointer.fromAddress(paramPtr)
          .cast<node>()
          .ref
          .fieldStruct
          .cast<field>();
      var namesList =
          fieldPtr.ref.names.cast<Uint64>().asTypedList(fieldPtr.ref.nameLen);
      var paramType = fieldPtr.ref.types
          .cast<node>()
          .ref
          .fieldStruct
          .cast<ident>()
          .ref
          .name
          .cast<Utf8>()
          .toDartString();
      for (var namePtr in namesList) {
        if (!(params.compareTo('') == 0)) {
          params = '$params ,';
        }
        var paramName = Pointer.fromAddress(namePtr)
            .cast<node>()
            .ref
            .fieldStruct
            .cast<ident>()
            .ref
            .name
            .cast<Utf8>()
            .toDartString();
        params =
            '$params $paramName ${paramDataTypes.containsKey(paramType) ? paramDataTypes[paramType] : 'C.struct_$paramType'}';
      }
    }
    return params;
  }

  @override
  String generateReturnStmnt() => '}';

  @override
  String generateReturnType() {
    if (funcTypePtr.ref.results == nullptr) {
      return "";
    }
    int returnValues = funcTypePtr.ref.results
        .cast<node>()
        .ref
        .fieldStruct
        .cast<fieldList>()
        .ref
        .listLen;

    switch (returnValues) {
      case 1:
        String results = '';
        var funcParams = funcPtr.ref.funcTypes
            .cast<node>()
            .ref
            .fieldStruct
            .cast<funcType>()
            .ref
            .results
            .cast<node>()
            .ref
            .fieldStruct
            .cast<fieldList>();
        if (funcParams == nullptr) {
          return "";
        }
        var resultList = funcParams.ref.list
            .cast<Uint64>()
            .asTypedList(funcParams.ref.listLen);
        for (var paramPtr in resultList) {
          var fieldPtr = Pointer.fromAddress(paramPtr)
              .cast<node>()
              .ref
              .fieldStruct
              .cast<field>();
          var namesList = fieldPtr.ref.names
              .cast<Uint64>()
              .asTypedList(fieldPtr.ref.nameLen);
          var paramType = fieldPtr.ref.types
              .cast<node>()
              .ref
              .fieldStruct
              .cast<ident>()
              .ref
              .name
              .cast<Utf8>()
              .toDartString();

          results =
              ' $results ${returnDataTypes.containsKey(paramType) ? returnDataTypes[paramType] : '*C.struct_$paramType'} ';
        }
        return results;
      default:
        return '';
    }
  }
}
