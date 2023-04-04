import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:go_gen/src/code_generator/file_generator.dart';
import 'package:go_gen/src/code_generator/golang_code_generator/file_generator.dart';
import 'package:go_gen/src/generate_bindings/execute_commands.dart';
import 'code_generator/c_code_generator/header_generator/header_file_generator.dart';
import 'parser/ast_parser.dart';

class GenerateBinding {
  late String _packagePath;

  final String _golangDirectory = 'golangDirectory';
  final String _cFileName = 'c_binding.h';
  final String _goFileName = 'golang_bindings.go';

  late AstParser parser;

  GenerateBinding({required String packagePath}) {
    _packagePath = packagePath;
    parser = AstParser(DynamicLibrary.open(
        "lib\\src\\parser\\native_data\\go_ast_gen\\ast_gen.dll"));
  }

  void start() {
    Pointer<node> nodes = parser
        .getAstHead(_packagePath.toNativeUtf8(allocator: malloc).cast())
        .cast<node>();
    print("AST GENEARTION COMPLETED!!!");
    print(_getGolangModuleName());
    _generateGolangPackage(nodes);
  }

  String _getGolangModuleName() {
    String moduleName = parser
        .getModFileName(
            '$_packagePath/go.mod'.toNativeUtf8(allocator: malloc).cast())
        .cast<Utf8>()
        .toDartString();
    return moduleName;
  }

  void _generateGolangPackage(Pointer<node> nodes) {
    FileGenerator golangFileGenerator = GolangFileGenerator(
        _golangDirectory, nodes,
        goModuleName: _getGolangModuleName());
    FileGenerator cHeaderFileGenerator =
        CHeaderFileGenerator(_golangDirectory, nodes);
    golangFileGenerator.createFile(_goFileName);
    cHeaderFileGenerator.createFile(_cFileName);

    // CommandsExecute().generateDynamicLibrary(_filePath, _getGolangModuleName());
  }
}
