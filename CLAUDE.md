## Varios agentes en paralelo (graph-guard)
No ejecutes un grafo de agentes sin mi aprobación explícita. Entrevistas (grill), diseño, verificación
y síntesis van siempre en el modelo más fuerte; no cambies de modelo con `/model` a mitad del trabajo.

## Qué skill usar (plugin `agent-skills` de Addy Osmani)
| Pedido | Skill |
|---|---|
| Artículo o serie sin público, objetivo o formato claro | `agent-skills:interview-me` |
| Idea suelta que hay que afinar antes de escribir | `agent-skills:idea-refine` |
| Plan de una serie o cambio grande con varias decisiones | `agent-skills:spec-driven-development`, y `/anti-spec` antes de aprobarlo |
| Partir un plan aprobado en tareas | `agent-skills:planning-and-task-breakdown` |
| Documentar una decisión (tono, formato, fuentes) | `agent-skills:documentation-and-adrs` |
| Commits y ramas | `agent-skills:git-workflow-and-versioning` |
| Editar este CLAUDE.md o una skill | `agent-skills:context-engineering` |

`/plan` y `/review` abren los comandos de Claude Code; los del plugin son `/agent-skills:plan` y `/agent-skills:review`.
