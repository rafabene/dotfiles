---
name: implementar-ticket
description: Implementa um ticket do JIRA em uma branch dedicada, seguindo os padrões de arquitetura do HyperFleet, com auto-revisão completa.
disable-model-invocation: true
argument-hint: <HYPERFLEET-XXX ou URL do ticket>
---

# Implementar Ticket

Implementa um ticket do JIRA em uma branch dedicada, seguindo os padrões de arquitetura do HyperFleet.

## Parâmetros

- `$ARGUMENTS`: URL do ticket (ex: https://redhat.atlassian.net/browse/HYPERFLEET-123) ou código do ticket (ex: HYPERFLEET-123)

## Instruções

### 1. Extrair o código do ticket

Extraia o código do argumento fornecido (URL ou código direto).

### 2. Buscar informações do ticket

```bash
jira issue view <TICKET_ID>
```

### 3. Verificar se o ticket está bloqueado

Na saída do `jira issue view`, procure pela seção "Linked Issues" por links do tipo "IS BLOCKED BY". Se existir algum ticket bloqueador que **não** esteja nos status "Done", "Closed" ou "Resolved":

- Verifique o status do bloqueador: `jira issue view <BLOCKER_TICKET_ID>`
- Informe ao usuário quais tickets estão bloqueando e o status de cada um
- **Pare a execução** — não prossiga com os passos seguintes

### 4. Consultar documentos de arquitetura

Se a skill `hyperfleet-architecture` estiver disponível, use-a para:
- Buscar padrões e convenções relevantes para o tipo de implementação
- Verificar se há standards específicos mencionados no ticket (ex: graceful-shutdown.md, health-endpoints.md, metrics.md)

Se a skill não estiver disponível, consulte o repositório `openshift-hyperfleet/architecture` diretamente.

### 5. Criar branch

Siga a seção "Repositórios" do AGENTS.md global:

- Use o clone existente em `~/projetos/hyperfleet/<REPO>`. Só clone se ele não existir:

```bash
gh repo clone openshift-hyperfleet/<REPO> ~/projetos/hyperfleet/<REPO>
```

- Garanta o remote `fork` apontando para o seu fork (cria o fork se não existir):

```bash
cd ~/projetos/hyperfleet/<REPO>
git remote get-url fork 2>/dev/null || gh repo fork --remote --remote-name fork
```

- Se `git status --porcelain` não estiver vazio ou a branch atual tiver commits não enviados, **pare** e pergunte ao usuário antes de trocar de branch.
- Crie a branch a partir de `origin/main`, com a convenção `HYPERFLEET-XXX-brief-description`:

```bash
git fetch origin
git switch -c <TICKET_ID>-brief-description origin/main
```

Execute os passos seguintes dentro de `~/projetos/hyperfleet/<REPO>`.

### 6. Planejar implementação

Analise o ticket e crie um plano de implementação como lista de tarefas, com a ferramenta de tarefas do agente, se houver.

### 7. Aguardar confirmação

Apresente o plano e pergunte ao usuário se pode prosseguir.

### 8. Implementar as mudanças

Siga o plano e os padrões de arquitetura do HyperFleet.

### 9. Testes de unidade

- Verifique se existem testes para o código implementado/modificado
- Se não existirem, implemente-os seguindo os padrões do projeto
- Os testes devem cobrir cenários principais e casos de erro

### 10. Testes de integração

- Verifique os testes existentes em `test/integration/`
- Se as mudanças afetam fluxos cobertos por testes de integração, atualize-os
- Se introduzem novos fluxos, crie novos testes seguindo os padrões existentes

### 11. Executar testes

```bash
make test
```

Se houver testes falhando, corrija-os antes de prosseguir.

### 12. Executar testes de integração

```bash
make integration-test
```

Se o target não existir no Makefile, verifique como os testes de integração são executados no projeto.

Verifique também se há testes e2e relacionados às mudanças (por exemplo, `test/e2e/` ou um target `make e2e*`). Se puderem rodar localmente, execute-os. Se dependerem de um cluster ou de infraestrutura indisponível, informe ao usuário quais testes ficaram sem rodar.

### 13. Executar lint

```bash
make lint
```

Corrija erros de lint antes de prosseguir.

### 14. Verificar documentações

- Verifique se as mudanças impactam documentações existentes (README.md, docs/, etc.)
- Se APIs foram adicionadas/modificadas, atualize a documentação de API
- Se configurações ou variáveis de ambiente mudaram, atualize a documentação relevante
- Identifique quais documentos de arquitetura precisam de atualização (se alguma, consulte o repositório `openshift-hyperfleet/architecture`)

### 15. Auto-revisão

Leia [auto-review.md](auto-review.md) e execute todas as seções sobre o código implementado/modificado nesta sessão. Além disso:
- Verifique lógica e clareza do código
- Procure por edge cases não tratados
- Verifique nomes de variáveis e funções (convenções do projeto)
- Verifique error handling
- Verifique tipos e null checks (se linguagem tipada)
- Verifique se há prints ou logs de debug não removidos
- Verifique se há código duplicado que poderia ser extraído

### 16. Finalização

**IMPORTANTE: NÃO fazer commit** — deixar as mudanças staged ou unstaged para que o autor revise antes de commitar.

Informe ao usuário:
- O que foi implementado
- Quais arquivos foram modificados/criados
- Quais testes de unidade foram criados/modificados
- Quais testes de integração foram criados/modificados
- Quais documentações foram atualizadas
- Resultado da auto-revisão (passo 15): quantos problemas foram encontrados e corrigidos em cada pass
- Quais testes (integração ou e2e) não puderam ser executados, se houver
- Que as mudanças estão prontas para revisão (sem commit)

### 17. Abrir VS Code

```bash
code ~/projetos/hyperfleet/<REPO>
```

### 18. Push e PR (só depois do commit)

Não faça push nem abra a PR por conta própria. Só depois que o usuário commitar e pedir:

```bash
git push -u fork HEAD
gh pr create --repo openshift-hyperfleet/<REPO> --head rafabene:<BRANCH>
```

O título da PR leva a chave do ticket (ex.: `HYPERFLEET-123: ...`).
