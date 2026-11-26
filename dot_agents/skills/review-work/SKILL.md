---
name: review-work
description: Levantamento de atividade de um membro do time (GitHub + JIRA) durante uma sprint. Aceita nome, GitHub username ou parte do nome e opcionalmente o número da sprint.
argument-hint: <name-or-username> [sprint-number]
allowed-tools: Bash(gh *), Bash(jira *), Bash(date *), Bash(echo *), Bash(SPRINT_*), Bash(START_*), Bash(END_*), Bash(PAGE=*), Bash(EVENTS=*), Bash(JIRA_USER=*), Bash(MEMBERS=*), Bash(MATCH=*)
---

# Review Work

Levanta a atividade de uma pessoa no GitHub e JIRA durante uma sprint.

## Argumentos

- `$ARGUMENTS`: Primeiro token é o nome ou GitHub username da pessoa (obrigatório). Segundo token (opcional) é o número da sprint (inteiro). Se omitido, usa a sprint ativa.

Exemplos:
- `/review-work tirth` — sprint ativa, resolve para tirthct
- `/review-work tirthct 6` — sprint 6
- `/review-work leonardo` — resolve pelo nome real
- `/review-work angel` — resolve para rh-amarin

## Instruções

### 1. Parsear argumentos

Extraia do `$ARGUMENTS`:
- `INPUT`: primeiro token (nome ou GitHub username)
- `SPRINT_NUM`: segundo token (número inteiro, opcional)

Se `INPUT` estiver vazio, informe ao usuário que o nome/username é obrigatório e pare.

### 2. Resolver GitHub username

O usuário pode fornecer um GitHub username exato, um nome parcial, ou o primeiro nome da pessoa.

#### 2a. Buscar membros da org

Busque todos os membros da org via GitHub API (inclui membros que podem não estar no OWNERS de repos individuais):

```bash
gh api orgs/openshift-hyperfleet/members --jq '.[].login'
```

Filtre bots conhecidos da lista (nomes que contenham `bot`, `robot`, `cyborg`).

Se a API falhar (ex: permissão insuficiente), use o OWNERS file como fallback:

```bash
gh api repos/openshift-hyperfleet/hyperfleet-sentinel/contents/OWNERS --jq '.content' | base64 --decode
```

#### 2b. Buscar nomes reais

Para cada username da lista, busque o nome real via GitHub API:

```bash
gh api "users/<USERNAME>" --jq '.name // ""'
```

Construa uma lista de pares `username|nome_real`.

#### 2c. Fazer match

Compare o `INPUT` (case-insensitive) contra:
1. GitHub username (match exato ou parcial — ex: `tirth` casa com `tirthct`)
2. Nome real (match parcial — ex: `leonardo` casa com um nome que contenha "leonardo", `angel` casa com "Angel Marin")

**Regras de match:**
- Se match único: usar esse username automaticamente
- Se múltiplos matches: mostrar lista e pedir ao usuário para escolher
- Se nenhum match: mostrar todos os membros disponíveis e pedir ao usuário para escolher

**Exemplo de lista quando há ambiguidade:**

```text
Multiplos matches para "a":
  1. aredenba-rh (Austin Redenbaugh)
  2. rh-amarin (Angel Marin)

Qual o número do usuário desejado?
```

### 3. Obter dados da sprint

#### 3a. Descobrir sprint ativa (se SPRINT_NUM não informado)

Busque qualquer ticket na sprint ativa para extrair os dados:

```bash
jira issue list --project HYPERFLEET --jql "sprint in openSprints()" --plain --columns KEY --paginate "0:1"
```

Depois pegue os dados da sprint do ticket:

```bash
jira issue view <KEY> --raw | jq -r '.fields.customfield_10020[-1]'
```

O campo retorna um objeto JSON como:
```json
{"id": 15607, "name": "Hyperfleet Sprint 8", "state": "active", "boardId": 1013, "startDate": "2026-03-16T10:08:33.743Z", "endDate": "2026-04-06T09:00:00.000Z"}
```

Extraia `name`, `startDate` e `endDate` diretamente do objeto.

#### 3b. Buscar sprint por número (se SPRINT_NUM informado)

Use JQL com o nome da sprint:

```bash
jira issue list --project HYPERFLEET --jql "sprint = 'Hyperfleet Sprint <SPRINT_NUM>'" --plain --columns KEY --paginate "0:1"
```

Depois extraia os dados da sprint do ticket retornado, da mesma forma que em 3a. Procure no array `customfield_10020` a entrada cujo `name` contenha o número da sprint solicitado.

