import 'package:go_gen/src/code_generator/import_generator.dart';

class CImportGenerator extends ImportGenerator {
  @override
  String generateImportStmt() {
    return '#include "c_binding.h"\n#include "generated_dll.h"\n';
  }
}
