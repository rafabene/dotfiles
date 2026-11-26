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
| **Prioridade** | ok/erro | Normal/Critical/Blocker (se erro, sugerir valor) |
| **Urgente/Blocker?** | ok/erro | Detalhes |
| **Story Points** | ok/alerta/erro | Valor, sugestão via estimator, ou alerta Fibonacci |
| **Assignee** | ok/erro | Nome ou Unassigned |
| **Component** | ok/erro | Nome ou - |
| **Activity Type** | ok/erro | Tipo ou Uncategorized |
| **Sprint** | ok/alerta/erro | Nome do sprint ou sugestão baseada na prioridade |
| **Links** | ok/alerta/erro | Lista de links (chave + direção), inconsistências de direção ou links ausentes |

**Recomendação:**
[Lista de ações necessárias ou "Pronto para desenvolvimento"]

---
```

Sempre que outro ticket for citado dentro da tabela (coluna Observação) ou na Recomendação — duplicado, dependência mencionada na descrição, link ausente ou com direção incorreta — use o link completo em formato markdown `[HYPERFLEET-XXX](https://redhat.atlassian.net/browse/HYPERFLEET-XXX)`, nunca a chave nua.

## Resumo Executivo

Ao final, mostrar tabela resumo. A coluna `Ticket` deve sempre usar o link completo em formato markdown, nunca a chave nua:

```markdown
## Resumo Executivo

| Ticket | Pronto? | Ação Necessária |
|--------|---------|-----------------|
| [HYPERFLEET-XXX](https://redhat.atlassian.net/browse/HYPERFLEET-XXX) | ok/erro | Descrição da ação |
```

## Flags para Tech Leads

Listar tickets que precisam de atenção. Toda chave de ticket citada (o próprio ticket analisado ou qualquer outro mencionado, como duplicados ou dependências) deve aparecer como link completo em formato markdown `[HYPERFLEET-XXX](https://redhat.atlassian.net/browse/HYPERFLEET-XXX)`, nunca como chave nua:
- Bugs ou Critical/Blocker sem assignee
- Possíveis duplicados
- Tickets sem Activity Type (impacta capacity planning)
- Tickets sem Component
- Blocker/Critical sem sprint atribuído
- Links com direção incorreta (blocks/is blocked by trocados)
- Dependências mencionadas na descrição sem link correspondente
- Links "is blocked by" apontando para ticket já Closed/Resolved/Done (possível link obsoleto)

## Correções automáticas

Ao final da análise, pergunte ao usuário se deseja aplicar as correções sugeridas automaticamente via `jira issue edit`/`jira issue link`. Isso inclui os links sinalizados como ausentes ou com direção incorreta no critério **Links** — sempre proponha o comando `jira issue link` correspondente, não apenas mencione que o link está faltando. Exemplo de comandos permitidos:

```bash
jira issue edit HYPERFLEET-XXX --custom story-points=3 --no-input
jira issue edit HYPERFLEET-XXX --priority Major --no-input
jira issue edit HYPERFLEET-XXX --component "sentinel" --no-input
```

Para links, use `jira issue link INWARD_ISSUE_KEY OUTWARD_ISSUE_KEY LINK_TYPE` (aliás: `jira issue ln`). Semântica confirmada empiricamente (verificado via `jira issue view --raw` após criar o link): **`INWARD_ISSUE_KEY` realiza o verbo "outward" do tipo sobre `OUTWARD_ISSUE_KEY`** — ex: tipo `Blocks` (outward="blocks", inward="is blocked by") → `jira issue link A B Blocks` cria "**A blocks B**" (equivalente a "B is blocked by A"). Tipos comuns neste Jira: `Blocks` (blocks / is blocked by), `Related` (relates to / is related to), `Duplicate` (duplicates / is duplicated by).

Cuidado: essa ordem é contra-intuitiva (o issue "blocker" vai no primeiro argumento, não o issue com a AC "is blocked by"). Depois de criar, sempre confirme a direção com:
```bash
jira issue view <KEY> --raw | jq '{links: [.fields.issuelinks[]? | {direction: (if .outwardIssue then .type.outward else .type.inward end), key: (.outwardIssue.key // .inwardIssue.key)}]}'
```
Se a direção sair errada, corrija com `jira issue unlink A B` seguido de `jira issue link` na ordem correta — nunca deixe um link invertido.

```bash
# Queremos "HYPERFLEET-1512 is blocked by HYPERFLEET-1407" → o blocker (1407) é o INWARD_ISSUE_KEY
jira issue link HYPERFLEET-1407 HYPERFLEET-1512 Blocks

# HYPERFLEET-1515 "relates to" HYPERFLEET-1393 (tipo simétrico, ordem não importa)
jira issue link HYPERFLEET-1515 HYPERFLEET-1393 Related
```
