package main
import (
	"fmt"
)

func main() { 
	var v1 bool 
	fmt.Println(v1) //false 
	v1 = true 
	fmt.Println(v1) //true 
	v1 = (1 == 2) 
	fmt.Println(v1) //false 
	v2 := (2 == 2) 
	fmt.Println(v2) //true 
	var a, b int 
	a = 2 
	b = 2 
	v3 := (a == b) 
	fmt.Println(v3)
}
