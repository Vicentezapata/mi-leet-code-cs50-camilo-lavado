# Material Complementario: El Navegador como Runtime

El navegador moderno no es solo un visor de páginas. Es un entorno de ejecución completo —un **runtime**— que incluye un motor de red, un motor de renderizado, un intérprete de JavaScript y un conjunto de APIs que permiten acceder al hardware del dispositivo. Entender sus capas te ayuda a escribir código más eficiente y a depurar problemas más rápido.

---

## 1. El motor V8 y cómo ejecuta JavaScript

Cuando Chrome (o Edge, o Node.js) recibe código JavaScript, ese código pasa por el motor **V8**, desarrollado por Google. V8 no interpreta el código línea a línea como un script de shell; lo compila a código máquina nativo en tiempo real mediante una técnica llamada **JIT (Just-In-Time compilation)**.

### El ciclo de ejecución de V8

```
Código JS (texto)
      │
      ▼
  Parser → AST (Abstract Syntax Tree)
      │
      ▼
  Ignition (intérprete de bytecode)
      │
      ▼  ← Si la función se llama muchas veces ("hot")
  TurboFan (compilador optimizador)
      │
      ▼
  Código máquina nativo (x86-64 / ARM)
```

1. **Parser:** Lee el texto de JavaScript y construye un árbol de sintaxis abstracta (AST), que representa la estructura del programa.
2. **Ignition:** Interpreta el AST y genera bytecode (instrucciones más cercanas a la máquina, pero todavía portables). Para funciones que se ejecutan pocas veces, esto es suficiente.
3. **TurboFan:** Cuando V8 detecta que una función se llama repetidamente ("función caliente"), la compila con optimizaciones agresivas a código máquina nativo, que es mucho más rápido.

Este enfoque híbrido explica por qué JavaScript moderno puede ser sorprendentemente rápido: el código crítico termina corriendo como si fuera C compilado.

### El event loop

JavaScript es **single-threaded**: solo puede ejecutar una tarea a la vez. Sin embargo, puede manejar operaciones asíncronas (como `fetch`, timers, eventos del usuario) gracias al **event loop**.

```
┌──────────────────────┐
│   Call Stack         │  ← Donde se ejecuta el código JS sincrónico
│  (pila de llamadas)  │
└──────────┬───────────┘
           │ cuando está vacía
           ▼
┌──────────────────────┐
│   Callback Queue     │  ← Callbacks de fetch, setTimeout, eventos del DOM
└──────────┬───────────┘
           │
           ▼
        Event Loop
        (mueve callbacks al call stack cuando está vacío)
```

Por eso `fetch` no bloquea la página: el navegador lanza la solicitud HTTP en un hilo separado (la Web API), y cuando llega la respuesta, coloca el callback en la cola. El event loop lo ejecuta en cuanto el call stack queda libre.

---

## 2. DevTools — Tu laboratorio en el navegador

Las herramientas de desarrollo (DevTools) están integradas en todos los navegadores modernos. Se abren con **F12** o clic derecho → "Inspeccionar". Son indispensables para trabajar con la web.

### Panel Elements: inspeccionar y editar el DOM

El panel Elements muestra el árbol DOM en tiempo real. Puedes:

- **Navegar la estructura:** Haz clic en cualquier triángulo para expandir un nodo y ver sus hijos.
- **Seleccionar un elemento visualmente:** Haz clic derecho sobre cualquier parte de la página y elige "Inspeccionar". El DevTools salta directamente al nodo HTML correspondiente.
- **Editar el DOM en vivo:** Doble clic sobre cualquier atributo o texto para modificarlo. Los cambios son instantáneos en la página (solo en tu copia local; el servidor no se ve afectado).
- **Ver los estilos aplicados:** El panel lateral "Styles" muestra qué reglas CSS están activas en el elemento seleccionado, de dónde vienen, y cuáles están siendo sobreescritas (aparecen tachadas).

> Cuando editaste "Life at Yale" en la clase, lo que hiciste fue modificar tu copia local del árbol DOM. Al recargar la página, el navegador pidió el HTML original al servidor y la edición desapareció.

