# Explicaciones teóricas

*A continuación presentamos dónde aplicamos los distintos conceptos que se buscaban en cada entrega.*

## Índice

- [Polimorfismo](#polimorfismo)
- [Herencia](#herencia)
- [Template Method](#template-method)
---

## 1. Polimorfismo

Distintos objetos comparten una misma interfaz (entienden los mismos mensajes) para que quien los usa pueda tratarlos de manera indistinta, sin preguntar con un `if` de cuál se trata.

### Ejemplo en profundidad: `player` y los disfraces (`player.wlk`, `disfraces.wlk`)

Los objetos `disfrazPolicia`, `disfrazAnubis` y `disfrazArtista` no heredan de una clase común, pero son polimórficos porque todos entienden los mismos cuatro mensajes: `image()`, `desgastar(personaje)`, `permiteAccesoAnubis()` y `permiteAccesoArtista()`.

* **Cómo interactúan:** `player` mantiene una referencia `disfraz` (inicializada en `disfrazPolicia`) que puede apuntar a cualquiera de los tres objetos.
* **Uso polimórfico desde `player`:** Cuando el motor gráfico pide la imagen del jugador, `player` ejecuta `disfraz.image()`. Cuando pasa un segundo en `reloj`, `player` ejecuta `disfraz.desgastar(self)`. En ningún momento `player` chequea qué disfraz tiene puesto.
* **Cómo lo resuelve cada uno:** `disfrazAnubis` y `disfrazArtista` llevan su propio contador `desgaste`: según ese valor devuelven distintas imágenes de desgaste y, al llegar a `60`, le avisan al jugador con `personaje.romperDisfraz(self)` y resetean su contador a `0`. `disfrazPolicia`, en cambio, implementa `desgastar(personaje) { }` vacío. Esta decisión evita que `player` tenga que preguntar `if (disfraz != disfrazPolicia)` antes de desgastarlo.
* **Uso polimórfico desde las puertas:** Las condiciones de `puertaAnubis` y `puertaArtista` simplemente envían `player.disfraz().permiteAccesoAnubis()` o `permiteAccesoArtista()`, y cada disfraz responde `true` o `false` según corresponda.

### Otros ejemplos en el código
* **Colisiones (`chocarConJugador()`):** `administradorDeSalas` envía `elemento.chocarConJugador()` a cualquier visual con el que choque `player` (`Puerta`, `llave`, `activadorAnubis`, `activadorArtista`, `Estatua`, `Marco`, `mesaPoema`, `cartelPuertas`).
* **Salas (`escenarios.wlk`):** `salaPrincipal`, `habitacionUno`, `habitacionDos`, `habitacionTres` y `habitacionFinal` entienden todas `dibujar()`.

---

## 2. Herencia

Permite compartir comportamiento común en una superclase y especializar solo lo que cambia en las subclases, ya sea extendiendo la lógica original con `super()` o completando pasos de un algoritmo base

### Ejemplo en profundidad: Jerarquía de `Puerta` (`puertas.wlk`)

La clase base `Puerta` define los atributos `position`, `proximaSala`, `posicionJugador`, `image`, `condicionDePaso` y `generadorMensaje`, junto con los métodos `chocarConJugador()`, `puedePasar()`, `mensajeBloqueo()` y `cruzar()`.

* **Extensión con `super()` en `PuertaTrampaTeletransportacion`:** Hereda de `Puerta` fijando `proximaSala = salaPrincipal` y `posicionJugador = game.at(4, 6)`. Redefine (`override`) únicamente `cruzar()`: primero muestra el mensaje de trampa (`game.say(player, "¡Puerta trampa! Volvés a la sala principal.")`) y luego llama a `super()` para reutilizar el cambio de sala (`administradorDeSalas.cambiarA(proximaSala, posicionJugador)`) sin duplicar ese código.
* **Redefinición completa en `PuertaTrampaRestaTiempo`:** Hereda de `Puerta` pero, como al chocarla el jugador no debe cruzar a ninguna sala, redefine directamente `chocarConJugador()` para ejecutar `reloj.restarMinutos(10)` y mostrar el aviso.

### Otros ejemplos en el código
* **`ElementoInteractivo` (`interactuables.wlk`):** Superclase de `Estatua`, `Marco`, `mesaPoema`, `menuFlotante` y `EstadoEstatua` que define versiones vacías de `chocarConJugador()`, `abrirMenu()`, `marcarVerdad()` y `marcarFalso()`.
* **`EstadoEstatua` (`interactuables.wlk`):** Superclase abstracta que centraliza `mostrar()` y `ocultar()` y deja `coincideCon(diceLaVerdad)` abstracto para `EstadoNeutral`, `EstadoVerdad` y `EstadoFalso`.

---

## 3. Composición

Un objeto delega parte de su comportamiento en otro objeto que mantiene como atributo, permitiendo cambiar ese comportamiento dinámicamente en tiempo de ejecución.

### Ejemplo en profundidad: `Estatua` y `EstadoEstatua` (`interactuables.wlk`)

Cada instancia de `Estatua` tiene un atributo `var estado`, que al construirse (`initialize()`) apunta a una instancia de `EstadoNeutral`.

* **Cómo interactúan:** `Estatua` tiene una relación de composición hacia `EstadoEstatua` (a través de `estado`), y de `EstadoEstatua` heredan `EstadoNeutral`, `EstadoVerdad` y `EstadoFalso`.
* **Cambio dinámico:** Cuando el jugador presiona `V` o `F`, la estatua ejecuta `marcarVerdad()` o `marcarFalso()`, que llaman a `cambiarEstado(nuevoEstado)`. Ese método oculta el visual del estado anterior (`estado.ocultar()`), reemplaza la referencia `estado` por un `new EstadoVerdad(...)` o `new EstadoFalso(...)` y lo muestra en pantalla (`estado.mostrar()`). Al reiniciar el puzzle, vuelve a `EstadoNeutral`.
* **Por qué composición y no herencia:** Un objeto no puede cambiar de clase en tiempo de ejecución. Si el estado marcado por el jugador se hubiera modelado con herencia, habría que haber creado subclases rígidas (como `EstatuaVerdaderaMarcadaFalsa`) y destruir/recrear estatuas cada vez que el jugador cambia de opinión. Con composición, la estatua simplemente delega la verificación en su estado actual (`estado.coincideCon(self.diceLaVerdad())`).

### Otros ejemplos en el código
* **`player` con `disfraz` e `inventario` (`player.wlk`):** `player` cambia su disfraz dinámicamente con `ponerseDisfraz(nuevoDisfraz)` y delega el guardado de ítems en `mochila`.
* **`Puerta` con bloques (`puertas.wlk`, `escenarios.wlk`):** En lugar de crear subclases para `puertaAnubis`, `puertaArtista` y `puertaFinal`, `Puerta` se compone de los bloques `condicionDePaso` y `generadorMensaje`.

---

## 4. Encapsulamiento y Delegación

El encapsulamiento oculta el estado interno de un objeto exponiendo solo los mensajes necesarios; la delegación consiste en pedirle a ese objeto que haga la tarea en lugar de sacar sus datos para operarlos desde afuera.

### Ejemplo en profundidad: `reloj` (`reloj.wlk` y `puertas.wlk`)

El objeto `reloj` encapsula `minutosTotales` (`360`) y `minutosRestantes` (sin setter público), además de la lógica interna para calcular `hora()`, `minuto()` y formatear el texto con `dosDigitos(numero)`.

* **Cómo interactúan:** `PuertaTrampaRestaTiempo` envía `reloj.restarMinutos(10)`. Por otro lado, el tick del juego envía `reloj.pasarUnMinuto()`, que internamente llama a `self.restarMinutos(1)` y delega el desgaste en `player.desgastarDisfrazActual()`.
* **Responsabilidad encapsulada:** `PuertaTrampaRestaTiempo` no sabe cuántos minutos quedan ni cómo se descuenta el tiempo. Es `reloj.restarMinutos(cantidad)` quien actualiza `minutosRestantes = (minutosRestantes - cantidad).max(0)` para evitar negativos, verifica `self.seTerminoElTiempo()` y, si llegó a cero, delega el fin del juego en `pantallaDerrota.mostrar()`.

### Otros ejemplos en el código
* **`player` y los disfraces (`player.wlk`, `disfraces.wlk`):** `player` delega en `disfraz.desgastar(self)` sin conocer el contador interno `desgaste`.
* **Administradores de puzzles (`interactuables.wlk`):** Las puertas delegan en `administradorMarcos.puzzleResuelto()` y `administradorEstatuas.estanTodasResueltas()` sin acceder a los elementos individuales.
* **`movimientos` (`movimientos.wlk`):** `administradorDeSalas` delega el desplazamiento en `movimientos.mover(player, direccion)`, que encapsula la validación de bordes `estaDentroDeLaSala(pos)`.

---

## 5. Colecciones

Agrupación de objetos en listas manipuladas de forma declarativa mediante bloques (*closures*).

### Ejemplo en profundidad: `administradorEstatuas` (`interactuables.wlk`)

`administradorEstatuas` agrupa las cinco instancias (`estatua1` a `estatua5`, combinando `EstatuaMentirosa` y `EstatuaVerdadera`) en una lista constante `const property estatuas`.

* **Cómo interactúan:** `administradorEstatuas` tiene una relación de uno a muchos (`*`) hacia `Estatua` a través de la colección `estatuas`.
* **Operaciones sobre la colección:**
  * `forEach` (con efecto): En `dibujarEstatuas()` ejecuta `estatuas.forEach({ estatua => estatua.dibujarEnJuego() })` y en `reiniciarPuzzle()` ejecuta `estatuas.forEach({ estatua => estatua.reiniciar() })`.
  * `all` (consulta booleana): En `estanTodasResueltas()` evalúa `estatuas.all({ estatua => estatua.estaCorrecta() })`, devolviendo `true` únicamente si todas las estatuas cumplen su condición.


### Otros ejemplos en el código
* **`administradorMarcos` (`interactuables.wlk`):** Usa `forEach` en `dibujarPuzzle()` y `reiniciarPuzzle()`, y `all` en `puzzleResuelto()` sobre la lista `marcos`.
* **`mochila` (`inventario.wlk`):** Administra la lista `const property objetos = []` con `add`, `contains`, `remove` y `clear`.
* **`Marco` (`interactuables.wlk`):** Guarda la lista `galeria` y la recorre circularmente con `get(indiceActual)` y `size()`.
* **Teclado en `administradorDeSalas` (`escenarios.wlk`):** Consulta `game.colliders(player)` y usa `isEmpty()` y `first()` al presionar `E`, `V` o `F`.
