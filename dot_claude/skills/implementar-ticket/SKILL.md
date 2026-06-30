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

Use a skill `hyperfleet-architecture:hyperfleet-architecture`:
- Busque padrões e convenções relevantes para o tipo de implementação
- Verifique se há standards específicos mencionados no ticket (ex: graceful-shutdown.md, health-endpoints.md, metrics.md)

### 5. Criar branch

- Execute `/atualiza-main` para atualizar a branch main
- Fork the organisation repo if not already forked: `gh repo fork openshift-hyperfleet/<REPO> --clone=false 2>/dev/null`
- Crie a branch a partir de `main` usando a convenção: `HYPERFLEET-XXX-brief-description`

```bash
git checkout -b <TICKET_ID>-brief-description
```

### 6. Planejar implementação

Analise o ticket e crie um plano de implementação usando TodoWrite.

### 7. Aguardar confirmação

Apresente o plano e use AskUserQuestion para perguntar se pode prosseguir.

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

### 13. Executar lint

```bash
make lint
```

Corrija erros de lint antes de prosseguir.

### 14. Verificar documentações

- Verifique se as mudanças impactam documentações existentes (README.md, docs/, etc.)
- Se APIs foram adicionadas/modificadas, atualize a documentação de API
- Se configurações ou variáveis de ambiente mudaram, atualize a documentação relevante
- Use a skill `hyperfleet-devtools:architecture-impact` para identificar quais documentos de arquitetura precisam de atualização

### 15. Auto-revisão

Aplique a auto-revisão completa sobre todo o código implementado/modificado nesta sessão. Veja os detalhes em [auto-review.md](auto-review.md).

### 16. Finalização

**IMPORTANTE: NÃO fazer commit** — deixar as mudanças staged ou unstaged para que o autor revise antes de commitar.

Informe ao usuário:
- O que foi implementado
- Quais arquivos foram modificados/criados
- Quais testes de unidade foram criados/modificados
- Quais testes de integração foram criados/modificados
- Quais documentações foram atualizadas
- Resultado da auto-revisão (passo 15): quantos problemas foram encontrados e corrigidos em cada pass
- Que as mudanças estão prontas para revisão (sem commit)

### 17. Abrir VS Code

```bash
code .
```
