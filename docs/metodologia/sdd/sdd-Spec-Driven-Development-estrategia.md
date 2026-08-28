# SDD Estratégico

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/metodologia/sdd/sdd-Spec-Driven-Development-estrategia.html

---

# Spec-Driven Development: Estratégico
{: .no_toc }

Uma abordagem estratégica para desenvolvimento orientado por especificação com suporte intensivo de IA.
{: .fs-6 .fw-300 }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

## Contexto Atual

O desenvolvimento de software atravessa um momento de transição com forte presença de IA no fluxo de trabalho.

Principais características do cenário atual:

- Necessidade de fundamentos clássicos combinados com inovação acelerada  
- IA com acesso ao sistema operacional e capacidade de atuar sobre contexto real  
- Aumento de velocidade na criação, acompanhado de incertezas e frustrações  
- Documentação descartável, onde o código passa a ser a única fonte de verdade  
- Conhecimento implícito com alto custo de manutenção  
- Dificuldade de evolução tecnológica em médio/longo prazo  

## Janela de Contexto

Modelos de linguagem operam sob limitações de contexto.

Problemas comuns:

- Excesso de regras, histórico e exemplos  
- Sobrecarga de contexto  
- Efeito *lost in the middle*  
- Aumento de alucinações  
- Crescimento de latência  

Isso exige disciplina na forma como o contexto é construído e entregue.

## Context Design

Contexto deve ser tratado como um recurso escasso.

Princípios:

- Resolver, comprimir e podar dados antes de cada chamada  
- Separar contexto transitório de memória persistente  
- Externalizar conhecimento relevante  

![](/assets/e20e4dc467f7e9092e07f74aae768816_MD5.png){: .rounded }

Conceitos-chave:

- **Camada de memória externa** para persistência  
- **AI Skills**: instruções modulares (arquivos) que ensinam a IA a executar tarefas específicas com consistência  
- Organização do conhecimento em:
  - Codebase  
  - Skills  
  - MCPs (Model Context Protocols)  

![](/assets/89acd3d84e8303658b3428636d22e56b_MD5.png){: .rounded }


## Spec-Driven Development

No modelo de SDD proposto aqui, a especificação é tratada como a principal referência de intenção e decisão. Essa é uma escolha de governança, não uma propriedade garantida pela ferramenta ou pelo formato Markdown.

Princípios fundamentais:

- especificação como referência para comportamento, restrições e critérios de aceitação;
- código como implementação derivada dessas decisões;
- conhecimento relevante registrado em artefatos versionados.

Consequências esperadas, ainda sujeitas a validação:

- partes do sistema podem ser regeneradas quando a especificação contém informação suficiente e os testes verificam equivalência;
- a separação entre intenção e implementação pode reduzir dependência de uma tecnologia específica;
- decisões deixam de depender apenas da leitura do código.

Esses resultados deixam de valer quando especificação e implementação divergem. Código executável, testes, configuração, dados e infraestrutura continuam contendo informação que pode não estar representada na especificação.

Elementos da especificação:

- User Stories  
- Critérios de aceitação  
- Testes funcionais  

Eu verificaria a proposta com quatro controles:

- toda mudança de comportamento referencia uma especificação;
- critérios de aceitação possuem testes ou outra evidência reproduzível;
- desvios encontrados durante a implementação retornam aos artefatos correspondentes;
- a fase de arquivamento registra decisões, limitações e diferenças que permanecem depois do merge.

Um teste mais forte é regenerar uma parte delimitada em uma branch isolada e comparar seu comportamento com a implementação vigente. Sem esse tipo de verificação, “fonte da verdade” descreve uma intenção de governança, não um estado demonstrado.

## Papel do Humano

Neste modelo, o trabalho humano se concentra mais em:

- Definidor de contexto  
- Curador de especificações  
- Validador de decisões  
- Orquestrador do sistema  

