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

type UserList struct { //User 배열을 필드로 가지는 구조체입니다.
	Users []User`json:"users"`
}

type User struct { //User 구조체는 Name, Age, CitationList(피인용수 배열)을 필드로 갖습니다.
	Name         string `json:"name"`
	Age          int    `json:"age"`
	CitationList []int  `json:"citationList"`
}

func main() {
	programInfo() //학번, 프로그램 설명을 콘솔에 프린트하는 function입니다.

	var users UserList //UserList 구조체 타입으로 선업합니다. 다음 줄에서 json파일을 UserList구조체를 기준으로 파싱하여 이곳에 할당합니다.
	json.Unmarshal(loadJson("users.json"), &users) //users.json파일으로부터 json을 파싱합니다.

	for i:=0; i<len(users.Users); i++ { //for문을 이용하여 json을 파싱한 구조체 변수(이하 users)의 필드들을 출력합니다.
		 fmt.Println("User Name: " + users.Users[i].Name)
		 fmt.Println("User Age: " + strconv.Itoa(users.Users[i].Age)) //String과
		 fmt.Println(users.Users[i].CitationList)
		 h_Index := getHIndex(users.Users[i].CitationList)
		 fmt.Printf("%s's h-index is %d\n\n",users.Users[i].Name,h_Index)
	}

	makeResultFile(users)

}
func programInfo(){
	fmt.Println("고려대학교 정보대학 컴퓨터학과")
	fmt.Println("2017320124 송동욱\n")
	fmt.Println("Input : users.json")
	fmt.Println("Output: 인풋 json파일을 파싱하여 console에 출력, 유저의 논문 당 인용 수 리스트를 이용해 계산한 h-index 출력")
	fmt.Println("Output File : h-Index값을 계산하여 유저들을 오름차순으로 정렬한 txt 파일")
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

func makeResultFile(users UserList){
	resultFile, err := os.Create("goResultFile.txt")
	if err != nil{
		fmt.Println(err)
	}
	fmt.Println("Successfully Created resultFile.txt\n")
	defer resultFile.Close()
	sortedUsers := quickSortUser(users.Users)
	for i:=0; i<len(sortedUsers); i++ {
		h_Index := getHIndex(sortedUsers[i].CitationList)
		resultText := strings.Join([]string{strconv.Itoa(i+1) + " 번째 : " + sortedUsers[i].Name +"이고, H-Index는 "+ strconv.Itoa(h_Index) + "\n" + "그의 논문 피인용수는 "+ arrayToString(sortedUsers[i].CitationList, ",") + "\n\n"}, "")
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

func arrayToString(a []int, delim string) string {
	return strings.Trim(strings.Replace(fmt.Sprint(a), " ", delim, -1), "[]")
	//return strings.Trim(strings.Join(strings.Split(fmt.Sprint(a), " "), delim), "[]")
	//return strings.Trim(strings.Join(strings.Fields(fmt.Sprint(a)), delim), "[]")
}