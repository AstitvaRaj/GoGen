import 'package:go_gen/src/code_generator/converter.dart';

class IntegerConverter implements Converter{
  @override
  String cToGo(String name) => 'int($name)';

  @override
  String goToC(String name) => 'C.int($name)';

}