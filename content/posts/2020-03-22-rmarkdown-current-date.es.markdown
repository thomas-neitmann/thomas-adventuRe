---
title: Mostrar la fecha actual automáticamente en un informe Rmarkdown
author: Thomas Neitmann
date: '2020-03-22'
slug: rmarkdown-actualizar-fecha
categories:
  - bytesized
  - R
tags:
  - rmarkdown
  - knitr
toc: no
images: ~
---



<!-- `Rmarkdown` is a great tool for creating data-driven reports that have to be updated on a regular basis. To communicate to stakeholders that the report is indeed up to date it's important to display the current date below the title. -->

`Rmarkdown` es una herramienta fantástica para crear informes impulsados por datos que requieran actualizarse regularmente. Para que los lectores sepan que el informe está realmente actualizado, es importante mostrar la fecha actual debajo del título.

<!-- An obvious solution to display the current date is to update the date field in the YAML header manually before knitting. But this is both error prone and you are likely to forget about it. Instead you can dislay the current date in an automatic way using the method below. -->

Una solución obvia para mostrar la fecha actual sería modificar manualmente el campo de la fecha en el encabezado YAML antes de compilar el informe (*knit*). Pero esto puede conllevar errores y es probable que se te olvide actualizarlo. En cambio, puedes mostrar la fecha actualizada automáticamente usando el método a continuación.


```r
---
title: "Informe Superimportante"
author: "Thomas Neitmann"
date: `r Sys.Date()`
---
```

<!-- When knitting the `Rmarkdown` document `Sys.Date()` will be evaluated and display the current date. -->

Cuando se compila (*knit*) el documento `Rmarkdown`, la función `Sys.Date()` será evaluada y mostrará la fecha actual.


```r
Sys.Date()
## [1] "2021-02-11"
```

<!-- A caveat is the date format, though. `Sys.Date()` returns the current date in ISO 8601 format, i.e. `yyyy-mm-dd`. Your audience is likely not used to this format so you might want to use a date format that's common in your locale. -->

<!-- How to achieve that? Using the `format()` function. Here are some examples. -->

Sin embargo, hay que tener cuidado con el formato de la fecha. `Sys.Date()` devuelve la fecha actual con el formato ISO 8601 (`yyyy-mm-dd`). Es probable que tus lectores no estén acostumbrados a este formato y, por lo tanto, quieras utilizar el formato que se usa en tu región.

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

¿Cómo podemos hacerlo? Usando la función `format()`. He aquí algunos ejemplos.


```r
fecha_actual <- Sys.Date()
format(fecha_actual, "%d.%m.%Y")
## [1] "11.02.2021"
format(fecha_actual, "%d. %B %Y")
## [1] "11. Februar 2021"
format(fecha_actual, "%m/%d/%Y")
## [1] "02/11/2021"
```

<!-- After deciding which format to use make sure to wrap `Sys.Date()` inside of `format()` in your YAML header. -->

Una vez que hayas decidido qué formato utilizar, incluye `Sys.Date()` dentro de `format()` en el encabezado YAML.


```r
---
title: "Informe Superimportante"
author: "Thomas Neitmann"
date: `r format(Sys.Date(), "%d. %B %Y")`
---
```

*<small>Este artículo ha sido traducido del original en inglés por Gustavo Zapata Wainberg.</small>*
