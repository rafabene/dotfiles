---
name: oq-fiz-ontem
description: O que fiz ontem - Resumo das atividades do dia anterior baseado em Git e Jira
---

# O que fiz ontem

Resumo das atividades do dia anterior baseado em Git e Jira, separado por organização.

## Organizações e repositórios

| Org | Diretórios |
|-----|------------|
| **AvantPro** | `~/projetos/avantpro/*` |
| **HyperFleet (Red Hat)** | `~/projetos/hyperfleet/*` |

## Instruções

### 0. Determinar a data de referência

Antes de buscar qualquer dado, determine o dia útil anterior:

```bash
date +%u
```

- Se hoje é **segunda (1)**, **sábado (6)** ou **domingo (7)**: o "ontem" é **sexta-feira**
- Nos demais dias: use o dia anterior normalmente

Use `date -v-Nd "+%Y-%m-%d"` (macOS) para calcular a data correta, onde N é o número de dias a voltar: 1 nos dias normais, 3 na segunda, 1 no sábado e 2 no domingo.

### 1. Atualizar referências remotas (fetch)

Antes de buscar commits, faça `git fetch --all` em todos os repositórios para garantir que commits que existem apenas no remote sejam incluídos:

```bash
for dir in ~/projetos/avantpro/*/; do
  if [ -d "$dir/.git" ]; then
    git -C "$dir" fetch --all -q 2>/dev/null
  fi
done
```

Repita para HyperFleet:

```bash
for dir in $(find ~/projetos/hyperfleet -mindepth 1 -maxdepth 1 -type d 2>/dev/null); do
  if [ -d "$dir/.git" ]; then
    git -C "$dir" fetch --all -q 2>/dev/null
  fi
done
```

### 2. Buscar commits no Git por organização

Para cada organização, itere nos repositórios e busque commits do dia de referência:

```bash
for dir in ~/projetos/avantpro/*/; do
  if [ -d "$dir/.git" ]; then
    commits=$(git -C "$dir" log --all --author="$(git config user.name)" --since="YYYY-MM-DD 00:00" --until="YYYY-MM-DD 23:59:59" --oneline --format="%h %s (%ai)" 2>/dev/null)
    if [ -n "$commits" ]; then
      echo "=== $(basename $dir) ==="
      echo "$commits"
    fi
  fi
done
```

Repita para HyperFleet:

```bash
for dir in $(find ~/projetos/hyperfleet -mindepth 1 -maxdepth 1 -type d 2>/dev/null); do
  if [ -d "$dir/.git" ]; then
    commits=$(git -C "$dir" log --all --author="$(git config user.name)" --since="YYYY-MM-DD 00:00" --until="YYYY-MM-DD 23:59:59" --oneline --format="%h %s (%ai)" 2>/dev/null)
    if [ -n "$commits" ]; then
      echo "=== $(basename $dir) ==="
      echo "$commits"
    fi
  fi
done
```

Substitua `YYYY-MM-DD` pela data de referência nos dois parâmetros e mantenha os horários: sem eles, o git usa a hora atual e `--since` igual a `--until` não retorna nada.

**Nota importante:** Esta busca captura novos commits feitos no dia de referência. Para capturar **força-push e rebase** (commits força-empurrados para o remote), veja a **seção 4b** abaixo.

### 3. Buscar atividade no Jira

Execute **dois** comandos para cobrir tanto tickets atualizados quanto tickets criados por mim:

```bash
# Tickets onde sou assignee e foram atualizados
jira issue list --assignee="$(jira me)" --updated "YYYY-MM-DD" --plain --columns "KEY,SUMMARY,STATUS,TYPE"

# Tickets que eu criei (reporter) no dia
jira issue list --reporter="$(jira me)" --created "YYYY-MM-DD" --plain --columns "KEY,SUMMARY,STATUS,TYPE"
```

Substitua `YYYY-MM-DD` pela data de referência calculada.

Combine os resultados removendo duplicatas (mesmo KEY). **Exclua tickets do tipo Epic e Feature** — eles não representam trabalho direto feito no dia. Se ambos os comandos falharem ou não retornarem resultados, informe que não houve atividade no Jira.

#### 3b. Verificar data de resolução para tickets Closed/Done

A query `--updated` retorna tickets que tiveram **qualquer** atualização no dia (comentário, link, transição automática), não necessariamente trabalho real. Para tickets com status Closed/Done, verifique se foram realmente resolvidos no dia de referência:

```bash
jira issue view TICKET-KEY --raw 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('fields',{}).get('resolutiondate','N/A'))"
```

- Se a data de resolução começa com o dia de referência (ex: `2026-06-01T...`) → use "Completed"
- Se a data de resolução é **anterior** ao dia de referência → **exclua o ticket** do standup (não houve trabalho real nesse dia, apenas um update automático)
- Se o ticket está In Progress ou In Review → use "Worked on" normalmente, sem verificação adicional
- Se o ticket está em qualquer outro status (Backlog, New, etc.) → **exclua o ticket** do standup (a atualização foi provavelmente automática ou administrativa, não trabalho real)

