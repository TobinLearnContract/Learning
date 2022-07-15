package main
import (
	"fmt"
	_"reflect"
)

func main() { 
	//定义一个整型变量 
	var a int = 10 //定义一个指针变量 
	var p *int //指针 p 指向变量 a 的地址 
	p = &a 
	fmt.Println(a) //输出：10 
	fmt.Println(&a) //输出：0xc0000aa058 
	fmt.Println(p) //输出：0xc0000aa058 
	fmt.Println(*p) //输出：10 
	*p = 100 
	fmt.Println(a) //输出：100 
	fmt.Println(&a) //输出：0xc0000aa058 
	fmt.Println(p) //输出：0xc0000aa058 
	fmt.Println(*p) //输出：100 
	fmt.Println(*p == a) //输出：true

	fmt.Println(&p) //输出：0xc0000ce018 
	//定义一个指向指针的指针 
	var ptr **int //将指针 ptr 指向指针 p 的地址 
	ptr = &p 
	fmt.Println(ptr) //输出：指针 ptr 的地址为 0xc0000ce018 
	fmt.Println(*ptr) //输出：0xc0000aa058 
	fmt.Println(**ptr) //输出：10
	
}