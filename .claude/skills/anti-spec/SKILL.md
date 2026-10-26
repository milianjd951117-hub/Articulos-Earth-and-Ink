---
name: anti-spec
description: Revisión adversarial de un spec con un subagente sin contexto, antes de aprobarlo. Seis preguntas: fallos intermedios y pérdidas, criterios comprobables, simplificación, supuestos implícitos, errores humanos y crecimiento. Úsalo SIEMPRE que se escriba, revise, corrija o vaya a aprobar un spec (SPEC*.md, CAPABILITY-MAP.md o la fase Specify de spec-driven-development), y cuando el usuario pida "anti-spec", "revisa el spec" o "busca fallos en el spec". Use before approving any spec.
argument-hint: "[ruta al spec; por defecto, el SPEC*.md modificado más recientemente]"
---

# anti-spec

Un spec escrito por el mismo agente que conversó con el usuario hereda sus puntos ciegos. Esta skill hace que
lo revise **alguien que no estuvo en la conversación**: un subagente que solo ve los archivos. Así, lo que el
spec no dice por escrito no existe para el revisor.

## Cuándo
- Después de escribir o cambiar un spec, y **antes** de pedir al usuario que lo apruebe.
- Un spec no se marca como aprobado mientras esta revisión no se haya hecho y su resultado no se le haya mostrado al usuario.

## Proceso

### 1. Reunir solo los archivos
- Identifica el spec a revisar (argumento o el `SPEC*.md` más reciente), el `CAPABILITY-MAP.md` si existe y la
  investigación que el spec cite (`docs/research/*`).
- **No resumas la conversación para el revisor.** Si algo importante solo está en el chat, eso ya es un hallazgo: escríbelo
  primero en el spec y después lanza la revisión.

### 2. Lanzar el subagente sin contexto
Usa la herramienta `Agent` con `subagent_type: "general-purpose"` y `run_in_background: false`. **Nunca uses `fork`**, que hereda la conversación.
El prompt es esta plantilla, rellenando solo `<RUTAS>` y `<UNA_LINEA_DE_PRODUCTO>`:

```
Eres un revisor adversarial. No tienes contexto previo y no lo necesitas: juzga solo lo que está escrito.
Lee completos estos archivos: <RUTAS>. Producto en una línea: <UNA_LINEA_DE_PRODUCTO>.
No modifiques ningún archivo.

Responde estas preguntas con hallazgos concretos (nada genérico):

1. ¿Qué pasa si algo falla a mitad de camino? Busca fallos intermedios y pérdidas (de datos, de dinero, de
   trabajo del usuario) que el spec no cubra: cierres a mitad de operación, operaciones a medias, reintentos,
   red que se corta, datos borrados, reloj incorrecto, permisos que cambian, cuotas agotadas, actualizaciones
   con trabajo pendiente, entradas inválidas. Para cada uno: escenario concreto → consecuencia → ¿cubierto?
   (sí/parcial/no) → mitigación mínima.

2. ¿Cada criterio de aceptación se puede comprobar siempre, sin depender de conceptos abstractos? Revísalos uno
   a uno: marca los ambiguos, los no deterministas, los que dependen de algo no controlable o les falta una
   condición de entrada o salida, y propón la redacción corregida. Lista también los requisitos que no tienen
   ningún criterio que los compruebe, y las contradicciones entre criterios.

3. ¿Hay forma de simplificar? Señala lo que sobra para la escala real del producto y las decisiones cuya
   complejidad no compensa su costo, con una alternativa más simple y su contrapartida. Di también qué parece
   complejo pero es necesario.

4. ¿Qué da por hecho el spec sin escribirlo? Lista los supuestos implícitos sobre usuarios, dispositivos, datos,
   red o entorno. Para cada uno: qué pasa si resulta falso y si debería escribirse en el spec.

5. ¿Qué haría mal un usuario real? Errores humanos y usos imprevistos (repetir una acción, cancelar a mitad,
   equivocarse de dato, compartir la cuenta, usarlo con prisa o con una mano). Para cada uno: consecuencia →
   ¿el spec lo previene o lo hace recuperable? → mitigación mínima.

6. ¿Qué pasa cuando crece? Con 10 veces más datos, usuarios o tiempo de uso: qué límite, costo o rendimiento
   se rompe primero y a partir de qué número aproximado.

Verifica las afirmaciones técnicas del spec contra la documentación oficial (WebFetch/WebSearch) y cita la
fuente. Separa "verificado" de "no encontrado en la documentación".

Formato: una sección por pregunta y al final "Top 5 cambios recomendados", ordenados por gravedad.
Máximo ~1300 palabras, en el idioma del spec.
```

Las 6 preguntas son obligatorias en cada revisión.

### 3. Triage, no copia
Lo que devuelve el subagente es una opinión, no una orden. Por cada hallazgo:
- **Aplicar:** el fallo es real y la mitigación es proporcional. Corrige el spec.
- **Delegar:** pertenece a otro módulo. Anótalo en la sección "Delegado a otros módulos" del spec.
- **Descartar:** explica en una línea por qué (camino irreal, o la solución cuesta más de lo que evita).

Añade o actualiza en el spec una sección `## Registro de revisión` con la fecha, las preguntas usadas y los cambios aplicados.

### 4. Feedback al usuario
Responde en lenguaje llano, con una sección por pregunta:
- **¿Qué pasa si algo falla?** Los fallos más graves, cada uno con su solución, en una línea.
- **¿Se puede comprobar cada criterio?** Cuántos estaban mal, un ejemplo de antes y después, y cuántos criterios hay ahora.
- **¿Se puede simplificar?** Qué se simplificó y qué se mantuvo por ser necesario.
- **¿Qué da por hecho?** Los supuestos que ahora quedaron escritos.
- **¿Qué haría mal un usuario?** Los errores humanos que ahora se previenen o se pueden recuperar.
- **¿Qué pasa cuando crece?** El primer límite que se rompe y a partir de qué número.

Termina con las decisiones que necesitas del usuario. **No marques el spec como aprobado**: solo el usuario
lo aprueba, con un "sí" explícito y después de ver este feedback.

## Señales de que se está haciendo mal
- El prompt del subagente incluye un resumen de la conversación, o se usó `fork`.
- Se copiaron los hallazgos al spec sin triage.
- El spec se marcó como aprobado en el mismo turno en que se hizo la revisión.
- El feedback al usuario es la salida cruda del subagente.
