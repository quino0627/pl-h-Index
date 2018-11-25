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
		 fmt.Println("User Age: " + strconv.Itoa(users.Users[i].Age)) //String과 Int를 +하여 출력할 수 없음. strconv.Iota메소드를 이용하여 Int를 String으로 바꾸어 줌
		 fmt.Println(users.Users[i].CitationList)
		 h_Index := getHIndex(users.Users[i].CitationList) //h-index를 구하는 함수입니다.
		 fmt.Printf("%s's h-index is %d\n\n",users.Users[i].Name,h_Index) //string과 int형을 출력하는 또 다른 방법입니다.
	}

	makeResultFile(users) //Output File을 만들기 위한 함수입니다.

}
func programInfo(){
	fmt.Println("고려대학교 정보대학 컴퓨터학과")
	fmt.Println("2017320124 송동욱\n")
	fmt.Println("Input : users.json")
	fmt.Println("Output: 인풋 json파일을 파싱하여 console에 출력, 유저의 논문 당 인용 수 리스트를 이용해 계산한 h-index 출력")
	fmt.Println("Output File : h-Index값을 계산하여 유저들을 오름차순으로 정렬한 txt 파일")
	fmt.Println("resultFile.txt contains a ascending list of people based on the h-index\n")
}

func loadJson(fileName string) []uint8{ //fileName을 string 형으로 받아 []uint8형을 return 하는 함수
	jsonFile, err := ioutil.ReadFile(fileName)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("Successfully Opened users.json\n")
	return jsonFile
}
//makeResultFile : Output file인 goResultFile.txt을 생성
func makeResultFile(users UserList){ //UserList를 parameter로 받음
	resultFile, err := os.Create("goResultFile.txt")//goResultFile.txt를 생성
	if err != nil{ //에러 처리
		fmt.Println(err)
	}
	fmt.Println("Successfully Created resultFile.txt\n")
	defer resultFile.Close()
	sortedUsers := quickSortUser(users.Users) //각 유저의 H-index에 따라 유저 배열을 정렬하는 함수 - quickSortUser함수를 이용하여 유저 리스트를 정렬
	for i:=0; i<len(sortedUsers); i++ { //파일에 저장할 string을 생성하고, 그것을 파일에 write합니다.
		h_Index := getHIndex(sortedUsers[i].CitationList)
		resultText := strings.Join([]string{strconv.Itoa(i+1) + " 번째 : " + sortedUsers[i].Name +"이고, H-Index는 "+ strconv.Itoa(h_Index) + "\n" + "그의 논문 피인용수는 "+ arrayToString(sortedUsers[i].CitationList, ",") + "\n\n"}, "")
		_, _ = resultFile.WriteString(resultText)
	}

}

//리스트를 소팅하여 인덱스와 값을 비교 후 h-index값을 구하는 함수합니다.
func getHIndex( List []int) int { //parameter: int array, returns int
	sortedList := quickSort(List)
	for i, _ := range sortedList{
		if sortedList[i] < (i+1){
			return i //조건에 맞을 시 리턴됩니다.
		}

	}

	return 0 //이것은 리턴되지 않습니다. 하지만 지우면 에러가 납니다.
}

//Ramdom Quick Sort
//보고서에 gorutine을 이용한 퀵소트의 예시를 담았습니다.
func quickSort(a []int) []int {
	if len(a) < 2 {
		return a
	}
	left, right := 0, len(a)-1 //다음과 같이 선언할 수 있습니다.
	pivot := rand.Int() % len(a) //랜덤 함수를 이용하여 피봇을 결정합니다.
	a[pivot], a[right] = a[right], a[pivot]
	for i, _ := range a {
		if a[i] > a[right] {
			a[left], a[i] = a[i], a[left]
			left++
		}
	}
	a[left], a[right] = a[right], a[left] //다음과 같은 형태로 스왑할 수 있습니다.
	quickSort(a[:left])//재귀함수입니다.
	quickSort(a[left+1:]) //인자를 reference방식으로 전달하기 때문에 추가적인 인자가 필요하지 않습니다.
	return a
}
//Random Quick Sort
//User 오브젝트를 원소로 가지는 배열을 정렬하기 위한 퀵 소트입니다.
//위의 quickSort함수와 크게 다르지 않습니다.
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
//writefile시 array를 string형태로 바꿔주기 위해 생성한 함수입니다.
func arrayToString(a []int, delim string) string {
	return strings.Trim(strings.Replace(fmt.Sprint(a), " ", delim, -1), "[]")
}