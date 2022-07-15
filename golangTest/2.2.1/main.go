package main
import (
	"fmt"
)

func main() {
	var v int8 
	v1 := 10 
	v = int8(v1)
	fmt.Println(v)

	var b byte
	var b1 uint8
	b1 = 10
	b = b1
	fmt.Println(b)
}