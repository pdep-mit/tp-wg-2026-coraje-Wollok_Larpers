import disfraces.*

object player {
  var property position = game.at(1, 1)
  var property disfraz = sinDisfraz

  method image() = disfraz.image()

  method ponerseDisfraz(nuevoDisfraz){
    disfraz = nuevoDisfraz
  }
}