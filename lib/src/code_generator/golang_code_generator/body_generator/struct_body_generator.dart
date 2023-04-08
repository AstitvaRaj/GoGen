import 'package:go_gen/src/code_generator/golang_code_generator/body_generator.dart';
import 'package:go_gen/src/code_generator/golang_code_generator/converter/integer_converter.dart';
import 'package:go_gen/src/code_generator/golang_code_generator/converter/string_converter.dart';
import 'package:go_gen/src/code_generator/golang_code_generator/struct_info_container.dart';

class StructBodyGenerator extends BodyGenerator {
  late String _functionName;

  late String structName;

  late String type;

  late String _cStructVariableName;

  late String _goStructVariableName;
  late List<List<String>> _paramList;

  StructBodyGenerator(this._functionName, this._paramList, this.type)
      : super(_functionName, _paramList,'struct') {
    structName = type.substring(10).trim();
    _cStructVariableName = 'cStruct';
    _goStructVariableName = 'result';
  }


  String _allocateCMemory() =>
      'resultPtr := ($type)(C.malloc(C.sizeof_struct_$structName))\n';

  String _putElementInMemory() => '*resultPtr = $_cStructVariableName\n';

  String _returnResult() => 'return resultPtr\n';

  String _declareCStruct() =>
      '$_cStructVariableName := C.struct_$structName{}\n';

  String _generateCStmt(String cStructVar, String result, String type) {
    String stmt = '';
    if (structMap.containsKey(type)) {
      structMap[type].forEach((key, value) => {
            stmt =
                '$stmt${_generateCStmt('$cStructVar.$key', '$result.$key', value)}'
          });
      return stmt;
    }
    switch (type) {
      case 'int':
        stmt = '$cStructVar = ${IntegerConverter().goToC(result)}\n';
        break;
      case 'string':
        stmt = '$cStructVar = ${StringConverter().goToC(result)}\n';
        break;
    }
    return stmt;
  }

  String generateBody() {
    String body = '';
    body = '$body ${getResult()}\n';
    body = '$body ${_allocateCMemory()}';
    body = '$body ${_declareCStruct()}';
    body =
        '$body ${_generateCStmt(_cStructVariableName, _goStructVariableName, structName)}';
    body = '$body ${_putElementInMemory()}';
    body = '$body ${_returnResult()}';
    return body;
  }
}
