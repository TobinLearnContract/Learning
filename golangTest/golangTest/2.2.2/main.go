package main
import (
	"fmt"
)

func main() { 
	var f float32 = 1 << 24
	fmt.Println(f == f+1)
	fmt.Println(f)
	fmt.Println(f + 1)
}