Isso não elimina a execução direta nem transfere a responsabilidade final para a IA. O nível de delegação depende do risco da mudança, da maturidade dos testes, das permissões concedidas ao agente e da capacidade de revisar o resultado. Definir o sistema incorretamente também continua sendo um modo de falha.

![](/assets/slides-assets/sdd-flow.png){: .rounded }

## Ambiente Enterprise: Fases

Em ambientes corporativos, o modelo se organiza em fases claras.

Características:

- Cada fase é assistida por IA através de *skills*  
- Delegação de tarefas aumenta progressivamente em direção à máquina  
- Fases intermediárias podem ser reexecutadas  

![](/assets/1f45ccbd61aaca931b20da8f35cb8843_MD5.png){: .rounded }

Exemplo de reprocessamento:

- Upgrade tecnológico  
- Troca de stack  
- Reinterpretação da especificação  

{: .note }
> Próximo passo evolutivo:
> - SpecKit com presets customizados  
> - Integração com sistemas de tickets via MCPs/Skills  

## Recomendações

Estas são decisões a avaliar durante a adoção, não requisitos universais do SDD.

### Repositórios e rastreabilidade

- Escolha os limites dos repositórios de acordo com ownership, ciclo de implantação e necessidade de versionamento conjunto. Um monorepo pode ser mais adequado quando componentes mudam e são validados em conjunto.
- Use branch por feature quando o isolamento facilitar revisão e experimentação. Em equipes com integração contínua e mudanças pequenas, branches curtas ou desenvolvimento baseado em trunk podem reduzir divergência.
- Mantenha vínculos rastreáveis entre especificação, mudança, testes e decisão de merge.

### Limites do sistema

Separe componentes quando houver uma razão verificável, como ownership distinto, necessidade de implantação independente, isolamento de falhas ou ritmo de evolução diferente. Cada separação também acrescenta contratos, observabilidade, versionamento e operação.

Um monólito modular pode ser mais proporcional quando a equipe é pequena, os componentes mudam juntos ou a infraestrutura distribuída custaria mais do que a autonomia obtida. A especificação deve registrar o critério usado para escolher o limite, não presumir que mais componentes sejam melhores.

### Testes

Defina a estratégia de testes conforme o risco e o tipo de comportamento. TDD pode aumentar o trabalho inicial e também reduzir regressões em alguns contextos; o efeito sobre tempo e consumo de tokens deve ser medido no fluxo utilizado pela equipe.

Independentemente da técnica, priorize testes para critérios de aceitação, regras críticas, integrações e falhas difíceis de reverter. Registre também quais comportamentos permanecem sem cobertura e como serão validados.

## Esclarecimentos

SDD não elimina engenharia tradicional.

Ele:

- Reorganiza onde o conhecimento vive  
- Aumenta a necessidade de clareza conceitual  
- Exige disciplina maior na modelagem  

Código continua importante, mas deixa de ser o ponto central.

![](/assets/0f42fef86f2e4e6715b651ba8cb626af_MD5.png){: .rounded }


## Outputs

Os principais artefatos passam a ser:

- Especificações estruturadas  
- Modelos de contexto  
- Skills reutilizáveis  
- Artefatos gerados (código, testes, configs)  

O sistema final é resultado da interpretação da especificação.

![](/assets/b3b51b780208f66b6b0b94d6d578bba5_MD5.png){: .rounded }


## Perguntas Frequentes

1. Como garantir que a especificação permaneça como fonte da verdade sem divergir do código?  
2. Qual o mecanismo de governança para decisões implícitas da IA?  
3. Como lidar com sistemas legados sem especificação formal?  
4. Como mensurar produtividade sem codificação direta humana?  
5. Como evitar lock-in em vendors de IA?  
6. Qual o custo real (tokens, infra, tempo) comparado ao modelo tradicional?  
7. Como garantir aderência a padrões arquiteturais ao longo das iterações?  

{: .note }
> A adoção de SDD exige maturidade organizacional. Sem disciplina na especificação, o modelo tende a degradar rapidamente.
