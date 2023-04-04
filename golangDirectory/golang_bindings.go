package main

//#include "c_binding.h"
//#include<stdlib.h>
import "C"

import custompackage "astitva.com/check"

//export Go_HelloFromGolang
func Go_HelloFromGolang() *C.char {
	result := custompackage.HelloFromGolang()
	return C.CString(result)
}

//export Go_PrintStringInGolang
func Go_PrintStringInGolang(s *C.char) {
	custompackage.PrintStringInGolang(s * C.char)

}

//export Go_Sum
func Go_Sum(a C.int, b C.int) *C.int {
	result := custompackage.Sum(int(a), int(b))
	resultPtr := (*C.int)(C.malloc(C.sizeof_int))
	*resultPtr = C.int(result)
	return resultPtr
}

//export Go_Multiply
func Go_Multiply(a C.int, b C.int) *C.int {
	result := custompackage.Multiply(int(a), int(b))
	resultPtr := (*C.int)(C.malloc(C.sizeof_int))
	*resultPtr = C.int(result)
	return resultPtr
}

//export Go_Subtraction
func Go_Subtraction(a C.int, b C.int) *C.int {
	result := custompackage.Subtraction(int(a), int(b))
	resultPtr := (*C.int)(C.malloc(C.sizeof_int))
	*resultPtr = C.int(result)
	return resultPtr
}

type structB struct {
	a int
	b int
}

type structA struct {
	a int
	b structB
}

//export Go_PrintStruct
func Go_PrintStruct(struct_a C.struct_structA) *C.int {
	go_struct_a := structA{}
	go_struct_a.a = int(struct_a.a)
	go_struct_a.b.a = int(struct_a.b.a)
	go_struct_a.b.b = int(struct_a.b.b)

	result := custompackage.PrintStruct(go_struct_a)
	resultPtr := (*C.int)(C.malloc(C.sizeof_int))
	*resultPtr = C.int(result)
	return resultPtr
}

func main() {}
