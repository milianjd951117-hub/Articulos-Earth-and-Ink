## Trabajo con varios agentes en paralelo (graph-guard)
Antes de repartir un trabajo entre varios agentes, o de delegar en subagentes con un modelo
más barato, aplica el skill `graph-guard`. Si el diseño pasa el paso 1, pásale solo el diseño
al subagente `graph-auditor` y corrige los bloqueantes. No ejecutes el grafo sin mi aprobación
explícita. Entrevistas (grill), diseño, verificación y síntesis van siempre en el modelo más
fuerte; no cambies de modelo con `/model` a mitad del trabajo.
