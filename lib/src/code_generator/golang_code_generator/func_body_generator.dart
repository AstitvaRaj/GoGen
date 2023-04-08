import 'body_generator/integer_body_generator.dart';
import 'body_generator/string_body_generator.dart';
import 'body_generator/struct_body_generator.dart';
import 'body_generator/void_body_generator.dart';

class GolangFunctionBodyGenerator {
  late String _functionName;

  late String _returnType;
  late String _structName;
  late List<List<String>> _paramList;

  GolangFunctionBodyGenerator(
      String functionName, String returnType, String paramList,
      {String? structName}) {
    _functionName = functionName;
    _returnType = returnType;
    _structName = structName ?? '';
    _paramList = List.empty(growable: true);
    paramList.split(',').forEach((element) {
      _paramList.add(element.trim().split(' '));
    });
  }

  String _intTypeBody() =>
      IntegerBodyGenerator(_functionName, _paramList).generateBody();

  String _stringTypeBody() =>
      StringBodyGenerator(_functionName, _paramList).generateBody();

  String _structTypeBody() =>
      StructBodyGenerator(_functionName, _paramList, _returnType)
          .generateBody();
  
  String _voidTypeBody() =>
      VoidBodyGenerator(_functionName, _paramList)
          .generateBody();

  String generateBody() {
    switch (_returnType) {
      case '*C.int':
        return _intTypeBody();
      case '*C.char':
        return _stringTypeBody();
      case 'void':
        return _voidTypeBody();
      default:
        return _structTypeBody();
    }
  }
}
