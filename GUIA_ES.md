# Guía en español

Esto es tu forma de trabajar, empaquetada para que cualquiera la use en su propio
proyecto. No contiene nada de tus proyectos: ni nombres, ni stack, ni llaves, ni
ledger. El método es genérico; lo específico lo escribe cada adoptante en un archivo.

## Cómo se usa (el ritual completo)

1. **Instalar** (una vez en tu computadora):
   `/plugin marketplace add <tu-usuario>/loop-kit` y luego
   `/plugin install loop-kit@loop-kit`.
2. **Sesión 0, una vez por proyecto:** abres el proyecto y escribes `/loop-setup`.
   Esa sesión no construye nada — mira tu proyecto, **prueba en vivo** qué conexiones
   funcionan (git, base de datos, navegador, sandbox de pagos), te hace 5 preguntas
   que solo tú puedes contestar, y escribe la carpeta `.loop/`.
3. **Sesión de plan:** `./loop plan "lo que quieres lograr"`. Parte el objetivo en
   rebanadas delgadas y completas, y **deja escrito el comando exacto** de cada
   sesión siguiente.
4. **Sesiones de construcción:** `./loop build`, una y otra vez. Cada una toma la
   siguiente rebanada abierta, la termina, la verifica y la cierra.
5. **Cuando quieras saber dónde vamos:** `./loop` sin nada más. Imprime el objetivo,
   lo que sigue, lo parkeado y los últimos commits. No lanza ninguna sesión.

## Las 5 preguntas de la sesión 0 (las tuyas)

1. **¿Los archivos del método se suben a git o se quedan locales?** Tú decides. Subirlos
   = el método y el plan sobreviven a una laptop muerta. Locales = nada nuevo entra al
   historial. En los dos casos, lo sensible va a `.loop/ACCESS.local.md`, que **siempre**
   queda fuera de git.
2. ¿Cuál es la rama protegida (a la que un agente nunca empuja) y quién autoriza publicar.
3. ¿Qué comandos están prohibidos para el agente (un deploy, una migración de producción,
   un borrado de datos).
4. ¿Hay un recurso compartido donde dos sesiones podrían chocar, y con qué comando se lee
   su estado real.
5. ¿Trabajas solo o en equipo? Solo: cerrar = commit en rama. Equipo: cerrar = pull
   request + CI verde + revisor.

## Lo que sí obliga y lo que solo pide

**Obliga de verdad** (dos hooks): empujar a la rama protegida se **bloquea**, y los
comandos que declaraste prohibidos se **bloquean**.

**Solo pide** (todo lo demás): ningún hook puede saber si de verdad verificaste algo.
Un candado sobre "¿ya lo verificaste?" solo puede buscar una frase que el propio modelo
escribe — y eso le enseña a escribir la frase. Preferí decirlo en el README que
venderlo como candado. Es la diferencia entre un método honesto y uno que se cae en la
primera semana.

## El límite del modelo por sesión, sin adornos

Verifiqué contra el binario de Claude Code: una sesión **no puede** cambiar su propio
modelo mientras corre, y **no puede** ni leer en qué modelo está (existe la variable
del esfuerzo, no la del modelo). Entonces el plan no *cambia* la siguiente sesión:
**escribe el comando exacto** para lanzarla, y el `./loop` lo hace por ti.

Y la parte importante: el pensamiento caro **no vive en la sesión principal**. Las
skills de plan, council y cierre despachan subagentes cuyo modelo y esfuerzo están
clavados en su propia definición. Así, aunque alguien abra una sesión de cualquier
manera, la planeación y el red-team los sigue haciendo un modelo fuerte. La calidad
deja de depender de que alguien se acuerde.

## Publicarlo

El repo ya está listo y committeado localmente en `~/Desktop/loop-kit`. **No lo subí a
GitHub** — publicar es tu decisión: nombre de usuario, público o privado, y con qué
licencia. Cuando quieras, dime y lo empujo (o lo haces tú con dos comandos que te doy).

Antes de publicar conviene: leerte el `README.md` de arriba abajo (es lo que va a leer
un extraño), y decidir si el nombre `loop-kit` es el que quieres.

## Tu propio repo, aparte

Cosa distinta que encontré y te dejo anotada: en tu proyecto, `.gitignore` ignora
`*.md` y `.claude/`, y hay **0 archivos .md en git**. O sea que tu protocolo, tu plan
vivo y toda tu memoria de proyecto viven en un solo disco, sin respaldo. Eso no es
parte de este paquete — es tuyo, y arreglarlo bien pide una revisión de secretos antes
de versionar nada (por eso no lo toqué de pasada). Cuando quieras lo hacemos como su
propia rebanada.
