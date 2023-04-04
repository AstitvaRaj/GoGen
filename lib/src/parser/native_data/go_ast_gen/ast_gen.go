package main

// #include "cstructs.h"
import "C"
import (
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"os"
	"reflect"
	"unsafe"

	"golang.org/x/mod/modfile"
)

func genNode(nodeType string, s unsafe.Pointer) unsafe.Pointer {
	nodePtr := C.malloc(C.sizeof_struct_node)
	node := C.struct_node{kind: C.CString(nodeType), fieldStruct: s}
	*(*C.struct_node)(nodePtr) = node
	return unsafe.Pointer(nodePtr)
}

func genFile(node ast.Node) unsafe.Pointer {
	fileDeclPtr := C.malloc(C.sizeof_struct_file)
	fileData := node.(*ast.File)
	declListPtr := C.malloc(C.size_t(len(fileData.Decls)) * C.size_t(unsafe.Sizeof(uintptr(0))))
	for i, decl := range fileData.Decls {
		*(*uintptr)(unsafe.Pointer(uintptr(unsafe.Pointer(declListPtr)) + uintptr(i)*unsafe.Sizeof(uintptr(0)))) = uintptr(generateFileAst(decl))
	}
	file := C.struct_file{name: C.CString(fileData.Name.Name), declLen: C.int(len(fileData.Decls)), decl: unsafe.Pointer(declListPtr)}
	*(*C.struct_file)(fileDeclPtr) = file
	return genNode("*ast.File", fileDeclPtr)
}

func genFuncDecl(node ast.Node) unsafe.Pointer {
	funcDeclPtr := C.malloc(C.sizeof_struct_funcDecl)
	funcDeclData := node.(*ast.FuncDecl)
	funcDecls := C.struct_funcDecl{name: C.CString(funcDeclData.Name.Name), funcTypes: generateFileAst(funcDeclData.Type)}
	*(*C.struct_funcDecl)(funcDeclPtr) = funcDecls
	return genNode("*ast.FuncDecl", funcDeclPtr)
}

func genFuncType(node ast.Node) unsafe.Pointer {
	funcTypePtr := C.malloc(C.sizeof_struct_funcType)
	funcTypeData := node.(*ast.FuncType)
	funcTypes := C.struct_funcType{params: generateFileAst(funcTypeData.Params)}
	if funcTypeData.Results != nil {
		funcTypes.results = generateFileAst(funcTypeData.Results)
	}
	*(*C.struct_funcType)(funcTypePtr) = funcTypes
	return genNode("*ast.FuncType", funcTypePtr)
}

func genFieldList(node ast.Node) unsafe.Pointer {
	fieldListPtr := C.malloc(C.sizeof_struct_fieldList)
	fieldListData := node.(*ast.FieldList)
	cArr := C.malloc(C.size_t(len(fieldListData.List)) * C.size_t(unsafe.Sizeof(uintptr(0))))

	for i, field := range fieldListData.List {
		*(*uintptr)(unsafe.Pointer(uintptr(unsafe.Pointer(cArr)) + uintptr(i)*unsafe.Sizeof(uintptr(0)))) = uintptr(generateFileAst(field))
	}
	fieledList := C.struct_fieldList{list: unsafe.Pointer(cArr), listLen: C.int(len(fieldListData.List))}
	*(*C.struct_fieldList)(fieldListPtr) = fieledList
	return genNode("*ast.FieldList", fieldListPtr)
}

func genField(node ast.Node) unsafe.Pointer {
	fieldPtr := C.malloc(C.sizeof_struct_field)
	fieldData := node.(*ast.Field)
	names := C.malloc(C.size_t(len(fieldData.Names)) * C.size_t(unsafe.Sizeof(uintptr(0))))
	for i, name := range fieldData.Names {
		*(*uintptr)(unsafe.Pointer(uintptr(unsafe.Pointer(names)) + uintptr(i)*unsafe.Sizeof(uintptr(0)))) = uintptr(generateFileAst(name))
	}
	*(*C.struct_field)(fieldPtr) = C.struct_field{names: names, nameLen: C.int(len(fieldData.Names)), types: generateFileAst(fieldData.Type)}
	return genNode("*ast.Field", fieldPtr)
}

func genIdent(node ast.Node) unsafe.Pointer {

	identPtr := C.malloc(C.sizeof_struct_ident)
	identData := node.(*ast.Ident)
	*(*C.struct_ident)(identPtr) = C.struct_ident{name: C.CString(identData.Name)}
	return genNode("*ast.Ident", identPtr)
}

