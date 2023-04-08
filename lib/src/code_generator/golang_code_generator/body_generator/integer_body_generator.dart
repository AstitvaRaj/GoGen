import 'package:go_gen/src/code_generator/golang_code_generator/body_generator.dart';
import 'package:go_gen/src/code_generator/golang_code_generator/converter/integer_converter.dart';
import 'package:go_gen/src/code_generator/golang_code_generator/data_type_map.dart';

class IntegerBodyGenerator extends BodyGenerator {
  final String _functionName;

  final List<List<String>> _paramList;

  IntegerBodyGenerator(this._functionName, this._paramList)
      : super(_functionName, _paramList,'int');

  String _allocateCMemory() => 'resultPtr := (*C.int)(C.malloc(C.sizeof_int))';

  String _putElementInMemory() =>
      '*resultPtr = ${IntegerConverter().goToC('result')}';

  String _returnResult() => 'return resultPtr';

  String generateBody() {
    return '${getResult()}\n${_allocateCMemory()}\n${_putElementInMemory()}\n${_returnResult()}';
  }
}