Se nenhum ticket for encontrado, informe ao usuário que a sprint não foi encontrada e pare.

### 4. Buscar atividade no GitHub

Use a Search API do GitHub, que funciona para qualquer sprint. Não use a Events API: ela guarda só 90 dias e 300 eventos, e perde atividade de sprints antigas ou de pessoas muito ativas.

Use `START` e `END` no formato `YYYY-MM-DD` (as 10 primeiras letras de `startDate` e `endDate`).

#### 4a. Encontrar PRs candidatas

Rode as buscas abaixo para cada escopo: `org:openshift-hyperfleet` e `repo:openshift/release`. Deduplique pelo par `repo|number`:

```bash
for q in "author:<GH_USER>" "reviewed-by:<GH_USER>" "commenter:<GH_USER>"; do
  gh api search/issues -X GET --paginate \
    -f q="type:pr $q <ESCOPO> updated:<START>..<END>" -f per_page=100 \
    --jq '.items[] | "\(.repository_url | split("/") | .[-2:] | join("/"))|\(.number)|\(.title)|\(.state)|\(.created_at)|\(.user.login)"'
done
```

A Search API aceita 30 buscas por minuto. Se receber erro de rate limit, espere e repita.

#### 4b. Datar a atividade em cada PR

Para cada PR candidata, busque as quatro fontes e mantenha só os itens do usuário dentro de `START..END`:

```bash
# Reviews formais (approve, request changes, comment)
gh api --paginate "repos/<OWNER>/<REPO>/pulls/<N>/reviews" \
  --jq '.[] | select(.user.login == "<GH_USER>") | "review|\(.submitted_at)|\(.state)"'

# Comentários inline de review
gh api --paginate "repos/<OWNER>/<REPO>/pulls/<N>/comments" \
  --jq '.[] | select(.user.login == "<GH_USER>") | "review_comment|\(.created_at)"'

# Comentários gerais (ex.: /lgtm, /retest)
gh api --paginate "repos/<OWNER>/<REPO>/issues/<N>/comments" \
  --jq '.[] | select(.user.login == "<GH_USER>") | "issue_comment|\(.created_at)"'

# Commits da pessoa na PR (data do commit, que também captura rebase e force-push)
gh api --paginate "repos/<OWNER>/<REPO>/pulls/<N>/commits" \
  --jq '.[] | select(.author.login == "<GH_USER>") | "commit|\(.commit.committer.date)|\(.sha[0:7])"'
```

Se a PR foi aberta pelo usuário (`user.login`) dentro do período, registre também "Abriu <repo>#<N>" no dia do `created_at`.

As datas vêm em UTC. Descarte PRs sem nenhum item no período: o `updated:` da busca também casa com atividade de outras pessoas.

### 5. Buscar atividade no JIRA

#### 5a. Descobrir o JIRA username

O GitHub username nem sempre é igual ao JIRA username. Tente encontrar o JIRA username buscando tickets onde o usuário é assignee ou reporter. Se não conseguir mapear automaticamente, pergunte ao usuário qual o JIRA username da pessoa.

Estratégia: busque tickets recentes do projeto e tente encontrar um match parcial com o GitHub username no campo assignee:

```bash
jira issue list --project HYPERFLEET --jql "assignee = '<GH_USER>'" --plain --columns KEY --paginate "0:1"
```

Se não encontrar, tente variantes comuns (ex: para `tirthct` tente `tirth`, `tthakkar`, etc). Se encontrar um ticket, extraia o JIRA username:

```bash
jira issue view <KEY> --raw | jq -r '.fields.assignee.name'
```

Se nenhuma variante funcionar, busque tickets recentes do projeto e compare o display name com o nome real do GitHub:

```bash
jira issue list --project HYPERFLEET --jql "updated >= '-30d'" --plain --columns KEY,ASSIGNEE --no-truncate --paginate "0:50"
```

Procure o display name que contenha parte do nome real da pessoa. Depois extraia o JIRA username do ticket encontrado.

#### 5b. Tickets com atividade

Busque tickets onde o usuário foi ativo no período da sprint:

```bash
# Tickets assigned ao usuário atualizados no período
jira issue list --project HYPERFLEET --jql "assignee = '<JIRA_USER>' AND updated >= '<START_DATE>' AND updated <= '<END_DATE>'" --plain --columns KEY,SUMMARY,STATUS,UPDATED --no-truncate

# Tickets onde o usuário fez transições de status
jira issue list --project HYPERFLEET --jql "status changed by <JIRA_USER> AFTER '<START_DATE>'" --plain --columns KEY,SUMMARY,STATUS --no-truncate

# Tickets criados pelo usuário no período
jira issue list --project HYPERFLEET --jql "reporter = '<JIRA_USER>' AND created >= '<START_DATE>'" --plain --columns KEY,SUMMARY,STATUS --no-truncate
```