func genImportSpec(node ast.Node) unsafe.Pointer {
	importSpecPtr := C.malloc(C.sizeof_struct_importSpec)
	importSpecData := node.(*ast.ImportSpec)
	*(*C.struct_importSpec)(importSpecPtr) = C.struct_importSpec{kind: C.CString(importSpecData.Path.Kind.String()), value: C.CString(importSpecData.Path.Value)}
	return genNode("*ast.ImportSpec", importSpecPtr)
}

func genTypeSpec(node ast.Node) unsafe.Pointer {
	typeSpecPtr := C.malloc(C.sizeof_struct_typeSpec)
	typeSpecData := node.(*ast.TypeSpec)
	*(*C.struct_typeSpec)(typeSpecPtr) = C.struct_typeSpec{name: C.CString(typeSpecData.Name.Obj.Name), types: generateFileAst(typeSpecData.Type)}
	return genNode("*ast.TypeSpec", typeSpecPtr)
}

func genStructType(node ast.Node) unsafe.Pointer {
	structTypePtr := C.malloc(C.sizeof_struct_structType)
	structTypeData := node.(*ast.StructType)
	*(*C.struct_structType)(structTypePtr) = C.struct_structType{fields: generateFileAst(structTypeData.Fields)}
	return genNode("*ast.StructType", structTypePtr)
}

func genGenDecl(node ast.Node) unsafe.Pointer {
	genDeclPtr := C.malloc(C.sizeof_struct_genDecl)
	genDeclData := node.(*ast.GenDecl)
	specs := C.malloc(C.size_t(len(genDeclData.Specs)) * C.size_t(unsafe.Sizeof(uintptr(0))))
	for i, name := range genDeclData.Specs {
		*(*uintptr)(unsafe.Pointer(uintptr(unsafe.Pointer(specs)) + uintptr(i)*unsafe.Sizeof(uintptr(0)))) = uintptr(generateFileAst(name))
	}
	*(*C.struct_genDecl)(genDeclPtr) = C.struct_genDecl{specs: specs, specsLength: C.int(len(genDeclData.Specs)), token: C.CString(genDeclData.Tok.String())}
	return genNode("*ast.GenDecl", genDeclPtr)
}

func generateFileAst(node ast.Node) unsafe.Pointer {
	if node == nil {
		return genNode("void", unsafe.Pointer(nil))
	}
	nodeType := reflect.TypeOf(node).String()
	fmt.Println(nodeType)
	switch nodeType {
	case "*ast.File":
		return genFile(node)
	case "*ast.FuncDecl":
		return genFuncDecl(node)
	case "*ast.FuncType":
		return genFuncType(node)
	case "*ast.FieldList":
		return genFieldList(node)
	case "*ast.Field":
		return genField(node)
	case "*ast.Ident":
		return genIdent(node)
	case "*ast.GenDecl":
		return genGenDecl(node)
	case "*ast.ImportSpec":
		return genImportSpec(node)
	case "*ast.TypeSpec":
		return genTypeSpec(node)
	case "*ast.StructType":
		return genStructType(node)
	default:
		return genNode(nodeType, nil)
	}
}

//export getAstHead
func getAstHead(fileName *C.char) unsafe.Pointer {
	token := token.NewFileSet()
	parser, err := parser.ParseDir(token, C.GoString(fileName), nil, 0)
	if err != nil {
		panic("unable to parse given file")
	}
	var genNodePtr unsafe.Pointer
	for k := range parser {
		packageDeclPtr := C.malloc(C.sizeof_struct_package)
		packageData := parser[k]
		files := C.malloc(C.size_t(len(packageData.Files)) * C.size_t(unsafe.Sizeof(uintptr(0))))
		i := 0
		for _, file := range packageData.Files {
			*(*uintptr)(unsafe.Pointer(uintptr(unsafe.Pointer(files)) + uintptr(i)*unsafe.Sizeof(uintptr(0)))) = uintptr(generateFileAst(file))
			i++
		}
		*(*C.struct_package)(packageDeclPtr) = C.struct_package{name: C.CString(packageData.Name), fileLen: C.int(len(packageData.Files)), file: files}
		genNodePtr = genNode("package", packageDeclPtr)
	}
	return genNodePtr
}

//export getModFileName
func getModFileName(modFileLocation *C.char) *C.char {
	file, err := os.ReadFile(C.GoString(modFileLocation))
	if err != nil {
		panic(err)
	}
	modFileParsed, err := modfile.Parse(C.GoString(modFileLocation), file, nil)
	if err != nil {
		panic(err)
	}
	return C.CString(modFileParsed.Module.Mod.Path)
}

func main() {
}
