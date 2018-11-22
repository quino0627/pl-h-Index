package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math/rand"
	"os"
	"strconv"
	"strings"
)

type AutoGenerated struct {
	Users []User`json:"users"`
}

type User struct {
	Name         string `json:"name"`
	Age          int    `json:"age"`
	CitationList []int  `json:"citationList"`
}

func main() {
	programInfo()

	var users AutoGenerated

	json.Unmarshal(loadJson("users.json"), &users)

	for i:=0; i<len(users.Users); i++ {
		 fmt.Println("User Name: " + users.Users[i].Name)
		 fmt.Println("User Age: " + strconv.Itoa(users.Users[i].Age))
		 fmt.Println(users.Users[i].CitationList)
		 h_Index := getHIndex(users.Users[i].CitationList)
		 fmt.Printf("%s's h-index is %d\n\n",users.Users[i].Name,h_Index)
	}

	makeResultFile(users)

}
func programInfo(){
	fmt.Println("고려대학교 정보대학 컴퓨터학과")
	fmt.Println("2017320124 송동욱\n")
	fmt.Println("resultFile.txt contains a ascending list of people based on the h-index\n")
}

func loadJson(fileName string) []uint8{
	jsonFile, err := ioutil.ReadFile(fileName)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("Successfully Opened users.json\n")
	return jsonFile
}

func makeResultFile(users AutoGenerated){
	resultFile, err := os.Create("resultFile")
	if err != nil{
		fmt.Println(err)
	}
	fmt.Println("Successfully Created resultFile.txt\n")
	defer resultFile.Close()
	sortedUsers := quickSortUser(users.Users)
	for i:=0; i<len(sortedUsers); i++ {
		h_Index := getHIndex(sortedUsers[i].CitationList)
		resultText := strings.Join([]string{strconv.Itoa(i+1) + " 번째 : " + sortedUsers[i].Name +"이고, H-Index는 "+ strconv.Itoa(h_Index) + "\n"}, "")
		_, _ = resultFile.WriteString(resultText)
	}

}

func getHIndex( List []int) int {
	sortedList := quickSort(List)
	len := len(sortedList)
	for i, _ := range sortedList{
		if sortedList[i] < (i+1){
			return i
		}

	}

	return len
}

func addToResultFile(i int, h_index int){

}

func quickSort(a []int) []int {
	if len(a) < 2 {
		return a
	}
	left, right := 0, len(a)-1
	pivot := rand.Int() % len(a)
	a[pivot], a[right] = a[right], a[pivot]
	for i, _ := range a {
		if a[i] > a[right] {
			a[left], a[i] = a[i], a[left]
			left++
		}
	}
	a[left], a[right] = a[right], a[left]
	quickSort(a[:left])
	quickSort(a[left+1:])
	return a
}

func quickSortUser(a []User) []User{
	if len(a) < 2 {
		return a
	}
	left, right := 0, len(a)-1
	pivot := rand.Int() % len(a)
	a[pivot], a[right] = a[right], a[pivot]
	for i, _ := range a {
		if getHIndex(a[i].CitationList) > getHIndex(a[right].CitationList){
			a[left], a[i] = a[i], a[left]
			left++
		}
	}
	a[left], a[right] = a[right], a[left]
	quickSortUser(a[:left])
	quickSortUser(a[left+1:])
	return a
}