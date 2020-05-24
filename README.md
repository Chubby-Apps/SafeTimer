# SafeTimer
![Image](docs/assets/banner.jpg?)

![Versión](https://img.shields.io/badge/Versión-1.0.1-blue)

SafeTimer es una app para iPhone y Apple Watch ([App Store](https://apps.apple.com/app/apple-store/id1512032981?pt=121500132&ct=github&mt=8)) que te ayuda a controlar el tiempo que has usado una mascarilla. Ha sido creada de forma altruista por [Hortelanos](https://hortelanos.net), es completamente gratuita (ni compras in-app, ni anuncios) y su código está publicado de forma abierta para que cualquiera pueda contribuir a mejorarla.

### ¿En qué se diferencia de un simple temporizador?

1. Puedes crear todos los temporizadores que quieras y darles nombre.
2. La app recuerda el tiempo de uso que le queda a cada mascarilla.
3. Cuenta el tiempo “de más” que le has dado a cada mascarilla.

### ¿Cómo se usa?

1. Cuando vayas a empezar una nueva mascarilla crea un temporizador, dale un nombre y pon el tiempo de uso recomendado por el fabricante.
2. Arranca/para el temporizador según uses la mascarilla. SafeTimer se acuerda de cuánto tiempo de uso le queda.
3. Cuando llegue el momento de cambiar la mascarilla la app te enviará una notificación y contará el tiempo de uso de más que le hayas dado.

### ¿Por qué no aparecen mascarillas con sus tiempos recomendados en la app?

Debido a la situación actual Apple ha impuesto ciertas limitaciones en lo que a apps relacionadas con el COVID-19 se refiere por lo que hemos tenido que hacerla algo más genérica para poder publicarla. Eso sí, la funcionalidad es la misma.

### Detalles técnicos

- La app ha sido desarrollada de forma nativa en Swift y SwiftUI y está disponible en iPhone con iOS 13 o superior y Apple Watch con watchOS 6.0 o superior.
- Utiliza Core Data y CloudKit para almacenar los datos y sincronizarlos en la nube.
- Las notificaciones se envían de manera local. No necesitas tener buena cobertura o acceso a internet para que funcionen.
- Ocupa menos de 1 mb, por lo que no tienes que hacer hueco en tu teléfono para instalarla.
- La versión para el Apple Watch es completamente independiente y no necesita de conexión a internet o al iPhone para funcionar. Ni siquiera para configurarla.

### Futuras mejoras

- Crear temporizadores predeterminados.
- Avisos cada hora de más que uses una mascarilla.
- Elegir distintos iconos para el temporizador.
- Widget.
- Múltiples iconos para la app.
- Acceso rápido desde el icono de la app.
- Complicaciones dinámicas en el Apple Watch.
- Integración con Siri y Atajos.
- Leer el código de barras de una mascarilla y crear un temporizador con el tiempo de uso recomendado por el fabricante.

### Idiomas

SafeTimer está disponible en Castellano, Euskera, Inglés y Francés. Si quieres ayudarnos a traducirla crea un pull-request.

### Equipo

- Código por Asier G. Morato.
- Diseño por Patricia Bedoya.
- Traducciones por Patricia Bedoya, Miguel de Andrés y Carla Auclair.