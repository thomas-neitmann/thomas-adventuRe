---
title: 'Entendiendo la Evaluación No Estándar. Parte 1: Lo Básico'
author: Thomas Neitmann
date: '2021-01-27'
slug: entendiendo-evaluacion-no-estandar-parte1
categories:
  - R
  - article
tags: []
toc: no
images: ~
---

La Evaluación No Estándar---ENE, o también NSE, por sus siglas en inglés---es uno de esos términos técnicos que a los magos de R les gusta usar en discusiones acerca del lenguaje. ¿Pero qué es exactamente la Evaluación No Estándar? Para responder esta pregunta y desmitificar el concepto, hablaré primero de su opuesto, es decir, la evaluación **estándar**.

Tomemos el ejemplo de seleccionar una única columna desde un data frame. En R base puedes hacer esto usando ya sea `[[` o `$`. El primer operador usa semántica de evaluación estándar, mientras que el segundo usa ENE.

Al usar `[[` tienes que pasar un *string* o *character* dentro de los corchetes. En el caso más simple puedes usar un string *literal*.


```r
data(iris)
head(iris[["Species"]])
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

Pero también puedes pasar un *symbol* dentro de `[[`. Este "símbolo" será *evaluado* a un *valor* (que esperamos que sea un string o un número, ya que en otro caso obtendrás un error).


```r
var <- "Species"
head(iris[[var]])
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

No hay sorpresas hasta ahora. A continuación, miremos el comportamiento de `$`. Al igual que con `[[`, puedes pasar un string literal a `$`.


```r
head(iris$"Species")
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

Sin embargo, es probable que nunca hagas eso en la práctica, simplemente porque con `$` no es necesario. En vez de hacer eso, puedes pasar un símbolo al lado derecho de `$`.


```r
head(iris$Species)
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

Esto es muy conveniente para cuando estés escribiendo código interactivamente en la consola, ya que requiere 2 pulsaciones de teclas menos. Ahora, ¿qué sucede si pasamos `var` (definido arriba) al lado derecho de `$`?


```r
head(iris$var)
```

```
## NULL
```

¿No esperabas eso? ¡No estás solo! Este es el punto donde veo a muchos programadores de R principiantes tener dificultades. Recuerda, el símbolo `var` contiene el valor `"Species"`. Usando semántica de evaluación estándar, R evaluaría `var` a su valor. 

Sin embargo, ese *no* es el caso al usar `$`, porque `$` usa ENE. En cambio, `$` busca una columna llamada `var` dentro del data frame `iris`. Como no existe tal columna, obtienes `NULL` como resultado (yo preferiría que se arrojara un error, pero así son las cosas).

<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- B -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1597114514381206"
     data-ad-slot="6037303850"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>

Además de `Species`, el data frame `iris` también contiene una columna llamada `Sepal.Length`. Según lo que hemos discutido hasta ahora, puedes seleccionar esa columna ya sea usando `iris[["Sepal.Length"]]` o `iris$Sepal.Length`. Pero, ¿qué sucede si hay una variable llamada `Sepal.Length` en el entorno global?


```r
Sepal.Length <- "Species"
```

¿Qué devolverán `iris[[Sepal.Length]]` e `iris$Sepal.Length`, respectivamente en este caso? Antes de seguir leyendo, **haz una pausa** y piensa sobre ello. Con lo que hemos cubierto hasta ahora, deberías poder responder esa pregunta correctamente. Si aún no estás seguro, regresa al principio y lee los párrafos anteriores una vez más.

Empecemos con `iris[[Sepal.Length]]`. Al usar `[[`, el símbolo `Sepal.Length` es evaluado a su valor `"Species"`. Por lo tanto, en este caso `iris[[Sepal.Length]]` es lo mismo que `iris[["Species"]]`.


```r
head(iris[[Sepal.Length]])
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

Por otro lado, cuando se usa `iris$Sepal.Length`, a R simplemente no le importa si existe una variable llamada `Sepal.Length` en el entorno global. En cambio, lo primero que hace es buscar una variable llamada `Sepal.Length` dentro del data frame` iris` y, efectivamente, hay una.


```r
head(iris$Sepal.Length)
```

```
## [1] 5.1 4.9 4.7 4.6 5.0 5.4
```

Entonces, aunque llames a `iris$Sepal.Length` en el entorno global, y en el mismo entorno haya un símbolo llamado `Sepal.Length` vinculado a un valor, R simplemente lo omite. En cambio, trata al data frame en sí mismo como un entorno, y si evalúas `Sepal.Length` allí obtienes de vuelta el contenido de esa columna. Eso no sigue en absoluto la semántica de evaluación estándar de R, razón por la cual este proceso se llama evaluación no estándar.

<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- B -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1597114514381206"
     data-ad-slot="6037303850"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>

Si entendiste lo que hemos cubierto hasta ahora, acabas de dar un gran paso hacia adelante en tu viaje hacia el dominio de R. Pero espera, ¡hay más por venir! En la parte 2 de esta publicación, te mostraré cómo implementar una función NSE por tí mismo. Al hacer eso, profundizarás aún más tu comprensión y aprenderás sobre algunos de los componentes internos de R que le dan el superpoder para escribir paquetes como {dplyr}. ¡Mantente atento!

*Este post ha sido traducido desde el original en inglés por [\@francisco_yira](https://twitter.com/francisco_yira).*
