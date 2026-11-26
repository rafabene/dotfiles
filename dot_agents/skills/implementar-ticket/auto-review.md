# Auto-revisão

Análise de impacto e consistência aplicada sobre todo o código implementado/modificado na sessão. Cada seção DEVE ser executada — não pule nenhuma porque "parece ok".

## a. Impact analysis

Para cada struct, campo de config ou assinatura de função modificada, busque no codebase por callers que possam precisar de atualização.

Verifique se algum arquivo **deveria ter sido modificado mas não foi** (ex: um Helm template que renderiza um campo cujo tipo mudou).

Se encontrar impactos não tratados, corrija-os.

## b. Call chain tracing

Para cada função/tipo modificado, rastreie callers E callees para verificar que a mudança é consistente em todos os contextos onde é utilizada.

Para mudanças em documentação, rastreie o caminho completo de implementação (handler -> service -> db/helpers) para verificar cada afirmação documentada.

Se a mudança introduz N opções/operadores/campos/modos, verifique que TODOS os N funcionam em TODOS os contextos.

Se a call chain abrange mais de 3 arquivos, delegue a exploração a um subagente de exploração, se o agente oferecer um.

## c. Doc <-> Code cross-referencing

- Se foi adicionado/modificado um doc de spec ou design: leia o código de implementação correspondente e verifique que cada passo/afirmação do doc está de fato implementado
- Se foi adicionado/modificado código de implementação: leia o doc de spec/design correspondente (se existir no repo) e verifique que o código corresponde ao que o doc descreve
- Pares comuns: test-design docs <-> test files, API docs <-> handlers, deploy runbooks <-> deploy scripts

## d. Mechanical code pattern checks

Use a skill `review-local` (plugin `hyperfleet-code-review`) com o escopo `uncommitted`, já que nada foi commitado. Ela revisa as mudanças da branch contra os standards do HyperFleet e inclui as checagens mecânicas. Ela só lê e não faz commit.

Se a skill não estiver disponível, faça as checagens à mão sobre todo o código modificado nesta sessão: enumere primeiro todas as instâncias de cada padrão (erros ignorados, recursos sem `Close`/`defer`, goroutines sem cancelamento, logs e mensagens de erro fora do padrão, segredos ou valores fixos no código) e só depois julgue cada uma.

## e. Intra-implementation consistency

Para padrões que aparecem mais de uma vez em diferentes arquivos modificados, verifique se TODAS as ocorrências usam a mesma abordagem. Exemplos:

- Estilo de error handling (alguns lugares checam erros, outros ignoram)
- Primitivas de sincronização (algumas goroutines usam `atomic`, outras usam `int` plain)
- Padrões de setup/teardown de teste (alguns testes restauram estado global, outros não)
- Convenções de nomeação, padrões de logging, padrões de acesso a config
- Se fez certo em um lugar, deve ser consistente em todos

## f. Correção e re-teste

Se qualquer problema for encontrado nos passes acima, corrija-o antes de prosseguir. Após corrigir, execute novamente:

```bash
make test
make integration-test  # se aplicável
make lint
```

Garanta que as correções não quebraram nada.
