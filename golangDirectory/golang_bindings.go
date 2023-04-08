package main

//#include "c_binding.h"
//#include<stdlib.h>
import "C"

import custompackage "astitva.com/check"

type StructB struct {
	A int
	B int
}

type StructA struct {
	A int
	B StructB
}

//export Go_PrintStruct
func Go_PrintStruct(struct_a C.struct_CStructA) *C.int {
	go_struct_a := custompackage.StructA{}
	go_struct_a.A = int(struct_a.A)
	go_struct_a.B.A = int(struct_a.B.A)
	go_struct_a.B.B = int(struct_a.B.B)

	result := custompackage.PrintStruct(go_struct_a)
	resultPtr := (*C.int)(C.malloc(C.sizeof_int))
	*resultPtr = C.int(result)
	return resultPtr
}

//export Go_HelloFromGolang
func Go_HelloFromGolang(x C.struct_CStructA) {
	go_x := custompackage.StructA{}
	go_x.A = int(x.A)
	go_x.B.A = int(x.B.A)
	go_x.B.B = int(x.B.B)

	custompackage.HelloFromGolang(go_x)

}

//export Go_PrintStringInGolang
func Go_PrintStringInGolang(s *C.char) *C.int {
	result := custompackage.PrintStringInGolang(C.GoString(s))
	resultPtr := (*C.int)(C.malloc(C.sizeof_int))
	*resultPtr = C.int(result)
	return resultPtr
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

func main() {}
