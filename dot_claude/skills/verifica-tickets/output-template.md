# Template de Saída

## Análise individual de cada ticket

Para cada ticket, mostrar:

```markdown
---

### Ticket: [HYPERFLEET-XXX](https://redhat.atlassian.net/browse/HYPERFLEET-XXX)

**Abertura:** YYYY-MM-DD HH:MM:SS UTC

**Análise:**

| Critério | Status | Observação |
|----------|--------|------------|
| **Título** | ok/alerta | Claro e < 100 chars, ou alerta |
| **Descrição** | ok/alerta/erro | Tamanho e red flags ("TBD", "maybe") |
| **What/Why/AC** | ok/alerta/erro | O que está faltando |
| **Duplicado?** | ok/alerta/erro | Detalhes |
| **Epic linkado** | ok/erro | HYPERFLEET-XXX ou - |
| **Prioridade** | ok/erro | Normal/Critical/Blocker (se erro, sugerir valor) |
| **Urgente/Blocker?** | ok/erro | Detalhes |
| **Story Points** | ok/alerta/erro | Valor, sugestão via estimator, ou alerta Fibonacci |
| **Fix Version** | ok/erro | Versão ou - |
| **Assignee** | ok/erro | Nome ou Unassigned |
| **Component** | ok/erro | Nome ou - |
| **Activity Type** | ok/erro | Tipo ou Uncategorized |
| **Sprint** | ok/alerta/erro | Nome do sprint ou sugestão baseada na prioridade |

**Recomendação:**
[Lista de ações necessárias ou "Pronto para desenvolvimento"]

---
```

## Resumo Executivo

Ao final, mostrar tabela resumo:

```markdown
## Resumo Executivo

| Ticket | Pronto? | Ação Necessária |
|--------|---------|-----------------|
| HYPERFLEET-XXX | ok/erro | Descrição da ação |
```

## Flags para Tech Leads

Listar tickets que precisam de atenção:
- Bugs ou Critical/Blocker sem assignee
- Possíveis duplicados
- Sem Epic ou Fix Version para tickets Critical+ (exceto Bugs, que não precisam de Epic)
- Tickets sem Activity Type (impacta capacity planning)
- Tickets sem Component
- Blocker/Critical sem sprint atribuído

## Correções automáticas

Ao final da análise, pergunte ao usuário se deseja aplicar as correções sugeridas automaticamente via `jira issue edit`. Exemplo de comandos permitidos:

```bash
jira issue edit HYPERFLEET-XXX --custom story-points=3 --no-input
jira issue edit HYPERFLEET-XXX --priority Major --no-input
jira issue edit HYPERFLEET-XXX --component "sentinel" --no-input
```
