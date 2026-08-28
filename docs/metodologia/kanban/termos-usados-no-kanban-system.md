# Termos do Kanban

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/metodologia/kanban/termos-usados-no-kanban-system.html

---

# Termos usados no Kanban System
{: .no_toc }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

Este documento possui duas partes. A primeira reúne definições gerais do Kanban Guide. A segunda registra políticas do sistema descrito neste site, como estágios, tipos de item, classes de serviço e cadências.

Essa separação evita transformar escolhas locais em regras universais. Um time pode usar outros nomes, pontos de início, estados e reuniões, desde que sua Definition of Workflow deixe as políticas explícitas e preserve as práticas e métricas mínimas do Kanban.

## Definições gerais

### Kanban e fluxo

Kanban é uma estratégia para otimizar o fluxo de valor por um processo. O Kanban Guide define três práticas que funcionam em conjunto:

1. definir e visualizar o workflow;
2. gerenciar ativamente os itens no workflow;
3. melhorar o workflow.

O conjunto dessas práticas em uma implementação é um Kanban System. O board é uma visualização da Definition of Workflow; suas colunas não são prescritas pelo guia.

### Definition of Workflow — DoW

A DoW é o entendimento explícito e compartilhado de como o valor flui no contexto observado. No mínimo, ela define:

- quais unidades de valor percorrem o workflow;
- quando cada tipo de item é considerado iniciado e finalizado;
- os estados existentes entre esses pontos;
- como o WIP é controlado;
- as políticas para um item fluir entre os estados;
- uma Service Level Expectation para pelo menos um par de pontos de início e fim.

Um workflow pode ter mais de um par de início e fim quando existem serviços ou tipos de item diferentes. Nesse caso, métricas e SLE precisam indicar qual par utilizam.

### Work Item

Work Item é a unidade de valor potencial que percorre a DoW. Seu formato depende do serviço. História de usuário, bug, solicitação, experimento ou tarefa são tipos possíveis, não tipos obrigatórios do Kanban.

### WIP e sistema puxado

Work in Progress — WIP é a quantidade de itens iniciados e ainda não finalizados segundo os pontos definidos na DoW.

O sistema precisa controlar WIP. Limites numéricos por coluna são uma opção, mas a forma de controle pode variar. Quando existe capacidade sinalizada pela política, um novo item pode ser selecionado ou puxado. Exceções ao controle de WIP devem ser explícitas.

### Service Level Expectation — SLE

SLE é uma previsão de quanto tempo um item deve levar entre pontos de início e fim. Ela combina:

- um período de tempo decorrido;
- uma probabilidade associada a esse período.

A SLE deve usar o histórico de Cycle Time quando houver dados comparáveis. Sem histórico, a equipe pode começar com uma previsão provisória e substituí-la quando possuir observações suficientes.

SLE não é promessa de data para cada item. É uma previsão probabilística usada para gerenciar expectativa e observar envelhecimento.

## Métricas de fluxo

As quatro métricas mínimas do Kanban Guide dependem dos pontos de início e fim da DoW.

| Métrica | Definição geral |
|---|---|
| WIP | Contagem de itens iniciados e ainda não finalizados |
| Throughput | Contagem exata de itens finalizados por unidade de tempo |
| Work Item Age | Tempo decorrido entre o início e agora para um item ainda não finalizado |
| Cycle Time | Tempo decorrido entre o início e o fim de um item finalizado |

Work Item Age não é o tempo no estágio atual. Se essa informação for útil, ela deve receber outro nome, como **State Age**, e registrar quando o item entrou no estado.

As métricas não possuem fronteiras universais. “Início” e “fim” são os eventos declarados na DoW. Comparações e previsões precisam usar o mesmo tipo de item, a mesma unidade de tempo e o mesmo par de pontos.

### Lead Time

Lead Time é usado por equipes e ferramentas com fronteiras diferentes, como solicitação até entrega, compromisso até entrega ou entrada no backlog até produção. Ele não substitui a definição dos pontos.

Sempre escreva o nome completo da medida ou apresente a fórmula, por exemplo: “Lead Time do compromisso: entrada no Backlog → Done”. Sem isso, dois relatórios chamados Lead Time podem medir intervalos diferentes.

### Visualizações

Um Cumulative Flow Diagram — CFD mostra a quantidade de itens em estados ao longo do tempo. Ele pode ajudar a observar WIP, acúmulo e mudanças no fluxo. Não é o único gráfico possível nem demonstra sozinho a causa de uma variação.

Scatterplot de Cycle Time, gráfico de Work Item Age e histórico de Throughput podem responder perguntas diferentes. A visualização deve apoiar uma decisão sobre gerenciamento ou melhoria do workflow.

