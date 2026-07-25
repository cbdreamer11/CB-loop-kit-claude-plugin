# loop-kit

*[English](README.md) · **Español***

Una forma de trabajar para construir software real con agentes, a lo largo de muchas sesiones.

Existe para matar una falla concreta: **trabajo reportado como terminado que nunca se
observó funcionando.** Esa falla es cara porque se descubre semanas después, cuando ya hay
otras cosas construidas encima.

El método son cinco reglas y seis comandos. Nada aquí es específico de un lenguaje, un
framework o una base de datos — lo único que escribes es un archivo corto declarando cómo
se ve *"funciona de verdad"* en tu proyecto.

---

## Instalación

**Como plugin (recomendado — se actualiza con `/plugin update`):**

```
/plugin marketplace add cbdreamer11/CB-loop-kit-claude-plugin
```

y después

```
/plugin install loop-kit@loop-kit
```

**O como skills sueltas (sin maquinaria de plugin):** copia `skills/*` a
`~/.claude/skills/` para todos tus proyectos, o a `.claude/skills/` para uno solo. Copia
`agents/*` a `.claude/agents/` del proyecto.

Luego, en el proyecto donde vas a trabajar:

```
/loop-kit:loop-setup
```

Esa es la **sesión 0**. Lee tu proyecto, comprueba qué conexiones funcionan de verdad, te
hace las pocas preguntas que solo tú puedes contestar, y escribe los archivos. No construye
nada.

> Instalado como plugin, las skills llevan prefijo — `/loop-kit:loop-setup`. Si en vez de
> eso copiaste las skills a `~/.claude/skills/`, son simplemente `/loop-setup`.

---

## Los comandos

Dos formas de correr lo mismo. **Las skills son el método; el wrapper es solo un lanzador
que además elige el modelo por ti.**

| Lo que quieres | En la app de escritorio o un IDE | En una terminal |
|---|---|---|
| Sesión 0, una vez por proyecto | `/loop-kit:loop-setup` | `/loop-kit:loop-setup` |
| Planear una épica | `/loop-kit:loop-plan <objetivo>` | `./loop plan "<objetivo>"` |
| Construir la siguiente rebanada | `/loop-kit:loop` | `./loop build` |
| Verificar con honestidad | `/loop-kit:loop-verify` | `./loop verify` |
| Council para una duda abierta | `/loop-kit:loop-council` | — (invoca la skill) |
| Auditar, registrar, entregar | `/loop-kit:loop-close` | `./loop close` |
| ¿Dónde va el trabajo? | `/loop-kit:loop-doctor`, o lee `.loop/STATE.md` | `./loop` |
| Revisar la instalación | `/loop-kit:loop-doctor` | `./loop doctor` |

**La única diferencia real:** en una terminal, `./loop plan` lanza la sesión *con* el modelo
y el esfuerzo ya puestos, porque un rol es un perfil de ajustes que se pasa al lanzar. En la
app eliges el modelo tú mismo en el selector antes de invocar la skill — nada puede
cambiarlo por ti, porque una sesión que ya corre no puede cambiar su propio modelo.

Esa diferencia cuesta menos de lo que suena, y esta es la razón: `loop-plan`,
`loop-council` y `loop-close` **despachan subagentes** cuyo modelo y esfuerzo están fijados
en su propia definición. Así que incluso en la app, con una sesión de gama media, la
planeación y el red-team los hace el modelo fuerte. El wrapper es comodidad; lo que protege
la calidad es la arquitectura.

---

## El único archivo que tú llenas

`.loop/VERIFY.md` es toda la razón de que esto sea portable. Cuatro casillas, cada una con
un comando real *de tu* proyecto:

- **BUILD** — compila / pasan las pruebas. Necesario, nunca suficiente.
- **OBSERVE** — la cosa haciendo lo suyo, mirada, con un artefacto. Una página renderizada en
  un navegador real con la consola limpia; un comando de terminal y su salida; el campo nuevo
  en una respuesta.
- **DATA** — consulta el almacén y confirma el efecto, incluido el **negativo** (el valor
  equivocado se rechaza, quien no tiene permiso no obtiene nada).
- **MONEY** — solo si se mueve dinero: el modo de prueba del proveedor, de verdad.

