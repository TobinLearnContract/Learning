package main
import (
	"fmt"
	"reflect"
)

func main() { 

	var s string 
	s1 := "this is String" 
	ch := s1[0] 
	fmt.Println(s) //这里什么也不会显示 
	fmt.Println(s1) //这里输出 this is String 
	fmt.Println(reflect.TypeOf(ch)) //这里输出 uint8，也就是 byte 类型 
	fmt.Printf("ch的类型：%T\n", ch)
	fmt.Println(ch) //这里输出 ascii 码 116 
	fmt.Printf("%c\n", ch) //这里输出字母 t
	/*
	* var str = "this is String" 
	* ch2 := str[1] 
	* fmt.Printf("%c", ch2) 
	* str[1] = "k" //cannot assign to str[1]
	*/
}