## Políticas deste sistema

As seções seguintes descrevem o fluxo adotado neste site. Elas não fazem parte do conjunto mínimo de termos do Kanban Guide.

### Hierarquia de negócio

| Termo local | Uso neste sistema |
|---|---|
| Iniciativa Estratégica | Objetivo de negócio que orienta um ou mais esforços de produto ou projeto |
| Projeto/Produto | Agrupamento usado para organizar um serviço, contrato ou esforço associado à iniciativa |
| Feature | Capacidade perceptível que pode agrupar vários Work Items quando não cabe em uma única entrega |
| Stakeholder | Pessoa ou grupo afetado pelo resultado ou capaz de influenciar a decisão |

Essa hierarquia é uma convenção de portfólio. Kanban não exige Iniciativa, Projeto, Produto ou Feature, nem determina a relação entre eles.

### Tipos de Work Item

Este sistema usa os seguintes tipos:

| Tipo | Política local |
|---|---|
| User Story | Necessidade formulada do ponto de vista de um usuário; o formato “Como..., quero..., para...” é opcional |
| Technical Task | Trabalho técnico necessário para habilitar, proteger ou operar o serviço |
| Bug | Comportamento incorreto observado em produção que precisa ser corrigido |
| Tech Debt | Trabalho para tratar um custo conhecido de manutenção, segurança ou evolução |
| Spike/Estudo | Investigação com limite de tempo e pergunta ou incerteza a reduzir |

Os tipos ajudam a aplicar políticas e analisar o fluxo. Eles não demonstram valor, prioridade ou tamanho por si só.

### Fluxo de descoberta

O Upstream Kanban deste sistema prepara opções para entrega:

```text
Ideas Funnel → Analysis → Backlog
```

- **Ideas Funnel:** opções e ideias ainda não avaliadas;
- **Analysis:** avaliação de problema, evidência, impacto, risco e alternativas;
- **Backlog:** itens ordenados que atendem à política de entrada definida para a entrega.

Este documento ainda não registra os pontos de início e fim, o controle de WIP ou a SLE do fluxo de descoberta. Esses parâmetros precisam constar em sua própria DoW antes que métricas upstream sejam calculadas.

### Fluxo de entrega

O Downstream Kanban usa os seguintes estados:

```text
Ready for Dev → In Development → Validation → Ready to Deploy → Done
```

- **Ready for Dev:** item aceito pela política de entrada e disponível para seleção;
- **In Development:** implementação e verificações sob responsabilidade do desenvolvimento;
- **Validation:** validação definida para o item, como revisão, teste exploratório ou aceitação;
- **Ready to Deploy:** critérios técnicos anteriores à liberação foram atendidos;
- **Done:** item disponível em produção segundo a política de saída.

Para as métricas de entrega deste documento:

| Medida local | Início | Fim ou referência |
|---|---|---|
| WIP de entrega | Entrada em Ready for Dev | Saída ao entrar em Done |
| Cycle Time de entrega | Entrada em Ready for Dev | Entrada em Done |
| Work Item Age de entrega | Entrada em Ready for Dev | Agora, apenas para item ainda não Done |
| Throughput de entrega | — | Quantidade de itens que entram em Done por unidade de tempo declarada no relatório |
| Lead Time do compromisso | Entrada no Backlog | Entrada em Done |
| State Age | Entrada no estado atual | Agora |

Se a equipe decidir que o relógio deve começar apenas em `In Development`, precisa alterar a DoW, a SLE e todas as métricas relacionadas. Não combine dados produzidos com pontos diferentes na mesma série histórica sem identificar a mudança.

### Parâmetros ainda não registrados

O material disponível não informa:

- valores dos controles ou limites de WIP;
- período e probabilidade da SLE;
- unidade de tempo padrão dos relatórios de Throughput;
- políticas detalhadas de passagem entre todos os estados;
- tratamento de itens cancelados, bloqueados ou que retornam de estado;
- calendário usado para calcular tempo decorrido.

Esses dados não devem ser inventados. Eles precisam ser definidos pelos membros do sistema e publicados no board ou na DoW operacional.

### Definition of Ready e Definition of Done

Neste sistema, Definition of Ready — DoR é o checklist usado para aceitar um item em `Ready for Dev`. Ele explicita critérios de entrada e reduz o risco de iniciar trabalho sem informações consideradas necessárias pela equipe. DoR é uma política local, não um requisito do Kanban Guide.

Definition of Done — DoD é o checklist associado à entrada em `Done`. Ele explicita critérios de saída, mas não demonstra sozinho a qualidade do resultado nem o valor gerado.

### Classes de serviço

