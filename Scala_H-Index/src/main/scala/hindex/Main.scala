package hindex

import scala.io.Source
import scala.collection.mutable.ArrayBuffer //mutable ArrayBuffer타입을 이용하기 위하여 import
import java.io._ //File IO 를 위하여 import

object Main extends App {
  //케이스 클래스를 선언한다.
  //케이스 클래스는 new키워드를 사용하지 않아도 되도록 동반객체를 생성해주며, 패턴 매치를 지원하는 등의 기능이 제공된다.
  case class User(var name: String, var age: Int, var citationList: Vector[Int])
  case class WithHIndexUser(var name: String, var age: Int, var sortedCitationList: Vector[Int], var hIndex: Int)
  //WithIndexUser는  hIndex와 sortedCitationList 를 가지는 클래스이다.


  var userArray = ArrayBuffer[User]()
  //ArrayBuffer 타입에 값을 추가하고 싶을 때는 += 연산자를 이용한다.
  userArray += User(name = "Alice", age = 34, citationList = Vector(3, 0, 6, 7, 5))
  userArray += User(name = "Aria", age = 19, citationList = Vector(2, 5, 3, 4, 6, 2, 3, 15, 26, 71, 12, 12, 133, 14))
  userArray += User(name = "Bess", age = 47, citationList = Vector(3, 10, 9, 3, 14, 9, 9, 10, 18, 2))
  userArray += User(name = "Carmen", age = 25, citationList = Vector(14, 1, 5, 5, 13, 3, 15, 5, 6, 9))
  userArray += User(name = "Daisy", age = 22, citationList = Vector(6, 4, 7, 10, 3, 8, 18, 2, 19, 5, 17, 17, 13, 7, 1))
  userArray += User(name = "Elin", age = 37, citationList = Vector(14, 19, 10, 15, 15, 13, 1, 5, 17, 4, 14, 10, 4, 6, 7))
  userArray += User(name = "Emma", age = 50, citationList = Vector(5, 4, 4, 17, 16, 2, 8, 4, 19, 17, 17, 13, 19, 5, 5, 14))
  userArray += User(name = "Eva", age = 24, citationList = Vector(16, 9, 2, 15, 11, 17, 10, 13, 17, 19, 7, 17, 9, 13, 14))
  userArray += User(name = "Gloria", age = 29, citationList = Vector(16, 4, 3, 15, 10, 2, 17, 11, 12, 9, 1, 1))
  userArray += User(name = "Liam", age = 34, citationList = Vector(9, 2, 19, 11, 1, 20, 17, 13, 20, 10, 6, 2))
  userArray += User(name = "Noah", age = 26, citationList = Vector(6, 10, 3, 17, 15, 16, 12, 12, 9, 7, 5, 1))
  userArray += User(name = "Mason", age = 26, citationList = Vector(1, 18, 18, 12, 18, 20, 4, 11, 14, 15))
  userArray += User(name = "Daisy", age = 26, citationList = Vector(4, 8, 11, 8, 17, 2))
  userArray += User(name = "Lucas", age = 26, citationList = Vector(12, 5, 8, 3, 10, 2, 14, 2, 20, 7, 15, 7))
  userArray += User(name = "Oliver", age = 26, citationList = Vector(9, 12, 4, 1, 4, 10, 11, 17))

  //HIndex를 가진 유저들의 배열을 생성하기 위한 코드입니다.
  //loop문 탈출을 위해서 Exception을 extend한 AllDone 객체를 생성합니다.
  object AllDone extends Exception {}
  var withHIndexUserArray = ArrayBuffer[WithHIndexUser]()
  for (i <- 0 until userArray.length) {
    withHIndexUserArray += WithHIndexUser(name = "", age = 0, sortedCitationList = Vector(), hIndex = 0)
    withHIndexUserArray(i).name = userArray(i).name
    withHIndexUserArray(i).age = userArray(i).age
    withHIndexUserArray(i).sortedCitationList = Functions.quickSort(userArray(i).citationList).toVector
    //H-Index를 구하는 함수를 다른 언어에서 구현한 것과 달리 따로 구현하지 않고 main내에서 h-index를 구합니다.
    try {
      for (j <- 0 to withHIndexUserArray(i).sortedCitationList.length-1) {

        if (withHIndexUserArray(i).sortedCitationList(j) < (j + 1)) {
          withHIndexUserArray(i).hIndex = j
          //루프문을 탈출합니다.
          throw AllDone
        }
        //for 문에 걸리지 않으면 citationList의 길이를 return한다.
        withHIndexUserArray(i).hIndex = withHIndexUserArray(i).sortedCitationList.length
      }
    } catch {
      case AllDone =>
    }
  }

  //학번, 이름과 프로그램의 정보를 콘솔에 출력합니다.
  //userInfo.txt를 읽어옵니다.
  try {
    for(line <- Source.fromFile("userInfo.txt").getLines()){
      println(line)
    }
  } catch {
    case ex: Exception => println(ex)
  }

  println("Input : userArray")
  println("Output : print userArray on console")
  println("Output file : txt which contains sorted User, sorted citation number, and h-index")
//유저들의 정보와 h-index값을 출력한다.
  for (i <- 0 until withHIndexUserArray.length) {
    println(s"User Name : ${userArray(i).name}")
    println(s"User Age : ${userArray(i).age}")
    println(s"User Citation List\n${userArray(i).citationList}")
    println(s"${userArray(i).name}'s H-Index is ${withHIndexUserArray(i).hIndex}")
    println("")
  }


  //sortBy 메소드를 이용하여 object의 집합을 간편하게 소팅할 수 있다.
  //객체 안의 h-index값에 따라 withHIndexUserArray의 객체들을 정렬한다.
  var rankTable = withHIndexUserArray.sortBy(user => user.hIndex).reverse

  //scalaResultFile.txt를 생성한다.
  val writer = new PrintWriter(new File("scalaResultFile.txt"))
  //h-index순으로 유저를 정렬한 rankTable
  for (i <- 0 until rankTable.length) {
    writer.write(s"${i+1}th person : ${rankTable(i).name} his/her H-Index is ${rankTable(i).hIndex} \n")
    writer.write(s"His paper citation number is ${rankTable(i).sortedCitationList}")
    writer.write("\n")
  }
  writer.close()

}
//object를 이용하여 singleton 객체를 생성할 수 있습니다.
//퀵소트 메소드를 가지고 있습니다.
  object Functions {

    def quickSort(seq: Seq[Int]): Seq[Int] = {
      if (seq.size < 2) return seq
      val pivotPos = scala.util.Random.nextInt(seq.size)
      val pivot = seq.apply(pivotPos)
      val (left, right) = seq.patch(pivotPos, Nil, 1).partition(_ > pivot)

      //재귀 함수를 이용하여 리턴값을 다음과 같이 줄 수 있습니다.
      (quickSort(left) :+ pivot) ++ quickSort(right)
    }


    }



