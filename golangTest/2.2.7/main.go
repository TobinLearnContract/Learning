package main
import (
	"fmt"
	_"reflect"
)
	type Object struct { 
			Hash string 
			length int 
		}

func main() { 
	var obj Object 
	obj.length = 10 
	obj.Hash = "45454afasf4asdf1a" 
	fmt.Println(obj.length) //输出：10 
}