Este sistema utiliza classes de serviço para tornar explícito como tipos diferentes de risco ou Cost of Delay afetam a seleção. Essas classes são políticas locais:

| Classe | Uso pretendido | Risco a controlar |
|---|---|---|
| Expedite | Incidente ou necessidade urgente que justifica tratamento excepcional | Exceções frequentes interrompem o fluxo; deve existir controle de WIP próprio |
| Fixed Date | O Cost of Delay muda de forma relevante em uma data conhecida | Começar tudo cedo demais aumenta WIP e não garante entrega |
| Standard | Política padrão de seleção quando não existe condição excepcional | A fila pode esconder itens envelhecidos ou grupos com necessidades diferentes |
| Intangible | Benefício ou perda de longo prazo difícil de observar imediatamente | Adiar continuamente pode acumular risco ou custo, como Tech Debt |

Os limites, critérios de entrada e prioridade entre classes precisam aparecer na DoW. O nome de uma classe não autoriza ultrapassar WIP silenciosamente.

### Cadências

Reuniões não são prescritas como parte do mínimo do Kanban Guide. O gerenciamento pode ocorrer continuamente, em intervalos regulares ou combinando os dois. Este sistema adota inicialmente:

- **Kanban Meeting diária:** revisão do board da direita para a esquerda para desbloquear e mover itens existentes;
- **Replenishment semanal:** seleção de itens do Backlog quando existe capacidade e as políticas de entrada foram atendidas;
- **Service Delivery Review:** análise de expectativas, métricas de fluxo, variação e riscos do serviço;
- **Risk Review:** revisão de bloqueios, dependências e riscos que afetam o fluxo.

A frequência deve mudar quando o custo da reunião superar sua utilidade ou quando os riscos exigirem resposta mais rápida. Melhorias na DoW não precisam esperar uma reunião agendada.

## Outputs e outcomes

**Output** é o artefato ou serviço produzido, como uma funcionalidade, correção, API ou relatório. **Outcome** é uma mudança observada no comportamento, na operação ou em um resultado relevante depois que o output é utilizado.

Entregar um output não comprova que ele causou o outcome esperado. Antes da entrega, o outcome é uma hipótese. Depois, ainda são necessárias observação, uma referência de comparação, período de análise e atenção a outros fatores que possam explicar a mudança.

Por exemplo, uma nova recuperação de senha é um output. Reduzir solicitações de suporte relacionadas a acesso pode ser a hipótese de outcome. Para avaliá-la, é preciso definir quais solicitações contam, qual era a referência anterior, durante quanto tempo observar e quais outras mudanças ocorreram no período.

Throughput e Cycle Time informam o desempenho do fluxo de outputs. Eles não medem diretamente adoção, satisfação, receita, custo evitado ou outro outcome.

### Aplicação neste sistema

- **Ideas Funnel e Analysis:** registrar problema, evidência disponível, outcome esperado e como ele poderá ser observado;
- **Replenishment:** comparar hipótese de valor, Cost of Delay, risco, evidência e capacidade, sem priorizar apenas facilidade ou quantidade de outputs;
- **Service Delivery Review:** separar desempenho do fluxo de evidências de valor obtidas depois da entrega;
- **Done:** indica que a política de saída foi atendida; não transforma automaticamente valor potencial em valor validado.

O Open Guide to Kanban distingue valor validado de valor invalidado para manter essa verificação explícita. Melhorar o fluxo de outputs pode reduzir tempo e risco de entrega, mas o outcome esperado permanece uma hipótese até que existam evidências.

Não há diferença de “maturidade” que possa ser inferida apenas pelo pedido de um stakeholder. Uma solicitação de output pode esconder uma necessidade legítima; a responsabilidade do sistema é tornar explícita a hipótese e decidir como avaliá-la.

## Checklist de revisão

1. Work Items, pontos de início e fim e estados estão explícitos?
2. O controle de WIP inclui suas exceções?
3. A SLE informa tempo, probabilidade e par de pontos?
4. Work Item Age usa o início da DoW e apenas itens não finalizados?
5. Lead Time e State Age apresentam suas fronteiras?
6. As métricas usam tipos de item e calendários comparáveis?
7. DoR, DoD, classes de serviço e cadências estão identificadas como políticas locais?
8. O board reflete a DoW operacional vigente?
9. Outputs e outcomes são medidos separadamente?
10. Outcomes esperados permanecem hipóteses até a validação?

## Referências

- [The Kanban Guide — versão vigente](https://kanbanguides.org/the-kanban-guide/)
- [Open Guide to Kanban — julho de 2025](https://kanbanguides.org/open-guide-to-kanban/2025.7/)
