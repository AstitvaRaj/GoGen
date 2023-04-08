
import '../body_generator.dart';
import '../converter/integer_converter.dart';
import '../converter/string_converter.dart';
import '../struct_info_container.dart';

class VoidBodyGenerator extends BodyGenerator {
  late String _functionName;

  late String structName;

  late String _cStructVariableName;

  late String _goStructVariableName;
  late List<List<String>> _paramList;

  VoidBodyGenerator(this._functionName, this._paramList)
      : super(_functionName, _paramList,'void') {
    _cStructVariableName = 'cStruct';
    _goStructVariableName = 'result';
  }
  String generateBody() {
    print("void Param__________________________________________________________________$_paramList");
    String body = '';
    body = '$body ${getResult()}\n';
    return body;
  }
}