Dos reglas de evidencia que cazan casi todos los verdes falsos: **un código de salida no es
evidencia**, y **un HTTP 200 no es evidencia** — muchos servidores responden 200 para una
página que no existe. Verifica por una cadena que solo exista en el comportamiento nuevo.

Una casilla que no puedas correr se convierte en un **GAP declarado**, y lo que la necesita
se entrega como "verificado excepto X" — nunca como terminado.

---

## Roles de sesión, y un límite dicho sin adornos

Trabajos distintos piden pensamientos distintos, así que cada rol es un perfil de lanzamiento
(`.loop/roles/*.json`) que fija el modelo, el esfuerzo y el agente aplicado al hilo principal:

| Rol | Modelo / esfuerzo | Para qué |
|---|---|---|
| plan | el más fuerte / xhigh | decide lo que harán todas las sesiones baratas |
| build | intermedio / medium | el caballo de batalla; las decisiones difíciles ya se tomaron |
| verify | intermedio / high | su trabajo es no dejarse engañar |
| close | el más fuerte / xhigh | auditoría adversarial antes de publicar cualquier cosa |

La sesión 0 **te pregunta qué modelos tienes de verdad** y escribe esos alias en los
perfiles — los planes cambian, y una instalación gestionada puede restringir modelos. Si
solo tienes uno, el método igual funciona; nada más pierde el gradiente. Lo que nunca hará
es dejar un perfil apuntando a un modelo que no tienes, porque un modelo no disponible
puede caer a otro **en silencio**, y una caída silenciosa es exactamente la falla que este
kit existe para evitar.

**El límite, sin adornos:** una sesión no puede cambiar su propio modelo mientras corre, y no
puede ni leer en qué modelo está. Así que un plan no *cambia* la siguiente sesión — escribe el
comando exacto para lanzarla. La consecuencia importante: el pensamiento caro **no** vive en el
hilo principal. `plan`, `council` y `close` despachan subagentes cuyo modelo y esfuerzo están
clavados en su propia definición, así que una sesión lanzada de cualquier manera igual recibe
planeación y red-team de un modelo fuerte. Aquí elegir modelo es arquitectura, no disciplina.

---

## Qué obliga, y qué solo pide

Ser claro en esto es el punto. Dos hooks obligan las únicas dos cosas que una máquina puede
comprobar de verdad:

- empujar a la rama protegida se **bloquea**
- los comandos que declaraste prohibidos se **bloquean**

Todo lo demás es una regla que el agente sigue, no un candado: **ningún hook puede saber si
algo se verificó de verdad.** Un candado sobre "¿ya lo verificaste?" solo puede buscar una
frase que el propio agente escribe, lo que le enseña a escribir la frase. Este kit no finge.
Los dos hooks también son evitables por diseño (modo seguro, hooks apagados, ajustes
gestionados) — son barandal contra un error honesto, no una frontera de seguridad.

Dos límites que conviene saber antes de que te sorprendan. El guard **solo obliga en un
proyecto que ya corrió la sesión 0** — instalar esto nunca debe cambiar cómo se comporta git
en tus otros repos. Y compara contra el texto del comando, así que algo que solo *menciona*
un comando bloqueado también se bloquea; reformúlalo, o que lo corra el dueño.

---

## Requisitos

- Claude Code (los perfiles de rol usan `--settings`, `--model`, `--effort` y el ajuste
  `agent`; el campo `effort` del frontmatter de agente se respeta).
- `sh` POSIX para el wrapper y los dos hooks. Sin `jq`, sin `perl`. En Windows, Git Bash o WSL.
- Nada más. Sin base de datos, sin herramientas de navegador, sin proveedor de pagos — la
  sesión 0 te dice cuáles de esos tienes, y convierte cada uno que falte en un gap declarado
  en vez de uno silencioso.

## Deliberadamente fuera

Protocolo de incidentes, higiene de ramas, ledger de migraciones, publicar apagado tras una
bandera, QA multicapa, flujos de revisión en equipo. Son reales, y son la siguiente capa —
pero un método que nadie termina de leer es un método que nadie adopta. Cinco reglas, seis
comandos, cuatro archivos.

## Licencia

MIT.
