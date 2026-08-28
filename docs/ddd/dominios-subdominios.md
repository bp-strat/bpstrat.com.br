# Domínios e Subdomínios

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/ddd/dominios-subdominios.html

---

# Domínios e subdomínios: classificação e decisões de investimento
{: .no_toc }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

Classificar um subdomínio como Core, Supporting ou Generic ajuda a discutir onde concentrar atenção e capacidade de engenharia. A classificação não determina, sozinha, se a solução deve ser construída, comprada ou terceirizada.

Uma mesma capacidade pode ser estratégica para uma organização e comum para outra. Também pode mudar de categoria quando a estratégia, o mercado, a regulação, a tecnologia disponível ou a capacidade operacional mudam. Por isso, a classificação deve registrar evidências, hipóteses e uma data de revisão.

## Domínio, subdomínio e Bounded Context

Na referência de Domain-Driven Design, domínio é uma esfera de conhecimento, influência ou atividade. O domínio do software é a área à qual o usuário aplica o programa.

Um subdomínio é uma parte do espaço do problema. Separar o domínio em subdomínios ajuda a identificar capacidades, regras e conhecimentos com importância estratégica diferente.

Bounded Context pertence ao espaço da solução: delimita onde um modelo e sua linguagem são aplicáveis. Um subdomínio e um Bounded Context podem ter correspondência útil, mas ela não é obrigatoriamente um para um. Um subdomínio pode exigir mais de um contexto, e um sistema legado pode manter responsabilidades de vários subdomínios no mesmo contexto.

## Classificação estratégica

As categorias abaixo são hipóteses sobre a importância atual de uma capacidade para a organização.

| Categoria | Pergunta principal | Características possíveis | Cuidado necessário |
|---|---|---|---|
| Core Domain | Em que capacidade a organização pretende se diferenciar ou aprender mais rápido? | Modelo específico, conhecimento escasso, mudança frequente ou impacto direto na estratégia | Nem toda lógica complexa ou fonte de receita é Core |
| Supporting Subdomain | Qual capacidade específica é necessária para viabilizar o negócio ou o Core sem constituir a diferenciação escolhida? | Regras próprias, integração importante ou processo interno particular | “Supporting” não significa dispensável nem baixa qualidade |
| Generic Subdomain | Qual capacidade resolve um problema amplamente conhecido, com modelos ou soluções reutilizáveis? | Linguagem consolidada, oferta de mercado ou pouca diferenciação local | “Generic” não significa simples, barato, sem risco ou compra obrigatória |

Complexidade e diferenciação ajudam a conversa, mas não produzem a categoria automaticamente. Autenticação, faturamento ou observabilidade podem ser genéricos para a estratégia e, ao mesmo tempo, possuir alto risco operacional. Um algoritmo complexo pode não ser Core se não sustentar uma diferença relevante para a organização.

### O que observar

Para classificar um subdomínio, procure evidências em vez de atribuir uma nota intuitiva.

| Critério | Perguntas | Evidência possível |
|---|---|---|
| Diferenciação | A capacidade muda por que a organização compete ou cumpre sua missão? O usuário escolheria a solução por causa dela? | Estratégia documentada, pesquisa com usuários, análise competitiva, resultado de experimentos |
| Impacto | Quais resultados dependem da capacidade? O que acontece se ela falhar ou não evoluir? | Métricas de produto e operação, incidentes, perdas, obrigações contratuais |
| Especificidade do modelo | O conhecimento e as regras são particulares desta organização? Existe uma linguagem própria relevante? | Workshops de domínio, regras documentadas, variações em relação a soluções disponíveis |
| Mudança e incerteza | A equipe ainda precisa descobrir o modelo? As regras mudam com frequência? | Histórico de alterações, hipóteses abertas, retrabalho, roadmap |
| Mercado | Existem produtos, serviços, bibliotecas ou padrões que atendem aos requisitos? | Avaliação técnica atual, prova de conceito, referências de clientes comparáveis |
| Risco e regulação | Quais requisitos de segurança, privacidade, auditoria, disponibilidade ou soberania se aplicam? | Análise de risco, requisitos legais validados, políticas internas, SLA e RTO/RPO |
| Capacidade operacional | A organização consegue desenvolver, operar, proteger e manter a solução? | Competências da equipe, carga de suporte, orçamento, plantão, histórico de operação |

