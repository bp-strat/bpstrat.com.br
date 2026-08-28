# Quando a Qualidade Melhora a Velocidade de Entrega

Published: 2025-06-11
Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/post/a-qualidade-como-acelerador/
Tags: Produtividade

---

Qualidade e velocidade não são necessariamente objetivos opostos. Defeitos, retrabalho e dificuldade para modificar o sistema podem atrasar entregas; por outro lado, testes, refatoração e coordenação também exigem tempo e manutenção.

A questão relevante não é se toda prática de qualidade acelera o desenvolvimento, mas em quais condições o benefício supera seu custo. Essa resposta depende do risco do sistema, da frequência das mudanças, do custo das falhas e da forma como a prática é implementada.

Este artigo examina quatro intervenções — testes automatizados e TDD, código fácil de modificar, coordenação em tempo real e tratamento de gargalos. Para cada uma, é necessário comparar benefícios, custos e resultados observados no fluxo de entrega.

## Práticas a avaliar

### Testes Automatizados e TDD

Testes automatizados podem reduzir o risco de regressões e tornar alterações mais verificáveis. O resultado depende da qualidade dos testes, do tipo de sistema e do custo de manter a suíte.

Em [quatro estudos de caso industriais](https://research.ibm.com/publications/realizing-quality-improvement-through-test-driven-development-results-and-experiences-of-four-industrial-teams), três equipes da Microsoft e uma da IBM que adotaram TDD apresentaram densidade de defeitos antes da entrega entre 40% e 90% menor que a de projetos comparáveis. As mesmas equipes relataram um aumento inicial de 15% a 35% no tempo de desenvolvimento.

Esse resultado não demonstra que TDD produzirá a mesma redução em qualquer contexto. Eu avaliaria a prática comparando:

- defeitos encontrados antes e depois da entrega;
- tempo gasto na implementação e manutenção dos testes;
- duração do ciclo de mudança;
- regressões detectadas pela suíte;
- custo de corrigir defeitos que chegaram à produção.

TDD faz mais sentido quando o custo adicional no início é compensado pela redução de regressões e pela capacidade de alterar o sistema com segurança. Quando os testes são frágeis ou reproduzem detalhes de implementação, a manutenção da suíte pode consumir parte desse benefício.

  

### Código Fácil de Modificar

“Código limpo” é uma expressão ampla. Para este argumento, o critério mais útil é quanto tempo e risco uma mudança exige.

Uma área do sistema tende a ser mais fácil de modificar quando:

- sua responsabilidade está clara;
- as dependências relevantes podem ser identificadas;
- o comportamento pode ser verificado por testes;
- uma alteração permanece concentrada em poucos componentes;
- falhas podem ser detectadas antes da produção.

Não há base no material disponível para afirmar que essas características tornam toda alteração sete vezes mais rápida. Eu avaliaria o efeito observando:

- tempo entre o início e a conclusão de mudanças comparáveis;
- duração da revisão;
- quantidade de componentes alterados;
- regressões associadas à mudança;
- retrabalho depois da entrega.

Refatorar também tem custo. Eu priorizaria áreas modificadas com frequência, responsáveis por incidentes ou que concentram atrasos recorrentes. Em componentes estáveis e pouco alterados, uma refatoração ampla pode não compensar o investimento.

  

### Coordenação em Tempo Real: Quando Testar Mob Programming

Mob Programming reúne várias pessoas para trabalhar simultaneamente no mesmo item. Essa configuração pode reduzir esperas por revisão, compartilhar contexto e antecipar discussões que ocorreriam depois da implementação.

Os [relatos da Hunter Industries](https://agilealliance.org/resources/experience-reports/growing-the-mob/) ajudam a entender como a prática foi adotada, mas não sustentam um ganho universal de três vezes na produtividade. O resultado depende do tipo de trabalho, da experiência da equipe e da forma como produtividade é medida.

Eu consideraria um experimento com prazo definido quando:

- o problema exige conhecimento de várias especialidades;
- decisões tardias teriam alto custo;
- revisões e transferências de contexto estão atrasando o fluxo;
- a equipe precisa distribuir conhecimento sobre uma área crítica.

Durante o experimento, compararia:

- tempo decorrido até a entrega;
- total de horas das pessoas envolvidas;
- tempo de espera por revisão ou decisão;
- defeitos e retrabalho depois da entrega;
- quantidade de pessoas capazes de manter a solução.

Uma redução no tempo de calendário não significa necessariamente aumento de produtividade, porque várias pessoas trabalharam juntas. Para decidir se a prática compensa, eu observaria o resultado entregue, o esforço total e o conhecimento distribuído.

Em tarefas rotineiras e independentes, manter toda a equipe no mesmo item pode custar mais do que os problemas de coordenação que se pretende resolver.

### Gargalos e qualidade: como avaliar o efeito

Defeitos, retrabalho, dependências e filas de validação podem consumir capacidade. Antes de intervir, identifique qual etapa limita o fluxo e estabeleça uma linha de base com:

- tempo de espera e tempo de execução em cada etapa;
- duração total do ciclo;
- defeitos e retrabalho;
- frequência de falhas depois da entrega;
- tempo necessário para recuperar o serviço.

Uma leitura complementar de [DORA e SPACE](https://www.gpupo.com/artigos/dora-e-spaceh-+eficacia-+maturidade-no-desenvolvimento-de-software/) ajuda a separar indicadores de entrega, estabilidade e experiência da equipe sem consolidá-los em uma nota única.

Reduzir uma fila não garante melhora no sistema inteiro. O gargalo pode migrar para outra etapa, e uma otimização local pode aumentar defeitos ou carga operacional. Compare os indicadores antes e depois da mudança durante um período definido.

Práticas de qualidade também têm custo. Testes, refatoração e coordenação adicional compensam quando reduzem falhas e retrabalho em valor superior ao esforço de adoção e manutenção. O efeito depende da frequência das mudanças, do risco do componente e da qualidade da implementação.

Portanto, velocidade e qualidade não formam uma equação universal. Para áreas alteradas com frequência ou associadas a incidentes relevantes, investir em qualidade pode melhorar a capacidade de entrega ao longo do tempo. Em áreas estáveis e de baixo risco, o mesmo investimento pode ter retorno menor.

A evidência apresentada neste artigo sustenta a realização de experimentos com métricas explícitas, não a garantia de que toda prática de qualidade acelerará qualquer equipe.
