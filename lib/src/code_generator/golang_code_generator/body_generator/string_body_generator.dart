import 'package:go_gen/src/code_generator/golang_code_generator/body_generator.dart';
import 'package:go_gen/src/code_generator/golang_code_generator/converter/string_converter.dart';

class StringBodyGenerator extends BodyGenerator {
  final String _functionName;

  final List<List<String>> _paramList;

  StringBodyGenerator(this._functionName, this._paramList)
      : super(_functionName, _paramList);

  String _returnResult() => 'return ${StringConverter().goToC('result')}';

  String generateBody() {
    return '${getResult()}\n${_returnResult()}';
  }
}
