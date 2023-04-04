package mainss

import "fmt"

type structB struct {
	a int
	b int
}
type structA struct {
	a int
	b structB
}

func PrintStruct(struct_a structA) int {
	fmt.Println(struct_a)
	return 1
}
