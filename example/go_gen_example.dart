import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:go_gen/go_gen.dart';

import 'Package.dart';

void main() {
  //provide golang package path here.
  var path = "./example/package_eg";
  //this method should be called to generate the dll file.
  GenerateBinding(filePath: path).start();

  //After generating the dll file import and use freely.
  // DynamicLibrary d = DynamicLibrary.open('./golangDirectory/mydll.dll');
  // PackageEg p = PackageEg(d);
  // p.Temp();
  // print(p.Temp1(''.toNativeUtf8().cast()).value);
}
