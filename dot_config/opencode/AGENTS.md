# Preferências globais

## Commits e PRs

- Nunca inclua atribuição de ferramenta/IA (ex.: "Generated with ...") em arquivos ou commits.
- Nunca use `Co-Authored-By` nos commits.
- Sempre use commits assinados.
- Sempre coloque o id do ticket nos commits e no título das PRs, quando existir um ticket.
- Nunca use `HYPERFLEET-XXXX` no título de tickets.
- Mantenha 1 commit por PR: faça squash dos existentes ou `--amend` quando houver apenas um.

## Markdown

- Em arquivos Markdown (`*.md`), sempre use fenced code block com language identifier.
- Em arquivos Markdown (`*.md`), nunca use pseudo-headings em bold (`**Título**`); use headings adequados (`###`).
- Sempre feche os code blocks.
- Verifique os arquivos Markdown para evitar MD040 (fenced code blocks sem linguagem).

## Fluxo de trabalho

- Se uma instrução não estiver clara ou houver pontos de escolha, pergunte antes de assumir algo (ex.: nome do pacote no `go.mod`, banco de dados a usar).
- Para Jira, use sempre o Jira CLI; para GitHub, use sempre o GitHub CLI.
- Ao testar código, verifique também se há testes de integração e e2e a executar.
- Ao revisar um comentário de PR: ao final da correção, faça commit e push e responda o comentário **dentro da thread** com `gh api repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies`. Nunca use `gh pr comment` para responder review comments.
- Quando eu colar um comentário, responda-o logo abaixo.
- Deixe textos puros para copiar e colar, sem caracteres de moldura (ex.: `▎`) em cada linha.

## Documentos de arquitetura (ADR vs DDR vs spike)

Teste de uma linha:

- **ADR** responde *o que decidimos e por quê*.
- **DDR** (design doc: `docs/*-design.md` e component design) responde *como funciona*.
- **Spike** (`docs/spike-*.md`) registra *evidência*.
- Se o leitor precisa do documento para implementar, é DDR. Se precisa dele em dois anos para entender por que o código é assim, é ADR. Um documento que tenta ser os dois não é lido por ninguém.

Regras por tipo:

- **ADR:** seções `Context`, `Decision`, `Consequences`, `Alternatives Considered`. Sem código, SQL ou config; sem procedimentos, runbooks ou tabelas de thresholds (aponte onde vivem). Diagramas raros. **Não é editado — é superseded por um novo ADR.**
- **DDR:** Problem/What & Why, How (com diagrama), Trade-offs, Alternatives. Pode conter código, SQL, config e diagramas.
- **Spike:** produz evidência; o ADR registra a decisão; o DDR desenha o como. Nenhum absorve o outro.

Antes de abrir um PR de ADR — qualquer item abaixo indica que o rascunho carrega conteúdo de design:

- Mais de ~1.200 palavras.
- Mais de três headings sob `Decision`.
- Code block com mais de três linhas.
- Tabela de thresholds, limites ou passos.
- Termos "procedure", "step 1", "the operator must implement", "algorithm".
- Alguma seção que leia como runbook.

Checagens positivas:

- `Context` é um parágrafo e enuncia o problema, não a história.
- Cada frase de `Decision` compromete-se com algo (um leitor poderia discordar).
- `Alternatives` é uma tabela e cada linha rejeitada tem uma razão.
- Todo item adiado nomeia o ticket ou documento dono.
- O documento inteiro é lido em menos de cinco minutos.

Comments em ADR:

- Um comentário de review em um ADR é respondido com (a) uma decisão, (b) um ponteiro para onde o detalhe vive, ou (c) uma nota de que está fora de escopo, com o ticket que o possui — **nunca** com um procedimento.
- Se o comentário só se resolve adicionando detalhe de implementação, ele pertence ao DDR: peça o DDR ou peça o ticket que vai produzi-lo.

## Referências de tickets

When a document references a ticket, link it to Jira (`https://redhat.atlassian.net/browse/<TICKET>`) wherever the document format allows — for example the `**Jira**:`/`**Related**:` header lines in ADRs and design docs, or inline when a ticket owns deferred work. Do not leave a bare `HYPERFLEET-XXXX` identifier where a link is possible.
