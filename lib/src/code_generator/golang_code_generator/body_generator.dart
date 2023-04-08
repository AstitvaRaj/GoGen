import 'package:go_gen/src/code_generator/golang_code_generator/data_type_map.dart';
import './converter/struct_converter.dart';

abstract class BodyGenerator {
  final String _functionName;
  final List<List<String>> _paramList;
  final String _type;
  BodyGenerator(this._functionName, this._paramList,this._type);

  String _generateCToGoStructStmnt(
          String goVariableName, String cVariableName, String type) =>
      StructConverter().generateCToGoStmt(goVariableName, cVariableName, type);

  String getResult() {
    String temp = '';
    String result = '${_type == 'void'?'':'result :='} custompackage.$_functionName';
    result = '$result( ';
    for (var element in _paramList) { print(element);
      if (element.length > 1) {
       
        if (!cToGoDataType.containsKey(element[1])) {
          temp =
              '${temp}go_${element[0]}:=custompackage.${element[1].trim().substring(10)}{}\n${_generateCToGoStructStmnt('go_${element[0]}', element[0], element[1].trim().substring(10))}\n';
        }
        result =
            '$result${cToGoDataType.containsKey(element[1].trim()) ? '${cToGoDataType[element[1]]}(${element[0].trim()}),' : 'go_${element[0].trim()},'}';
      }
    }
    result = result.substring(0, result.length - 1);
    result = '$result)';
    return '$temp$result';
  }
}
