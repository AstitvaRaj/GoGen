import 'dart:io';

class CommandsExecute {
  void generateDynamicLibrary(String packagePath, String packageName) {
    print("Dynamic Library generation initiated!!");
    var p = Process.runSync('go', ['mod', 'init', 'main'],
        workingDirectory: "./golangDirectory");
    Process.runSync('go mod edit -replace $packageName=$packagePath', [],
        workingDirectory: "./golangDirectory",runInShell: true);
    Process.runSync('go', ['mod', 'fmt'],
        workingDirectory: "./golangDirectory");
    Process.runSync('go', ['mod', 'tidy'],
        workingDirectory: "./golangDirectory");
    Process.runSync(
        'go build -buildmode=c-archive -o generated_dll.o golang_bindings.go',
        [],
        workingDirectory: "./golangDirectory");

    Process.runSync('gcc -shared -o mydll.dll c_binding.c generated_dll.o', [],
        workingDirectory: "./golangDirectory");
  }
}
