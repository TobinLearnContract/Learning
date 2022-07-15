package main
import (
	"fmt"
	"reflect"
)

func main() { 
	
	//定义一个匿名函数，赋值给 fun 变量，取大值
	fun := func(a, b int) int { 
		if a > b { 
			return a 
		}
		return b 
	}
	//调用匿名函数并保存返回值 
	fmt.Println(fun(5, 10)) //输出：10 
	fmt.Println(reflect.TypeOf(fun)) //输出:func()int,int)int
	
}