Ausência de evidência não deve ser convertida em certeza. Registre a classificação como provisória quando a estratégia ou o comportamento da capacidade ainda não estiverem claros.

### Notas numéricas são opcionais

Uma escala pode ajudar a comparar percepções em um workshop, mas números sem rubrica apenas escondem opiniões.

Se a equipe decidir pontuar critérios:

- defina o significado de cada faixa antes da avaliação;
- associe cada nota a uma evidência ou hipótese identificada;
- registre quem participou e em qual data;
- examine divergências entre participantes, em vez de usar somente a média;
- teste se pequenas mudanças nas notas alterariam a decisão;
- não publique o resultado como diagnóstico universal do setor.

Quando esse método não estiver disponível, prefira avaliações qualitativas acompanhadas de justificativa.

## Classificação não é decisão de fornecimento

Build, buy, adoção de open source, terceirização e reaproveitamento de legado são opções de fornecimento e operação. Elas respondem a outra pergunta: qual arranjo atende aos requisitos com custo, risco e capacidade aceitáveis?

As decisões podem ser combinadas. Um Core Domain pode usar banco, mensageria, modelos ou serviços adquiridos enquanto a equipe mantém internamente o conhecimento que produz diferenciação. Um Generic Subdomain pode ser construído quando não existe produto compatível, quando o custo total é menor ou quando requisitos de regulação, latência, integração ou reversibilidade impedem a compra.

### Critérios para comparar opções

| Critério | O que comparar |
|---|---|
| Adequação | Cobertura dos requisitos essenciais e custo das lacunas |
| Diferenciação | Qual parte do conhecimento ou comportamento precisa permanecer sob controle da organização |
| Custo total | Licença, desenvolvimento, integração, migração, operação, suporte, segurança e saída |
| Tempo e reversibilidade | Prazo para aprender ou entregar, custo de trocar a decisão e dependência de roadmap externo |
| Risco | Segurança, privacidade, disponibilidade, continuidade do fornecedor e concentração operacional |
| Regulação | Evidências de conformidade, auditoria, localização de dados, retenção e responsabilidades contratuais |
| Capacidade operacional | Pessoas, competências, observabilidade, resposta a incidentes e manutenção de longo prazo |
| Integração e dados | Contratos, qualidade, portabilidade, sincronização, ownership e consistência dos dados |

### Trade-offs por opção

| Opção | Pode fazer sentido quando | Custos e riscos a verificar |
|---|---|---|
| Construir internamente | O comportamento é diferenciador, a solução disponível não atende ou o aprendizado precisa ficar na equipe | Tempo, manutenção contínua, segurança, operação e custo de oportunidade |
| Comprar um produto ou SaaS | A capacidade está madura no mercado e a solução atende aos requisitos essenciais | Lock-in, integração, migração, preço futuro, acesso aos dados e dependência do fornecedor |
| Adotar open source e operar | A solução reduz desenvolvimento sem transferir o controle operacional | Atualizações, vulnerabilidades, conhecimento interno, infraestrutura e suporte |
| Terceirizar desenvolvimento ou operação | Falta capacidade interna temporária ou a especialização externa reduz um risco conhecido | Retenção de conhecimento, governança, contratos, transição e dependência da equipe externa |
| Reaproveitar legado | A capacidade existente atende ao objetivo e substituí-la custa mais do que integrá-la com limites claros | Restrições de mudança, acoplamento, obsolescência, suporte e estratégia de saída |

Nenhuma linha da tabela é uma recomendação automática. A opção escolhida precisa ser comparada com os requisitos e as restrições do caso.

