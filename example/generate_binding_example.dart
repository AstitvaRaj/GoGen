import 'package:go_gen/go_gen.dart';

void main() {
  //Provide Go Package Path Here
  var packagePath = "D:\\Projects\\Dart Projects\\gsoc23sample\\go_gen\\example\\package_eg";
  GenerateBinding(packagePath: packagePath).start(); 
}