### 4. Buscar PRs revisadas no HyperFleet

Busque pull requests da organização `openshift-hyperfleet` que eu revisei no dia de referência.

**Importante:** O qualificador `reviewed:` do GitHub search não é preciso. Use a abordagem em dois passos abaixo para garantir que apenas PRs realmente revisadas no dia de referência sejam incluídas.

**Passo 1:** Obtenha candidatas com **duas** buscas (reviewed-by e commenter) para capturar tanto reviews formais quanto comentários como `/lgtm`, `/retest`, etc. Deduplicar pelo par repo|number:

```bash
# Busca 1: reviews formais
gh api search/issues -X GET \
  -f q="type:pr reviewed-by:@me org:openshift-hyperfleet updated:>=YYYY-MM-DD" \
  -f per_page=50 \
  --jq '.items[] | "\(.repository_url | split("/") | .[-1])|\(.number)|\(.title)|\(.state)"'

# Busca 2: PRs onde comentei (pega /lgtm, /retest, etc.)
gh api search/issues -X GET \
  -f q="type:pr commenter:@me org:openshift-hyperfleet updated:>=YYYY-MM-DD" \
  -f per_page=50 \
  --jq '.items[] | "\(.repository_url | split("/") | .[-1])|\(.number)|\(.title)|\(.state)"'
```

Combine os resultados das duas buscas e remova duplicatas (mesmo `repo|number`).

**Passo 2:** Para cada candidata, verifique a data real da interação via **três** APIs do GitHub. Uma PR conta como "revisada" se houver atividade em **qualquer** uma delas no dia de referência:

```bash
GH_USER=$(gh api user --jq '.login')
# Para cada repo/number da lista anterior, verificar 3 fontes:

# 1. Formal reviews (approve, request changes, comment via review)
gh api "repos/openshift-hyperfleet/{repo}/pulls/{number}/reviews" \
  --jq "[.[] | select(.user.login == \"$GH_USER\" and (.submitted_at | startswith(\"YYYY-MM-DD\")))] | length"

# 2. Review comments (comentários inline no código)
gh api "repos/openshift-hyperfleet/{repo}/pulls/{number}/comments" \
  --jq "[.[] | select(.user.login == \"$GH_USER\" and (.created_at | startswith(\"YYYY-MM-DD\")))] | length"

# 3. Issue comments (comentários gerais na PR, ex: /lgtm, /retest)
gh api "repos/openshift-hyperfleet/{repo}/issues/{number}/comments" \
  --jq "[.[] | select(.user.login == \"$GH_USER\" and (.created_at | startswith(\"YYYY-MM-DD\")))] | length"
```

Inclua no resultado apenas as PRs que tiverem **soma > 0** nas três fontes acima.

#### 4b. Capturar commits força-empurrados nas PRs abertas

Rebases e força-push não são detectados por simples busca de commits no Git. Para capturar PRs onde você força-empurrou (rebase/squash) no dia de referência, verifique a data de commit (`commit.committer.date`, não a de autoria) dos commits das suas PRs abertas na organização `openshift-hyperfleet`:

```bash
DAY="YYYY-MM-DD"

gh api search/issues -X GET \
  -f q="type:pr author:@me org:openshift-hyperfleet state:open" \
  -f per_page=50 \
  --jq '.items[] | "\(.repository_url | split("/") | .[-1]) \(.number)"' |
while read -r repo number; do
  gh api --paginate "repos/openshift-hyperfleet/$repo/pulls/$number/commits" \
    --jq ".[] | select(.commit.committer.date | startswith(\"$DAY\")) | \"$repo#$number \(.sha[0:7]) \(.commit.committer.date)\""
done
```

A data vem em UTC: um commit feito à noite no horário local pode aparecer no dia seguinte.

Essa verificação captura **força-push e rebase** que aconteceram no dia de referência, mesmo que o commit original seja mais antigo. Combine com os resultados da seção 4 (reviews) para ter a lista completa de PRs com atividade no dia.

### 5. Meetings

Meetings não podem ser obtidas automaticamente de forma confiável (AppleScript/icalBuddy são lentos demais com calendários Exchange/Google). Use `X` como placeholder em ambas as seções para preenchimento manual.

### 6. Planejar o dia

#### 6a. Tickets atribuídos a mim (In Progress, Backlog, New)

Busque tickets do Jira que estão atribuídos a mim nos status relevantes:

