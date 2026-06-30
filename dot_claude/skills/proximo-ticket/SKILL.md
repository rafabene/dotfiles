---
name: proximo-ticket
description: Mostra tickets disponiveis no backlog da sprint atual que nao estao atribuidos a ninguem e nem bloqueados. Use quando o usuario quer saber qual o proximo ticket para trabalhar.
disable-model-invocation: true
allowed-tools: Bash(jira *)
---

# Proximo Ticket

Busca tickets disponiveis para trabalho na sprint atual: sem assignee e sem bloqueios.

## Instrucoes

### 1. Obter sprint ativa

```bash
jira sprint list --current -p HYPERFLEET --plain 2>/dev/null
```

### 2. Buscar tickets nao atribuidos na sprint ativa

```bash
jira issue list -q"project = HYPERFLEET AND sprint in openSprints() AND assignee is EMPTY AND status != Done AND status != Closed" --plain --columns KEY,SUMMARY,STATUS,PRIORITY,TYPE --no-truncate 2>/dev/null
```

### 3. Verificar bloqueios

Para cada ticket encontrado no passo 2, verifique se ha links de bloqueio:

```bash
jira issue view <KEY> --raw 2>/dev/null | jq -r '
  .fields.issuelinks[]? |
  select(.type.name == "Blocks" and .inwardIssue != null) |
  "blocked by " + .inwardIssue.key + " (" + .inwardIssue.fields.status.name + ")"
'
```

Um ticket esta bloqueado se existir um link do tipo "Blocks" com `inwardIssue` (ou seja, outro ticket bloqueia este) cujo status NAO seja "Done" ou "Closed".

Tambem verifique se ha flag de impedimento:

```bash
jira issue view <KEY> --raw 2>/dev/null | jq -r '.fields.customfield_10017 // empty'
```

Se `customfield_10017` (flagged) tiver valor, o ticket esta com impedimento.

### 4. Ordenar por prioridade

Ordene os tickets disponiveis (nao bloqueados) pela prioridade JIRA:

1. Highest
2. High
3. Medium
4. Low
5. Lowest

Dentro da mesma prioridade, ordene por tipo: Bug > Story > Task > Sub-task > outros.

### 5. Apresentar resultado

#### Formato de saida

Se houver tickets disponiveis:

### Sprint: [Nome da Sprint]

**X ticket(s) disponivel(is) para trabalho:**

| # | Ticket | Tipo | Prioridade | Status | Resumo |
|---|--------|------|------------|--------|--------|
| 1 | [HYPERFLEET-XXX](https://redhat.atlassian.net/browse/HYPERFLEET-XXX) | Story | High | To Do | Descricao do ticket |
| 2 | [HYPERFLEET-YYY](https://redhat.atlassian.net/browse/HYPERFLEET-YYY) | Bug | Medium | To Do | Outro ticket |

Se houver tickets bloqueados que foram excluidos, mencione-os brevemente:

**Tickets bloqueados (excluidos da lista):**
- HYPERFLEET-ZZZ — bloqueado por HYPERFLEET-AAA (In Progress)

Se nao houver nenhum ticket disponivel:

> Nenhum ticket disponivel na sprint atual. Todos os tickets estao atribuidos ou bloqueados.

## Regras

- Use `jira` CLI para todas as consultas
- Resposta em portugues
- Links de tickets: formato `[HYPERFLEET-XXX](https://redhat.atlassian.net/browse/HYPERFLEET-XXX)`
- NAO use code blocks ao redor das tabelas markdown
- Nao inclua tickets com status Done ou Closed
- Se `jira` CLI nao estiver configurado, informe o usuario
