package main
import (
	"fmt"
	_"reflect"
)

func main() { 

	var a [8]int //定义长度为 8 整型数组 
	//定义长度为 5 的数组并初始化 
	var b [5]int = [5]int{0, 1, 2, 3, 4} 
	fmt.Println(a[0]) //输出：0 
	fmt.Println(b[len(b)-1]) //输出:4 
	fmt.Println(b) //输出：[0 1 2 3 4] 
	b[0] = 100 //修改 b 数组第 0 个元素的值 
	fmt.Println(b[0]) //输出：100
	
	var num [5]int = [5]int{0, 1, 2, 3, 4} //定义长度为 5 的数组并初始化 
	//以下为第一种遍历方式 
	for i := 0; i < len(num); i++{ 
		fmt.Println(num[i]) //换行输出： //0//1//2//3//4
	}
	//第二种遍历方式
	for key, value := range num { 
		fmt.Printf("下标是：%d 值是：%d\n", key, value)
	}

	// var abc [8]int //定义长度为 8 整型数组 
	// var bcd [5]int = [5]int{0, 1, 2, 3, 4} //定义长度为 5 的数组并初始化 
	// abc = bcd //编译错误：cannot use bcd(type [5]int) as type
}