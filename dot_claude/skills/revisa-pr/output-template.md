# Formato de saída

## Abertura

Comece com um parecer direto, sem narrar os passos da investigação:

> Concordo com a direção, mas pediria revisão antes do merge. Eu deixaria 3 comentários.

Adapte ao resultado real: concordância total, parcial ou discordância. Não fixe a quantidade em três.

Se houver respostas sugeridas em discussões existentes, conte-as separadamente dos comentários novos. Não inclua pontos pendentes sem informação nova na contagem de comentários a deixar.

## Cada comentário

Use esta estrutura, repetida para todos os comentários selecionados:

### 1. Título específico do problema — arquivo, linha N

Referência: [caminho/do/arquivo.md:N](https://github.com/owner/repo/pull/numero/files#diff-sha256Rlinha).

> Trecho literal da linha ou das linhas da PR que motivam o comentário.

Por quê: explique em português o raciocínio, o impacto e o que falta demonstrar ou corrigir. Use exemplos concretos quando ajudarem. Diferencie evidência direta de hipótese. Se usar uma estimativa, identifique-a como estimativa e diga quais premissas a sustentam.

Comentário para postar:

Write the actual review comment in English here. State the concern, explain its consequence, and ask for a concrete clarification or correction. Keep the tone respectful and technically precise. Avoid unsupported accusations and do not prescribe a solution without establishing why it is necessary.

## Regras de apresentação

- O exemplo acima é um template: substitua todos os placeholders por dados reais; nunca publique seus links fictícios.
- O texto após “Comentário para postar:” deve ser texto puro para copiar e colar: sem blockquote, moldura, prefixo por linha ou bloco de código envolvendo o comentário.
- Use blockquote somente para o trecho literal da PR, não para o comentário sugerido.
- Dentro do comentário, exemplos de código ou sugestões de substituição podem usar blocos cercados com linguagem (`go`, `yaml`, `suggestion`, etc.).
- Não misture explicações em português no texto em inglês pronto para GitHub.
- Não inclua severidade, confiança ou categorias automaticamente no comentário para postar. Mostre no parecer apenas se forem úteis ou solicitadas.
- Cite somente as linhas necessárias. Para uma tabela, pode citar a linha inteira; para um parágrafo longo, cite uma frase exata e identifique como trecho.
- Não limite a saída ao primeiro comentário. Mostre a lista completa, salvo pedido contrário.

## Fechamento opcional

Acrescente apenas informações que alterem a interpretação da revisão:

- Limitações da análise, como benchmarks não reproduzidos.
- Observações de impacto fora do diff.
- Avaliação de comentários existentes, seguindo as regras abaixo, sem apresentá-los novamente como novos achados.

Não acrescente um segundo resumo longo nem uma lista de procedimentos já executados.

## Findings já levantados por outros revisores

- Inclua problemas relevantes ainda pendentes no parecer, mesmo sem novos comentários a sugerir. Para cada um, indique o link da thread e explique em português se concorda e por quê.
- Não sugira um comentário duplicado apenas para reforçar concordância.
- Quando houver evidência ou impacto novo, use a mesma estrutura de trecho, explicação e texto em inglês, mas identifique o item como “Resposta na thread existente” e troque o rótulo por “Resposta para postar na thread:”. Inclua o link da thread e acrescente somente o contexto novo.
- Se discordar, explique a divergência com evidência. Sugira resposta apenas quando ela acrescentar uma contribuição concreta à discussão.
- Problemas corrigidos não são pendências. Mencione sua resolução somente quando ajudar a interpretar a revisão.

## Quando não houver comentários

Informe que não deixaria novos comentários e explique brevemente o veredito. Se houver questões já apontadas por revisores, diferencie “sem novos achados” de “PR pronta para merge”.
