object mochila {
  var property objetos = []
  
  method agregar(objeto) = objetos.add(objeto)
  
  method contiene(objeto) = objetos.contains(objeto)

  method quitar(objeto) = objetos.remove(objeto)
}