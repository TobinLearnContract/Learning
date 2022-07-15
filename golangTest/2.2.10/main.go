package main
import (
	"fmt"
	_"reflect"
)

func main() { 
	
	//创建一个 map,key 为 string 类型，value 为 string 类型 
	m := make(map[string]string) 
	//给 map 增加值 
	m["username"] = "admin" 
	m["sex"] = "man" 
	m["age"] = "20" 
	fmt.Println(m) //输出：map[username:admin sex:man age:20] 

	//删除键值 
	delete(m, "age") 
	fmt.Println(m) //输出：map[username:admin sex:man] 

	//查询键值是否存在 
	value, ok := m["username"] 
	if ok {
		fmt.Println(value) //输出：admin 
	} else {
		fmt.Println("nil") //输出：nil 
	}
	
}