```bash
jira issue list --assignee="$(jira me)" --status "In Progress" --plain --columns "KEY,SUMMARY,TYPE" --no-headers
jira issue list --assignee="$(jira me)" --status "Backlog" --plain --columns "KEY,SUMMARY,TYPE" --no-headers
jira issue list --assignee="$(jira me)" --status "New" --plain --columns "KEY,SUMMARY,TYPE" --no-headers
```

Combine os resultados removendo duplicatas. **Exclua tickets do tipo Epic e Feature** — eles não representam trabalho direto do dia. Priorize na seguinte ordem: In Progress primeiro, depois Backlog, depois New.

#### 6b. Minhas PRs abertas no HyperFleet

Busque PRs abertas de minha autoria na organização `openshift-hyperfleet`:

```bash
gh api search/issues -X GET \
  -f q="type:pr author:@me org:openshift-hyperfleet state:open" \
  -f per_page=50 \
  --jq '.items[] | "\(.repository_url | split("/") | .[-1])#\(.number) - \(.title)"'
```

### 7. Formato de saída

A saída deve ser **texto puro** (sem markdown) pronto para colar no Slack. A resposta deve estar em **inglês**.

Informe qual data de referência foi usada como comentário antes do standup (ex: "Atividades de terça-feira, 26/05/2026").

#### Entrega via clipboard (pbcopy)

Entregue o standup direto na área de transferência — não confie em bloco de código markdown na resposta, pois o TUI renderiza blocos de código com padding à esquerda e a cópia pelo terminal arrasta esses espaços junto:

```bash
# 1. Escreva o standup (texto puro, sem markdown) em "$TMPDIR/opencode/standup-YYYY-MM-DD.txt"
mkdir -p "$TMPDIR/opencode"

# 2. Coloque na área de transferência
pbcopy < "$TMPDIR/opencode/standup-YYYY-MM-DD.txt"
```

Na resposta, siga o formato desta seção: comentário da data de referência, o standup completo em bloco de código cercado (` ```text `) e a análise em português. O bloco serve apenas para conferência visual — a fonte da colagem é sempre o clipboard (Cmd+V), nunca a seleção do texto renderizado no TUI (que quebra linhas longas e arrasta padding). Sempre avise que o standup já está no clipboard e informe o caminho do arquivo salvo.

O formato é:

```text
What did you accomplish yesterday?
X meetings
Completed TICKET-123 - Summary do ticket
Worked on TICKET-456 - Summary do ticket
N PR Reviews (repo#number, repo#number)

What will you do today?
X meetings
PR Reviews
Work on TICKET-123 - Summary, TICKET-456 - Summary
Handle PR comments of repo#number, repo#number

Are there any impediments or blockers?
No
```

#### Regras do formato

- **Texto puro**: Sem markdown (`**`, `-`, `#`, etc.). Cada item numa linha separada sem bullet points
- **Meetings (yesterday)**: Mostrar `X meetings` como placeholder para preenchimento manual. Sempre a primeira linha do "yesterday"
- Use "Completed" para tickets com status Closed/Done
- Use "Worked on" apenas para tickets com status In Progress ou In Review. Tickets em outros status (Backlog, New, etc.) devem ser excluídos do "yesterday"
- **Excluir Epics e Features**: Nunca inclua tickets do tipo Epic ou Feature no standup (nem em "yesterday" nem em "today"). São containers de trabalho, não trabalho direto
- Agrupe commits e tickets por TICKET-ID. Se um commit referencia um ticket que também aparece no Jira, combine numa única linha
- Para PR Reviews, liste todas numa única linha com os repos e números entre parênteses
- Se não houver PRs revisadas no "yesterday", omita a linha de PR Reviews no "yesterday"
- Se uma organização (AvantPro) tiver atividade, agrupe os itens sob um sub-heading com o nome da org em texto puro (ex: "AvantPro:" e "HyperFleet (Red Hat):") dentro da seção "What did you accomplish yesterday?"
- Se apenas uma organização tiver atividade, não use sub-headings
- **Blockers**: Mostrar "No" como placeholder para preenchimento manual
- **Linha em branco** entre cada seção (após o último item de cada seção)

#### Regras para "What will you do today?"

- **Meetings**: Mostrar `X meetings` como placeholder para preenchimento manual
- **PR Reviews**: Sempre incluir a linha `PR Reviews` (é uma atividade recorrente)
- **Work on**: Listar os tickets (KEY - Summary) agrupados numa única linha separados por vírgula. Mostrar apenas tickets In Progress e Backlog. Omitir tickets com status New. Se não houver tickets, omitir a linha
- **Handle PR comments of**: Listar as minhas PRs abertas no formato `repo#number` separadas por vírgula. Se não houver PRs abertas, omitir a linha

## Regras

- Use o jira CLI e git CLI para todas as operações
- Análise em português
- Seja conciso e objetivo
- Agrupe commits relacionados ao mesmo ticket/tema
- Destaque o que foi mais relevante
- Sempre separe atividades por organização
