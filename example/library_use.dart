import 'dart:ffi';
import 'Package.dart';

void main() {
  //Import Dynamic Library and using ffigen generate Dart Bindings using C_binding.h file
  DynamicLibrary library = DynamicLibrary.open('./golangDirectory/go_project.dll');
  PackageEg packageEg = PackageEg(library);
  print(packageEg.CMultiply(2, 6).value);
}
