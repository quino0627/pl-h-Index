package hindex

import org.json4s._

import scala.collection.mutable.ArrayBuffer

import java.io._

object Main extends App {
  implicit val formats = DefaultFormats

  case class User(var name: String, var age: Int, var citationList: Vector[Int])

  case class WithHIndexUser(var name: String, var age: Int, var sortedCitationList: Vector[Int], var hIndex: Int)


  var userArray = ArrayBuffer[User]()
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

  object AllDone extends Exception {}
  var sortedUserArray = ArrayBuffer[WithHIndexUser]()
  for (i <- 0 until userArray.length) {
    sortedUserArray += WithHIndexUser(name = "", age = 0, sortedCitationList = Vector(), hIndex = 0)
    sortedUserArray(i).name = userArray(i).name
    sortedUserArray(i).age = userArray(i).age
    sortedUserArray(i).sortedCitationList = Functions.quickSort(userArray(i).citationList).toVector
    //sortedUserArray(i).hIndex = Functions.getHIndex(sortedUserArray(i).sortedCitationList)
    println(sortedUserArray(i).name)
    println(sortedUserArray(i).sortedCitationList)
    try {
      for (j <- 0 until sortedUserArray(i).sortedCitationList.length) {

        if (sortedUserArray(i).sortedCitationList(j) < (j + 1)) {
          sortedUserArray(i).hIndex = j
          println(sortedUserArray(i).hIndex)
          throw AllDone
        }
      }
    } catch {
      case AllDone =>
    }
  }


  println("Korea Univ. college of informatics Computer Science and Engineering")
  println("2017320124 DongWook Song")
  println("Input : userArray")
  println("Output : print userArray on console")
  println("Output file : txt which contains sorted User, sorted citation number, and h-index")

  for (i <- 0 until sortedUserArray.length) {
    println(s"User Name : ${userArray(i).name}")
    println(s"User Age : ${userArray(i).age}")
    println(s"User Citation List\n${userArray(i).citationList}")
    println(s"${userArray(i).name}'s H-Index is ${sortedUserArray(i).hIndex}")
    println("")
  }

  var rankTable = sortedUserArray.sortBy(user => user.hIndex).reverse

  val writer = new PrintWriter(new File("scalaResultFile.txt"))
  for (i <- 0 until rankTable.length) {
    writer.write(s"${i+1}th person : ${rankTable(i).name} his/her H-Index is ${rankTable(i).hIndex} \n")
    writer.write(s"His paper citation number is ${rankTable(i).sortedCitationList}")
    writer.write("\n")
  }
  writer.close()

}
  object Functions {
    case class WithHIndexUser(var name: String, var age: Int, var sortedCitationList: Vector[Int], var hIndex: Int)
    def quickSort(seq: Seq[Int]): Seq[Int] = {
      if (seq.size < 2) return seq
      val pivotPos = scala.util.Random.nextInt(seq.size)
      val pivot = seq.apply(pivotPos)
      val (left, right) = seq.patch(pivotPos, Nil, 1).partition(_ > pivot)

      (quickSort(left) :+ pivot) ++ quickSort(right)
    }

//    def UserQuickSort(seq: Seq[WithHIndexUser]): Seq[WithHIndexUser] = {
//      if (seq.size < 2) return seq
//      val pivotPos = scala.util.Random.nextInt(seq.size)
//      val pivot = seq.apply(pivotPos)
//      val (left, right) = seq.patch(pivotPos, Nil, 1).partition(_.hIndex > pivot)
//
//      (UserQuickSort(left) :+ pivot) ++ UserQuickSort(right)
//    }



//    def getHIndex(seq: Seq[Int]): Unit = {
//          for(i<-0 to seq.length){
//
//            if(seq(i) < (i+1)){
//              println(s"aasaass${i}")
//
//              return i
//            }
//          }
//        }

    }



