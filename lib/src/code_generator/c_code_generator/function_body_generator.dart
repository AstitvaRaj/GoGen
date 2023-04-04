import 'dart:ffi';

class CFunctionBodyGenerator {
  late String _functionName;

  late String _returnType;
  late String _structName;
  late List<List<String>> _paramList;

  CFunctionBodyGenerator(
      String functionName, String returnType, String paramList,
      {String? structName}) {
    _functionName = functionName;
    _returnType = returnType;
    _structName = structName ?? '';
    _paramList = List.empty(growable: true);
    paramList.split(',').forEach((element) {
      _paramList.add(element.trim().split(' '));
    });
    print(
        'function name -> $functionName, return type -> $returnType, param -> $paramList');
  }

  // String _intTypeBody() =>
  // IntegerBodyGenerator(_functionName, _paramList).generateBody();

  // String _stringTypeBody() =>
  // StringBodyGenerator(_functionName, _paramList).generateBody();
//
  // String _structTypeBody() =>
  // StructBodyGenerator(_functionName, _paramList, _returnType)
  // .generateBody();

  String generateBody() {
    String body = '';
    String paramVariable = '  ';
    for (var element in _paramList) {
      if(element.length==2) {
        paramVariable = '$paramVariable ${element[1]},';
      }
    }
    body =
        '${_returnType == 'void' ? '' : 'return'} Go_$_functionName(${paramVariable.substring(0, paramVariable.length - 1)});';
    return body;
  }
}
