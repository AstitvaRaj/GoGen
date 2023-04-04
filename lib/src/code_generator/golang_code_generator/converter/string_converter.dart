import 'package:go_gen/src/code_generator/converter.dart';

class StringConverter implements Converter{
  
  @override
  String cToGo(String name) => 'C.GoString($name)';

  @override
  String goToC(String name) => 'C.CString($name)';

}