## Processo recomendado

### 1. Mapear o problema sem escolher produto

Liste capacidades e regras na linguagem do negócio. Evite começar por nomes de sistemas, equipes ou fornecedores, pois eles descrevem a solução atual e podem esconder limites diferentes no problema.

### 2. Declarar a estratégia e o horizonte

Registre qual resultado a organização pretende diferenciar, proteger ou melhorar e em qual horizonte a decisão será avaliada. Sem essa informação, Core tende a significar apenas “importante” ou “complexo”.

### 3. Classificar com evidências e incertezas

Para cada subdomínio, registre categoria proposta, evidências, hipóteses contrárias e perguntas abertas. Divergência entre participantes é informação para investigação, não um erro a eliminar por votação.

### 4. Comparar opções de fornecimento separadamente

Só depois da classificação, compare construir, comprar, adotar, terceirizar ou manter o legado. Use os mesmos requisitos essenciais e o mesmo horizonte de custo para todas as alternativas.

### 5. Definir limites e responsabilidades

Identifique quem decide sobre o modelo, quem opera a solução, quem responde por incidentes, quais dados ficam sob qual ownership e como a organização poderá sair da escolha.

### 6. Revisar por sinais observáveis

Reavalie a decisão quando ocorrer uma mudança relevante, como nova estratégia, produto de mercado viável, exigência regulatória, aumento de incidentes, custo incompatível ou perda de capacidade interna. A revisão não precisa esperar um calendário fixo quando esses sinais já estiverem presentes.

## Exemplo hipotético

Considere uma plataforma de entregas cuja estratégia declarada seja oferecer previsões mais confiáveis em regiões atendidas por transportadores locais. O cenário é didático; não descreve uma empresa observada nem recomenda produtos.

| Capacidade | Hipótese de classificação | Alternativas a avaliar | Evidência que falta |
|---|---|---|---|
| Previsão de prazo | Core, se a qualidade da previsão sustentar a diferenciação declarada | Modelo interno com componentes de dados adquiridos ou open source | Impacto da previsão na escolha e retenção dos clientes |
| Cadastro de transportadores | Supporting, se exigir regras locais sem diferenciar a oferta | Workflow configurável, implementação simples ou serviço existente | Variação real das regras e custo de integração |
| Gestão de identidade | Generic, se os requisitos forem atendidos por modelos consolidados | SaaS, open source operado ou solução corporativa existente | Requisitos de segurança, residência de dados, integração e custo total |
| Notificações de entrega | Generic ou Supporting, conforme a linguagem e os fluxos específicos | Serviço de comunicação com uma camada local de regras | Necessidade de personalização e criticidade operacional |

Mesmo nesse cenário, Core não significa “construir tudo”. O conhecimento sobre previsão pode permanecer interno enquanto infraestrutura e capacidades auxiliares são adquiridas. Da mesma forma, classificar identidade como Generic não autoriza contratar um fornecedor antes de avaliar risco, regulação, integração e operação.

## Registro da decisão

Use um registro curto para tornar a análise revisável:

```yaml
subdomain:
business_outcome:
classification: core | supporting | generic | provisional
evidence:
assumptions:
open_questions:
constraints:
supply_options_considered:
decision:
consequences:
owner:
decision_date:
review_signals:
```

O registro não substitui pesquisa, modelagem ou análise jurídica. Ele torna visível a base usada para decidir e ajuda a identificar quando essa base deixou de ser válida.

## Referências

- [Eric Evans: Domain-Driven Design Reference](https://www.domainlanguage.com/ddd/reference/)
- [DDD Crew: Bounded Context Canvas](https://github.com/ddd-crew/bounded-context-canvas)
- Eric Evans — *Domain-Driven Design: Tackling Complexity in the Heart of Software*
- Vaughn Vernon — *Implementing Domain-Driven Design*
- Vlad Khononov — *Learning Domain-Driven Design*
