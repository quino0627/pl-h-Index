package hindex

object Json2Map {
  import org.json4s._
  import org.json4s.native.JsonMethods._
  print(parse(""" { "numbers" : [1, 2, 3, 4] } """))
}
