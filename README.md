<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: GoGen package is a dart package use for generating dart binding for go package.

## Usage
First configure pubsec.yaml for ffigen to generate dart binding. 'c_binding.h' file will will be use to generate the dart binding. So configure pubsec.yaml accordingly.
To generate bindings use following code to generate binding.
packagePath variable will contain a Full path of the golang package. 

```dart
var packagePath = "D:\\Projects\\Dart Projects\\gsoc23sample\\go_gen\\example\\package_eg";
GenerateBinding(packagePath: packagePath).start(); 
```

Generated Library name will be 'go_project.dll' so to use golang package from dart, go_project.dll file must be imported.

```dart
DynamicLibrary library = DynamicLibrary.open('./golangDirectory/go_project.dll');
```

## Note

This is a prototype for GSOC23 project. Hence this package have following restrictions:
1. This package can take Int, String and Struct data type as
an argument and additionally void as a return data type.
2. This package cannot take a pointer as an argument and
Custom structures should also follow this rule.
