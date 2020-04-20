---
noteId: "60951620835a11eaa1a8852f87ab6ca6"
tags: []

---


# CIU-9-Shaders

### Autor: Víctor Herrera Delgado
Estudiante de Ingeniería Informática en la Universidad de Las Palmas de Gran Canaria, en último curso de su grado.

## Dependencias
- Processing.sound
- Processing.video
- org.opencv

## Introducción 
La práctica en cuestión consiste en dados los conocimientos explicados en clase acerca de los shaders, implementar shaders ya sea en un nuevo programa o en uno de prácticas anteriores. En este caso, aprovecharemos la práctica 6 de cámara y video para integrar un nuevo filtro divertido para el usuario.

## Concepto
Tras un bloqueo mental extenso durante el cual se revisó la teoría de TheBookOfShaders y varios ejemplos de ShaderToy, se decidió buscar crear un shader que mostrara una espiral en movimiento que generara un efecto de túnel. Se consiguió un movimiento en espiral que cambiaba de color constantemente y que se movía alrededor de un eje central, lo cual creaba un efecto óptico al mirar hacia otro lado de profundidad.

Sin embargo, como una simple representación no me parecía suficiente, busqué darle un nuevo uso. Por ello, teniendo como base el detector de caras usado en la práctica 6, se ha aplicado el shader a la imagen de la cámara. Teniendo como eje central la frente de la persona frente a la cámara, emulamos el efecto clásico utilizado en series de animación antiguas para emular poderes mentales, véase la emisión de ondas con la mente.

## Programa
El programa es idéntico al mostrado en la práctica 6 con ligeras modificaciones para incluir este nuevo concepto. Puede ver la práctica 6 en el siguiente enlace: https://github.com/VictorHerreraDelgado/CIU-6-Imagen_y_video .

Pulsando la tecla X (en referencia al Profesor Xavier, telépata de los comics X-Men), el usuario cambiará a un modo en el cual desde su frente aparecerá una espiral, acompañada de ondas elípticas procedentes del mismo eje. El tono de las ondas y la espiral cambiará con el paso del tiempo.

## Código
### Processing: Practica9
Al código de la práctica 6 se le ha añadido el nuevo modo y su implementación con el detector de caras. El resto del código es explicado en el README de la práctica 6 que puede encontrar aquí: https://github.com/VictorHerreraDelgado/CIU-6-Imagen_y_video .

### GLSL: myShader.glsl
Además de las variables globales que obtiene de parte del código en Processing, el archivo cuenta con las siguientes funciones principales:
- **mainImage()** : La parte principal del código. se encarga de llamar a las funciones auxiliares y de obtener los pixeles de la imagen captada por cámara y modificarlos para mostrar el efecto buscado.  
- **uzumaki()** : Es la función encargada de generar la espiral (Uzumaki es espiral en japonés). 

- **inCircle()** : Es la función que comprueba si un pixel forma parte de la onda elíptica que acompaña a la espiral. 


## Teclas y ratón

- **Espacio**: cámara normal.
- **E** : modo en el que cambia los colores de la cámara a los colores de la bandera.
- **P** : modo en el que detecta cada cara en pantalla y las pixela.
- **X** : modo en el cual el shader se combina con la imagen.

## Funcionamiento
El gif no muestra el verdadero rendimiento de la aplicación.  
![](Practica9.gif)


## Referencias

- Guía de prácticas:  
https://cv-aep.ulpgc.es/cv/ulpgctp20/pluginfile.php/126724/mod_resource/content/34/CIU_Pr_cticas.pdf  

- ShaderToy:  
https://www.shadertoy.com/  

- TheBookOfShaders:  
https://thebookofshaders.com/

- Conversor de video a gif   
https://hnet.com/video-to-gif/

- Grabación del programa   
https://obsproject.com/
