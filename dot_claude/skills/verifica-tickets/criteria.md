# Critérios de Análise

Para cada ticket, verificar os seguintes critérios:

| Critério | Como verificar |
|----------|----------------|
| **Duplicado?** | Buscar tickets com summary similar |
| **Prioridade definida** | Campo `priority` não é "Undefined". Se for "Undefined", sugira uma prioridade baseada no tipo e contexto do ticket (Bug crítico: Blocker/Critical, Bug normal: Major, Story de infra: Normal, Task de investigação: Normal, etc.) |
| **Urgente/Blocker?** | Priority = "Blocker" ou tem links do tipo "Blocks" |
| **What/Why/AC** | Description contém seções "What", "Why" e "Acceptance Criteria" |
| **Story Points** | Campo `customfield_10028` não é null. Se for null, use a skill `hyperfleet-jira:jira-story-pointer` para estimar e sugerir um valor. Se o valor existir, verifique se está na sequência Fibonacci válida (0, 1, 3, 5, 8, 13). Se for 13, alerte que o ticket deve ser quebrado em tickets menores. Se não for Fibonacci (ex: 2, 4, 6, 7), sugira o valor Fibonacci mais próximo |
| **Assignee** | Só flaggar como erro se o ticket for Bug ou prioridade Blocker/Critical. Para os demais tipos e prioridades, Unassigned é estado normal (backlog) — marcar como ok |
| **Título** | Claro, actionable, menos de 100 caracteres. Alertar se for vago (ex: "Fix bug", "Update feature") |
| **Descrição** | Mais de 100 caracteres. Alertar se contiver linguagem ambígua ("TBD", "maybe", "probably", "possibly") |
| **Component** | Campo `components` não está vazio. Ver regras de sugestão abaixo |
| **Activity Type** | Campo `customfield_10464` não é "Uncategorized". Ver regras de sugestão abaixo |
| **Sprint** | Campo `sprint` não é null. Se for null, sugerir baseado na prioridade e tipo: Blocker/Critical: recomendar adicionar ao sprint atual imediatamente; Major: recomendar adicionar ao próximo sprint; Normal/Minor: apenas sinalizar como sem sprint |
| **Links** | Ver regras de verificação abaixo |

## Regras de verificação de Links

Cada item em `issuelinks` tem uma `direction` (rótulo do tipo de link, ex: "blocks", "is blocked by", "relates to", "duplicates", "clones") e o ticket do outro lado (`key`, `linkedSummary`, `linkedStatus`).

1. **Existência**: se a descrição, "Technical Notes" ou "Why" do ticket menciona explicitamente depender de, ser bloqueado por, ou bloquear outro ticket (cita a chave HYPERFLEET-XXX), mas não há um link correspondente em `issuelinks`, sinalizar como **alerta** — link ausente, sugerir adicionar.
2. **Direção correta**: para cada link do tipo blocks/is blocked by, verificar se a direção semântica bate com o conteúdo:
   - Se a `direction` é `"blocks"` (este ticket bloqueia o outro): o outro ticket deveria depender deste — ex. o outro ticket for prover, implementar ou usar algo que este ticket entrega/corrige primeiro.
   - Se a `direction` é `"is blocked by"` (este ticket é bloqueado pelo outro): este ticket deveria depender do outro — ex. a descrição/Technical Notes deste ticket menciona que precisa que o outro esteja pronto, mergeado ou implementado antes.
   - Se o texto do ticket sugere o oposto da direção registrada (ex: a descrição diz "depende de X" mas o link registrado é "blocks X" em vez de "is blocked by X"), sinalizar como **erro** e sugerir a correção exata (qual comando/direção deveria ser usado).
   - Quando o summary do ticket linkado (`linkedSummary`) não for suficiente para confirmar a direção, buscar a descrição completa do ticket linkado (`jira issue view <KEY> --raw`) antes de concluir.
