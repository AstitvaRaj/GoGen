import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:go_gen/src/code_generator/function_generator.dart';

import '../../parser/ast_parser.dart';
import 'data_type_map.dart';
import 'function_body_generator.dart';

class CFunctionGenerator implements FunctionGenerator {
  late Pointer<funcDecl> funcPtr;
  late Pointer<funcType> funcTypePtr;
  late Pointer<fieldList> fieldListPtr;
  late Pointer<field> fieldPtr;
  late Pointer<ident> identPtr;

  bool headerGen;

  CFunctionGenerator(this.funcPtr, {this.headerGen = false}) {
    funcTypePtr =
        funcPtr.ref.funcTypes.cast<node>().ref.fieldStruct.cast<funcType>();
  }

  @override
  String generateBody() {
    String body = '';
    if (generateReturnType().isEmpty) {
      body =
          '{\n${funcPtr.ref.name.cast<Utf8>().toDartString()} (${generateParams()})\n';
    } else {
      body =
          '{\n${CFunctionBodyGenerator(funcPtr.ref.name.cast<Utf8>().toDartString(), generateReturnType().trim(), generateParams()).generateBody()}';
    }
    return '$body\n}';
  }

  @override
  String generateFunction() {
    return '${generateHeader()} ${headerGen ? ';' : generateBody()}';
  }

  @override
  String generateHeader() =>
      '${generateReturnType()} C${funcPtr.ref.name.cast<Utf8>().toDartString()} (${generateParams()})\n';

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
          params = '$params,';
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
            '$params${cParamType.containsKey(paramType) ? cParamType[paramType] : 'C$paramType'} $paramName';
      }
    }
    return params.trim();
  }

  @override
  String generateReturnStmnt() => '}';

  @override
  String generateReturnType() {
    if (funcTypePtr.ref.results == nullptr) {
      return "void";
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
          return "void ";
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
              ' $results ${cReturnTypeCCode.containsKey(paramType) ? cReturnTypeCCode[paramType] : '$paramType*'} ';
        }
        return results;
      default:
        return '';
    }
  }
}
