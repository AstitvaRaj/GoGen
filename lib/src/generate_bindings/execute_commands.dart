import 'dart:io';

class CommandsExecute {
  void generateDynamicLibrary(String packagePath, String packageName) {
    print("Dynamic Library generation initiated!!");
    var p = Process.runSync('go', ['mod', 'init', 'main'],
        workingDirectory: "./golangDirectory");
    print(p.stdout);
    p = Process.runSync(
        'go', ["mod", "edit", "-replace", '$packageName=${packagePath}'],
        workingDirectory: "./golangDirectory");
    p = Process.runSync('go', ['fmt'], workingDirectory: "./golangDirectory");
    print(p.stdout.toString());
    p = Process.runSync('go', ['mod', 'tidy'],
        workingDirectory: "./golangDirectory");
    print(p.stdout.toString());

    print(p.stderr.toString());
    p = Process.runSync(
        'go',
        [
          'build',
          '-buildmode=c-archive',
          '-o',
          'go_generated_dll.o',
          'golang_bindings.go'
        ],
        workingDirectory: "./golangDirectory",
        runInShell: true);
    print(p.stdout.toString());

    print(p.stderr.toString());

    p = Process.runSync('gcc', ['-c', 'c_binding.c'],
        workingDirectory: "./golangDirectory");
    print(p.stdout.toString());

    print(p.stderr.toString());

    p = Process.runSync(
        'gcc',
        [
          '-shared',
          '-o',
          'go_project.dll',
          'c_binding.o',
          'go_generated_dll.o'
        ],
        workingDirectory: "./golangDirectory");
    print(p.stderr.toString());
    p = Process.runSync('dart', ['run', 'ffigen'], workingDirectory: "./");
    print(p.stderr.toString());
  }
}