### Panel Console: ejecutar y depurar JavaScript

La consola es un REPL (Read-Eval-Print Loop) de JavaScript conectado directamente al contexto de la página actual. Puedes:

- Ejecutar cualquier expresión JavaScript al instante.
- Acceder al DOM: `document.querySelector("h1")` devuelve el primer h1 de la página.
- Ver errores y advertencias con su archivo y número de línea.
- Usar `console.log()`, `console.error()`, `console.table()` para imprimir valores desde tu código.

```javascript
// En la consola del navegador, en cualquier página:
document.title           // Lee el título de la pestaña
document.body.style.backgroundColor = "lightblue"  // Cambia el fondo
```

### Panel Network: observar las solicitudes HTTP

El panel Network registra cada recurso que el navegador descarga: el HTML, los archivos CSS, los archivos JavaScript, las imágenes, y también las llamadas fetch a APIs.

Para cada solicitud puedes ver:
- La URL y el método HTTP (GET, POST, etc.).
- El código de estado de la respuesta (200, 404, 500…).
- Los encabezados (headers) de la solicitud y la respuesta.
- El cuerpo (body) de la respuesta — ideal para depurar una API que devuelve JSON.
- El tiempo que tardó cada recurso en descargarse.

Cuando tu `fetch()` no devuelve los datos que esperas, el primer lugar donde buscar es el panel Network.

### Panel Sources: depurar JavaScript con breakpoints

El panel Sources te permite:
- Ver el código JavaScript fuente de la página.
- Poner **breakpoints** (puntos de interrupción): haz clic en el número de una línea y el navegador pausará la ejecución exactamente ahí.
- Cuando el código está pausado, inspeccionas el valor de cualquier variable en el panel lateral.
- Avanzar línea por línea con las teclas de paso (Step Over, Step Into, Step Out).

Es el equivalente al debugger de `gdb` en C, pero integrado en el navegador.

---

## 3. Renderizado vs. ejecución: dos procesos distintos

Una confusión frecuente cuando se empieza con la web es mezclar dos procesos que ocurren en paralelo pero son conceptualmente independientes.

### Renderizado (Rendering)

El renderizado es el proceso de convertir el árbol DOM + las reglas CSS en píxeles en pantalla. El motor de renderizado del navegador (Blink en Chrome, Gecko en Firefox, WebKit en Safari) realiza estos pasos:

1. **Layout (Reflow):** Calcula la posición y el tamaño de cada caja (box model) en la página.
2. **Paint:** Dibuja los píxeles: colores, bordes, sombras, texto.
3. **Composite:** Combina las capas pintadas en la imagen final que ves.

El renderizado es costoso. Modificar una propiedad CSS que cambia el tamaño de un elemento (como `width` o `height`) dispara un nuevo layout completo. Modificar solo el color (`background-color`) es más barato porque solo requiere repintar, no recalcular posiciones.

### Ejecución (Execution)

La ejecución es lo que V8 hace con tu JavaScript. No tiene relación directa con los píxeles: es pura lógica, cálculos, solicitudes de red, manipulación de datos.

El puente entre ambos mundos es la manipulación del DOM desde JavaScript. Cuando haces:

```javascript
elemento.style.display = "none";
```

…estás ejecutando JavaScript que modifica el árbol DOM, lo que **dispara** un nuevo ciclo de renderizado en el motor gráfico.

### Por qué importa la distinción

Cuando tu página se siente lenta, el problema puede estar en:
- **JavaScript pesado:** un bucle que tarda demasiado bloquea el call stack y congela la interfaz.
- **Demasiados re-renders:** modificar el DOM dentro de un bucle, en lugar de construir los cambios y aplicarlos todos de una vez, dispara un renderizado por cada iteración.
- **Recursos externos lentos:** imágenes de alta resolución, fuentes web, scripts de terceros que bloquean el parsing del HTML.

Saber si el problema está en la ejecución o en el renderizado te dice exactamente dónde mirar con DevTools.
