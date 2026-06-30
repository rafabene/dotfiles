---
name: verifica-tickets
description: Analisa tickets criados recentemente no projeto HYPERFLEET e verifica a qualidade de cada um. Use quando precisar verificar qualidade de tickets, higiene de backlog, ou validar tickets antes de sprint planning.
disable-model-invocation: true
argument-hint: [período, ex: -2d, -1w]
allowed-tools: Bash(date *), Bash(jira *), Skill(hyperfleet-jira:jira-story-pointer *)
---

# Verifica Tickets

Analisa tickets criados recentemente no projeto HYPERFLEET e verifica a qualidade de cada um.

## Argumentos

- `$ARGUMENTS`: Período de busca (opcional). Padrão: `-1d` (último dia). Exemplos: `-2d`, `-1w`

## Instruções

### 0. Determinar o período de busca

Se `$ARGUMENTS` foi fornecido, use-o diretamente.

Se `$ARGUMENTS` estiver vazio, determine o período padrão baseado no dia da semana:

```bash
date +%u
```

- Se hoje é **segunda (1)**: use `-3d` (cobre sexta, sábado e domingo)
- Se hoje é **domingo (7)**: use `-2d` (cobre sexta e sábado)
- Se hoje é **sábado (6)**: use `-1d` (cobre sexta)
- Nos demais dias: use `-1d`

### 1. Buscar tickets recentes

Execute o comando para buscar tickets criados no período que não estejam Closed ou Resolved:

```bash
jira issue list --project HYPERFLEET --jql "created >= <PERIODO> AND status NOT IN (Closed, Resolved)" --order-by created --reverse
```

Substitua `<PERIODO>` pelo valor de `$ARGUMENTS` ou pelo valor calculado no passo 0.

### 2. Para cada ticket encontrado, buscar detalhes

Para cada ticket, execute:

```bash
jira issue view <TICKET> --raw | jq '{
  key: .key,
  type: .fields.issuetype.name,
  created: .fields.created,
  summary: .fields.summary,
  summaryLength: (.fields.summary | length),
  description: .fields.description,
  descriptionLength: (.fields.description | length),
  priority: .fields.priority.name,
  status: .fields.status.name,
  assignee: (.fields.assignee.displayName // "Unassigned"),
  epic: (.fields.customfield_10014 // .fields.parent.key // null),
  storyPoints: (.fields.customfield_10028 // null),
  fixVersion: (.fields.fixVersions[0].name // null),
  components: [.fields.components[]?.name],
  activityType: (.fields.customfield_10464.value // "Uncategorized"),
  sprint: (.fields.customfield_10020 | if . and length > 0 then .[-1].name else null end),
  links: [.fields.issuelinks[]? | {type: .type.name, key: (.inwardIssue.key // .outwardIssue.key)}]
}'
```

### 3. Verificar duplicados

Para cada ticket, buscar possíveis duplicados baseado em palavras-chave do summary.

### 4. Analisar cada ticket

Para cada ticket, aplique os critérios de análise definidos em [criteria.md](criteria.md). Para a verificação de Epic, siga as regras em [epics.md](epics.md) — que usa a mesma lógica do `/atribui-epics` (match por acceptance criteria, não por tema).

### 5. Formato de saída

Use os templates definidos em [output-template.md](output-template.md) para:
- Análise individual de cada ticket
- Resumo executivo
- Flags para Tech Leads
- Sugestão de correções automáticas

## Regras

- Use o jira CLI para todas as operações
- Mostre URLs completas dos tickets (https://redhat.atlassian.net/browse/HYPERFLEET-XXX)
- Análise em português
- Seja objetivo nas recomendações
