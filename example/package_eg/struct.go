package mainss

import "fmt"

type StructB struct {
	A int
	B int
}
type StructA struct {
	A int
	B StructB
}

func PrintStruct(struct_a StructA) int {
	fmt.Println(struct_a)
	return 1
}
