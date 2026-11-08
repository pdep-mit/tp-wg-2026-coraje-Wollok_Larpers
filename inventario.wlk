object mochila {
  //cambie a const por tema de teoria y diseño
  const property objetos = []
  
  method agregar(objeto) = objetos.add(objeto)
  
  method contiene(objeto) = objetos.contains(objeto)

  method quitar(objeto) = objetos.remove(objeto)

  method vaciar() = objetos.clear()
}