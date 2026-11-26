# Auto-revisão

Análise de impacto e consistência aplicada sobre todo o código implementado/modificado na sessão. Cada seção DEVE ser executada — não pule nenhuma porque "parece ok".

## a. Impact analysis

Para cada struct, campo de config ou assinatura de função modificada, busque no codebase (`Grep`/`Glob`) por callers que possam precisar de atualização.

Verifique se algum arquivo **deveria ter sido modificado mas não foi** (ex: um Helm template que renderiza um campo cujo tipo mudou).

Se encontrar impactos não tratados, corrija-os.

## b. Call chain tracing

Para cada função/tipo modificado, rastreie callers E callees para verificar que a mudança é consistente em todos os contextos onde é utilizada.

Para mudanças em documentação, rastreie o caminho completo de implementação (handler -> service -> db/helpers) para verificar cada afirmação documentada.

Se a mudança introduz N opções/operadores/campos/modos, verifique que TODOS os N funcionam em TODOS os contextos.

Use o Agent tool com subagent_type=Explore se a call chain abrange mais de 3 arquivos.

## c. Doc <-> Code cross-referencing

- Se foi adicionado/modificado um doc de spec ou design: leia o código de implementação correspondente e verifique que cada passo/afirmação do doc está de fato implementado
- Se foi adicionado/modificado código de implementação: leia o doc de spec/design correspondente (se existir no repo) e verifique que o código corresponde ao que o doc descreve
- Pares comuns: test-design docs <-> test files, API docs <-> handlers, deploy runbooks <-> deploy scripts

## d. Mechanical code pattern checks

Execute os passes mecânicos de código definidos em [../review-pr/mechanical-passes.md](../review-pr/mechanical-passes.md).

**Diferença de escopo:** No contexto de implementação, aplique os passes sobre **todo o código modificado nesta sessão** (não sobre um diff de PR). O objetivo é o mesmo: enumerar instâncias primeiro, depois julgar.

Lance os 5 grupos de agentes em paralelo, passando o código modificado e a lista de arquivos alterados.

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