Combine e deduplique os resultados.

#### 5c. Detalhes dos tickets

Para cada ticket encontrado, busque os detalhes para entender a atividade:

```bash
jira issue view <KEY> --raw | jq '{key: .key, summary: .fields.summary, status: .fields.status.name, assignee: (.fields.assignee.displayName // "Unassigned"), storyPoints: (.fields.customfield_10028 // null), type: .fields.issuetype.name}'
```

### 6. Consolidar e apresentar

#### 6a. Agregar por dia

Agrupe toda a atividade (GitHub + JIRA) por dia. Para cada dia no período da sprint:

- Conte commits (fonte `commit`)
- Conte reviews (`review`) e comentários (`review_comment` + `issue_comment`)
- Liste PRs envolvidas (com link)
- Liste outras atividades (aberturas de PR, approves)

#### 6b. Formato de saida

Use markdown tables (pipes `|`) para que links sejam renderizados como clicáveis. NÃO use code blocks (` ``` `) ao redor das tabelas — markdown links não renderizam dentro de code blocks.

Sprint: Hyperfleet Sprint N (DD MMM - DD MMM YYYY)
GitHub: <GH_USER> (<REAL_NAME>) | JIRA: <JIRA_USER>

| Data | Dia | Commits | Reviews | Comentários | PRs | Outras atividades |
|------|-----|---------|---------|-------------|-----|-------------------|
| 23 Feb | Mon | 2 | 1 | 5 | [sentinel#51](https://github.com/openshift-hyperfleet/hyperfleet-sentinel/pull/51) | Approve em sentinel#51 |
| 24 Feb | Tue | — | — | — | — | — |
| 25 Feb | Wed | 3 | — | 4 | [sentinel#52](https://github.com/openshift-hyperfleet/hyperfleet-sentinel/pull/52) | Abriu sentinel#52 |

**Regras da tabela:**
- Incluir TODOS os dias do período da sprint, mesmo os sem atividade
- Dias sem atividade: usar `—` nas colunas
- Fins de semana sem atividade: agrupar (ex: "01-02 Mar" / "Sat-Sun")
- Fins de semana COM atividade: mostrar individualmente
- PRs com link: usar formato `[repo#N](https://github.com/<org>/repo/pull/N)`
- Commits, Reviews e Comentários: mostrar contagem numérica
- Coluna "Outras atividades": aberturas de PRs, approves e pedidos de mudança

#### 6c. Resumo JIRA

Após a tabela, mostrar uma seção de atividade JIRA usando markdown table (sem code block):

### JIRA Activity

| Ticket | Type | Summary | Status | SP |
|--------|------|---------|--------|----|
| [HYPERFLEET-542](https://redhat.atlassian.net/browse/HYPERFLEET-542) | Story | Add OTel instrumentation to Sentinel | In Progress | 5 |
| [HYPERFLEET-557](https://redhat.atlassian.net/browse/HYPERFLEET-557) | Task | Update architecture docs | Review | 3 |

#### 6d. Resumo final

Encerre com um parágrafo curto resumindo:
- Total de dias com atividade vs dias úteis na sprint
- Total de commits, reviews, comentários e PRs trabalhadas
- Foco principal do trabalho (qual PR/ticket recebeu mais atenção)
- Tickets JIRA movimentados

## Regras

- Use `gh` CLI para GitHub e `jira` CLI para JIRA
- Análise em português
- Dias da semana em inglês (Mon, Tue, Wed, Thu, Fri, Sat, Sun)
- Meses em inglês (Jan, Feb, Mar, etc)
- Se o GitHub limitar as buscas (rate limit) e algum dado ficar de fora, avise o usuário
- Commits só aparecem quando estão em PRs; pushes em branches sem PR não são contados
- Se não conseguir mapear o JIRA username, pergunte ao usuário
- Links de PRs: usar formato `[repo#N](https://github.com/<org>/repo/pull/N)` — texto curto com URL completa para terminais que suportam links markdown
- Links de tickets JIRA: usar formato `[HYPERFLEET-XXX](https://redhat.atlassian.net/browse/HYPERFLEET-XXX)`
- A org padrão para PRs é `openshift-hyperfleet`, exceto quando o repo.name retornado pela API indicar outra org (ex: `openshift/release`)
