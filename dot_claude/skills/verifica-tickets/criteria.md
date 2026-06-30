# Critérios de Análise

Para cada ticket, verificar os seguintes critérios:

| Critério | Como verificar |
|----------|----------------|
| **Duplicado?** | Buscar tickets com summary similar |
| **Epic linkado** | Campo `parent.key` não é null, ou ticket é Bug, ou tem label `no-epic-needed`. Ver regras detalhadas em [epics.md](epics.md) — só sugerir epic quando o ticket contribui diretamente para o acceptance criteria do epic (mesma lógica do `/atribui-epics`) |
| **Prioridade definida** | Campo `priority` não é "Undefined". Se for "Undefined", sugira uma prioridade baseada no tipo e contexto do ticket (Bug crítico: Blocker/Critical, Bug normal: Major, Story de infra: Normal, Task de investigação: Normal, etc.) |
| **Urgente/Blocker?** | Priority = "Blocker" ou tem links do tipo "Blocks" |
| **What/Why/AC** | Description contém seções "What", "Why" e "Acceptance Criteria" |
| **Story Points** | Campo `customfield_10028` não é null. Se for null, use a skill `hyperfleet-jira:jira-story-pointer` para estimar e sugerir um valor. Se o valor existir, verifique se está na sequência Fibonacci válida (0, 1, 3, 5, 8, 13). Se for 13, alerte que o ticket deve ser quebrado em tickets menores. Se não for Fibonacci (ex: 2, 4, 6, 7), sugira o valor Fibonacci mais próximo |
| **Fix Version** | Campo `fixVersions` não está vazio |
| **Assignee** | Só flaggar como erro se o ticket for Bug ou prioridade Blocker/Critical. Para os demais tipos e prioridades, Unassigned é estado normal (backlog) — marcar como ok |
| **Título** | Claro, actionable, menos de 100 caracteres. Alertar se for vago (ex: "Fix bug", "Update feature") |
| **Descrição** | Mais de 100 caracteres. Alertar se contiver linguagem ambígua ("TBD", "maybe", "probably", "possibly") |
| **Component** | Campo `components` não está vazio. Ver regras de sugestão abaixo |
| **Activity Type** | Campo `customfield_10464` não é "Uncategorized". Ver regras de sugestão abaixo |
| **Sprint** | Campo `sprint` não é null. Se for null, sugerir baseado na prioridade e tipo: Blocker/Critical: recomendar adicionar ao sprint atual imediatamente; Major: recomendar adicionar ao próximo sprint; Normal/Minor: apenas sinalizar como sem sprint |

## Regras de sugestão de Component

Se estiver vazio, sugerir baseado no summary, descrição e Epic. Componentes válidos: `API`, `Adapter`, `Sentinel`, `Architecture`.

Regras de sugestão:
- summary/descrição menciona API, search, query, database, config, presenter: `API`
- menciona adapter, task-config, reconcil: `Adapter`
- menciona sentinel, watcher, message, event, broker: `Sentinel`
- menciona architecture, docs, design, CLAUDE.md, standards: `Architecture`

Por Epic:
- HYPERFLEET-165: `API`
- HYPERFLEET-404: `Sentinel`
- HYPERFLEET-406: `Adapter`

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