3. **Status inconsistente**: se a `direction` é `"is blocked by"` e o `linkedStatus` do bloqueador já é Closed/Resolved/Done, sinalizar como **alerta** — o link pode estar obsoleto (bloqueio já resolvido) e deveria ser removido ou o ticket pode já estar liberado para andar.
4. Links do tipo `relates to`, `duplicates`, `clones` não precisam de verificação de direção (são simétricos ou já cobertos pelo critério de Duplicado), apenas confirmar que fazem sentido com o conteúdo.

## Regras de sugestão de Component

Se estiver vazio, sugerir baseado no summary, descrição e Epic. Componentes válidos (fonte: `hyperfleet/standards/ticket-hygiene.md` no repo de arquitetura):

| Component | Escopo |
|-----------|--------|
| `Adapter` | Adapter framework, task configs, resource lifecycle |
| `API` | REST API service, handlers, DAOs, middleware |
| `Architecture` | Architecture docs, standards, ADRs, working agreements |
| `CICD` | Prow jobs, Konflux pipelines, release automation |
| `Claude Plugins` | Claude Code plugins, skills, AI-assisted tooling |
| `E2E Tests` | End-to-end test suites and test infrastructure |
| `Documentation` | Developer guides, authoring guides, reference docs, pattern docs |
| `Infra` | Operator, Helm umbrella charts, deployment scripts |
| `Message Broker` | Shared broker library (Pub/Sub, RabbitMQ, CloudEvents) |
| `OCI` | OCI artifact distribution, Helm chart publishing |
| `Sentinel` | Sentinel reconciliation service, decision engine |

> **Nota:** O repo de arquitetura usa o nome "Infrastructure" mas no JIRA o componente se chama "Infra".

Regras de sugestão:
- summary/descrição menciona API, search, query, database, config, presenter, middleware, handler: `API`
- menciona adapter, task-config, transport, DSL, CEL, resource lifecycle: `Adapter`
- menciona sentinel, watcher, decision, evaluation, reconciliation engine: `Sentinel`
- menciona architecture, ADR, design, standards, working agreement: `Architecture`
- menciona operator, applier, helm, deployment, install, CRD, OLM: `Infra`
- menciona prow, konflux, pipeline, CI, release automation: `CICD`
- menciona e2e, end-to-end, test suite, test infrastructure: `E2E Tests`
- menciona claude, plugin, skill, AI tooling: `Claude Plugins`
- menciona guide, authoring guide, developer guide, reference doc, pattern doc: `Documentation`
- menciona broker, pub/sub, rabbitmq, cloudevents, message: `Message Broker`
- menciona OCI, artifact, chart publishing: `OCI`

Por Epic:
- HYPERFLEET-165: `API`
- HYPERFLEET-404: `Sentinel`
- HYPERFLEET-406: `Adapter`
- HYPERFLEET-1403: `Infra`
- HYPERFLEET-1418: `Infra`

Se ambíguo, sugerir baseado no contexto geral.

## Regras de sugestão de Activity Type

Se for "Uncategorized", sugerir baseado nas regras abaixo (em ordem de prioridade):

1. **Incidents & Support** — incidentes, escalações, suporte, on-call, impacto direto a clientes
2. **Security & Compliance** — CVEs, vulnerabilidades, FedRAMP, compliance, segurança, Prodsec
3. **Quality / Stability / Reliability** — bugs, SLOs, chores de CI/build/infra, tech debt, toil reduction (dashboards, process docs), PMR action items, Prow jobs, pipelines
4. **Associate Wellness & Development** — onboarding, treinamento, conferências, AI learning
5. **Future Sustainability** — arquitetura proativa (prevenir tech debt), melhorias de produtividade/processo, automação, spikes de melhoria, upstream, CLAUDE.md/guidance files, trabalho cross-team
6. **Product / Portfolio Work** — features novas, funcionalidades para clientes, PoC/spikes de produto, trabalho de roadmap

Regra de desempate:
- Se o ticket **corrige algo existente**: Quality
- Se **previne problemas futuros ou melhora processos**: Future Sustainability
- Se **entrega valor novo ao cliente**: Product
