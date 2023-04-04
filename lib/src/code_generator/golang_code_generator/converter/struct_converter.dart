import 'package:go_gen/src/code_generator/converter.dart';

import '../struct_info_container.dart';
import 'integer_converter.dart';
import 'string_converter.dart';

class StructConverter implements Converter {
  @override
  String cToGo(String name) {
    return '';
  }

  @override
  String goToC(String name) {
    return '';
  }

  String generateCToGoStmt(String goStructVar, String result, String type) {
    String stmt = '';
    if (structMap.containsKey(type)) {
      structMap[type].forEach((key, value) => {
            stmt =
                '$stmt${generateCToGoStmt('$goStructVar.$key', '$result.$key', value)}'
          });
      return stmt;
    }
    switch (type) {
      case 'int':
        stmt = '$goStructVar = ${IntegerConverter().cToGo(result)}\n';
        break;
      case 'string':
        stmt = '$goStructVar = ${StringConverter().cToGo(result)}\n';
        break;
    }
    return stmt;
  }
}
