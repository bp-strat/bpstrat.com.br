# Mermaid C4

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/metodologia/c4model/c4-mermaid.html

---

# Convenção para diagramas C4 em Mermaid
{: .no_toc }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

Esta convenção define como os documentos deste site representam o modelo C4 com Mermaid. A ordem das decisões importa: primeiro se escolhem o tipo, o escopo e as abstrações do diagrama; depois se selecionam as macros que conseguem expressar esse modelo.

A existência de uma macro como `ContainerQueue` ou `Container_Boundary` não demonstra que o elemento seja um container nem que o agrupamento represente um Bounded Context. A classificação precisa vir da arquitetura descrita.

## Estado da sintaxe Mermaid

A documentação do Mermaid classifica os diagramas C4 como experimentais. A sintaxe e as propriedades podem mudar, e alguns recursos compatíveis com C4-PlantUML ainda não estão disponíveis.

Por isso, um diagrama deve continuar compreensível sem depender de cor, posição ou recurso experimental específico. Nos projetos que renderizam Mermaid durante o build, registre a versão do renderizador e revise os diagramas antes de atualizá-la.

Esta página separa duas categorias:

- **regra do modelo:** escopo, abstração, responsabilidade e significado das relações;
- **decisão da ferramenta:** macro, ordem das declarações, direção visual e ajuste de layout.

Quando o Mermaid não conseguir expressar o modelo sem ambiguidade, preserve o modelo e use outra notação. Não altere a arquitetura descrita apenas para acomodar uma macro.

## Tipos de diagrama

Context, Container e Component são níveis de zoom da estrutura estática. Dynamic e Deployment são diagramas de apoio; não são níveis mais profundos da mesma sequência.

| Tipo | Declaração Mermaid | Escopo | Elementos principais | Elementos de apoio |
|---|---|---|---|---|
| System Context | `C4Context` | Um software system | O sistema em foco | Pessoas e sistemas diretamente relacionados |
| Container | `C4Container` | Um software system | Aplicações e data stores internos ao sistema | Pessoas e sistemas conectados aos containers |
| Component | `C4Component` | Um único container | Componentes internos ao container em foco | Containers, pessoas e sistemas diretamente relacionados |
| Dynamic | `C4Dynamic` | Um caso de uso, história ou fluxo | Interações em uma abstração escolhida | Apenas elementos necessários para explicar o comportamento |
| Deployment | `C4Deployment` | Um ambiente de implantação | Nós de implantação e instâncias de sistemas ou containers | Infraestrutura necessária ao ambiente |

O diagrama de código, quarto nível estrutural do C4, não possui um tipo próprio entre os cinco diagramas C4 documentados pelo Mermaid. Quando esse detalhe for necessário, use uma notação adequada ao código, como um diagrama de classes ou de entidades.

### System Context

O System Context mostra o sistema em foco como uma unidade. Tecnologias, protocolos, bancos e componentes internos normalmente não pertencem a esse diagrama.

Use:

- `Person` ou `Person_Ext` para pessoas, papéis e personas;
- `System` para o software system em foco;
- `System_Ext` para sistemas fora de seu escopo ou ownership.

Não use `C4Context` como sinônimo automático de visão de negócio ou ecossistema. Um mapa com vários sistemas de uma organização é um **System Landscape**. O Mermaid não oferece uma declaração `C4Landscape`; se `C4Context` for usado como limitação de renderização, o título deve identificar explicitamente o diagrama como System Landscape.

### Container

O Container Diagram abre um único software system e mostra suas aplicações e data stores. No C4, container não significa necessariamente container Docker: é uma fronteira de execução ou armazenamento, como API, aplicação web, Worker, função, schema de banco ou bucket controlado pelo sistema.

Use `System_Boundary` para delimitar o software system em foco. Dentro dele, use `Container`, `ContainerDb` ou `ContainerQueue` somente para unidades compatíveis com essa definição.

Pacotes, camadas, aggregates, services e repositories internos ao mesmo processo não se tornam containers por aparecerem em caixas separadas. Eles podem ser componentes ou detalhes de código.

### Component

O Component Diagram abre um único container. Use `Container_Boundary` para deixar esse escopo visível e coloque dentro dele somente componentes pertencentes ao container em foco.

Outros containers podem aparecer como elementos de apoio, mas não devem ser decompostos no mesmo diagrama. Se API e Worker precisarem de detalhes internos, crie um Component Diagram para cada um.

Um componente é um agrupamento de funcionalidade encapsulado por uma interface. Ele não é uma unidade de deploy independente no modelo C4. Caso seja executado e implantado separadamente, reavalie se o elemento é um container.

### Dynamic

O Dynamic Diagram explica como elementos colaboram em runtime para realizar um comportamento específico. Antes de desenhá-lo, escolha se a interação principal ocorrerá entre sistemas, containers ou componentes e mantenha essa abstração consistente.

Use `RelIndex` para indicar a ordem das interações. Na implementação atual do Mermaid, o parâmetro numérico informado a `RelIndex` é ignorado e a sequência é calculada pela ordem das declarações. Portanto, mantenha as relações no arquivo na mesma ordem em que devem ser lidas.

Um Dynamic Diagram não substitui o diagrama estrutural que define os elementos. Ele mostra uma instância de colaboração entre elementos já classificados.

### Deployment

O Deployment Diagram mostra como instâncias de software systems e containers são executadas em um ambiente específico, como produção ou homologação.

Use `Deployment_Node` para infraestrutura física, virtualizada, conteinerizada ou para um ambiente de execução. Informe o ambiente no título e não misture configurações de produção e desenvolvimento no mesmo diagrama.

A topologia de deploy não deve ser inferida de um Container Diagram. Réplicas, clusters, balanceadores, regiões e failover pertencem ao Deployment Diagram quando forem relevantes e conhecidos.

Se a versão do renderizador não oferecer uma forma clara de mostrar as instâncias dentro dos nós, use outra notação. Um conjunto de nós sem as instâncias implantadas não cumpre sozinho o propósito de um Deployment Diagram C4.

## Boundaries compatíveis com o escopo

Uma boundary comunica ownership ou escopo. Ela não serve apenas para aproximar caixas visualmente.

| Boundary | Uso nesta convenção | Evitar |
|---|---|---|
| `Enterprise_Boundary` | Delimitar uma organização em um System Landscape quando essa fronteira for relevante | Cercar automaticamente todo System Context |
| `System_Boundary` | Delimitar os containers do único software system em foco | Agrupar componentes, camadas ou Bounded Contexts sem correspondência demonstrada |
| `Container_Boundary` | Delimitar os componentes do único container em foco | Representar qualquer agrupamento lógico ou vários containers simultaneamente |
| `Boundary` | Agrupamento excepcional, identificado no título ou na legenda textual | Criar um novo nível de abstração sem definição |

Um diagrama pode incluir elementos de apoio de outra abstração. Por exemplo, um Container Diagram inclui pessoas e sistemas, e um Component Diagram pode incluir containers vizinhos. Isso não é mistura indevida quando existe um único escopo principal e apenas os elementos desse escopo são decompostos.

## Bounded Context não é elemento C4

Bounded Context pertence ao Domain-Driven Design: ele delimita onde um modelo é definido e aplicável. Software system, container e component são abstrações do C4. Não existe correspondência obrigatória entre esses conceitos.

Conforme o sistema observado, um Bounded Context pode:

- coincidir com um software system;
- ser implementado por um ou mais containers;
- ocupar parte de um container compartilhado;
- mudar de correspondência durante uma migração.

Antes de representar essa relação, documente qual dessas situações foi observada ou assumida. Não declare que “Bounded Context é `Container_Boundary`”.

Quando o objetivo for mostrar relações estratégicas entre Bounded Contexts, use um Context Map separado. Se um diagrama C4 também precisar evidenciar essa informação, trate-a como uma anotação ou agrupamento complementar, explique a convenção ao lado do diagrama e preserve os tipos C4 de cada elemento.

## Filas, tópicos e brokers

O sufixo `Queue` do Mermaid muda a forma visual, mas não cria uma nova abstração no C4. Primeiro determine o papel e o ownership do elemento.

| Situação observada | Representação recomendada |
|---|---|
| Plataforma de mensageria independente, vista de fora do sistema | `SystemQueue` ou `SystemQueue_Ext` no nível de sistemas |
| Fila, tópico ou data store controlado pelo sistema e relevante em runtime | `ContainerQueue` dentro do `System_Boundary` |
| Container de mensageria vizinho ao container aberto no Component Diagram | `ContainerQueue` como elemento de apoio, fora do `Container_Boundary` em foco |
| Elemento interno que satisfaz a definição de componente e possui semântica de canal | `ComponentQueue` apenas quando a forma de fila acrescentar informação relevante |
| Buffer em memória, client library, mecanismo de retry ou outro detalhe local | Omitir do C4 ou representar em um diagrama de código específico |
| Serviço administrado por terceiro ou por outra equipe | Representar conforme a fronteira de ownership, normalmente como sistema externo |

Não use `ContainerDb` como substituto genérico de uma fila apenas porque ambos armazenam dados. Também não transforme cada tópico em container sem demonstrar que ele é uma unidade arquitetural relevante para o escopo.

Broker, fila e tópico não são necessariamente o mesmo elemento. Mostre-os separadamente apenas quando essa distinção afetar ownership, operação, segurança, disponibilidade ou relações relevantes. Caso contrário, escolha o nível de detalhe necessário para a decisão documentada.

### Direção dos eventos

Nesta convenção, setas de mensageria representam **fluxo de dados**:

- produtor → canal: “Publica `PedidoCriado`”;
- canal → consumidor: “Entrega `PedidoCriado`” ou “Disponibiliza `PedidoCriado`”.

Se o objetivo for representar dependência de assinatura, use consumidor → canal com uma ação como “Assina `PedidoCriado`” e declare essa semântica no texto. Não misture fluxo de dados e dependência de assinatura no mesmo diagrama sem explicação.

O nome da mensagem comunica melhor a intenção do que o nome do produto. Informe Kafka, AMQP, HTTPS ou outra tecnologia no campo de tecnologia ou protocolo somente quando esse dado for conhecido e relevante.

## Nomenclatura e relacionamentos

Todo diagrama deve ter um título com tipo e escopo, por exemplo: “Container Diagram do Sistema de Shipping”.

Para os elementos:

- use nomes reconhecíveis no domínio;
- identifique o tipo C4 de cada elemento;
- descreva a responsabilidade em uma ou duas frases curtas;
- informe tecnologia para containers e componentes quando ela for conhecida;
- não invente tecnologia para preencher o campo.

Para os relacionamentos:

- use uma seta unidirecional por relação;
- escreva a ação de acordo com a direção da seta;
- prefira verbos específicos, como “Consulta saldo” ou “Publica `PedidoCriado`”, em vez de “Usa”;
- informe protocolo ou tecnologia nas relações entre containers quando conhecido;
- use `Rel` como padrão.

As variantes `Rel_D`, `Rel_U`, `Rel_L` e `Rel_R` podem melhorar a disposição visual. O sufixo indica uma preferência de layout e não muda o significado arquitetural da relação. Se a direção visual exigir uma seta semanticamente errada, mantenha a semântica e aceite outro layout.

Evite `BiRel`. Duas relações unidirecionais, cada uma com seu propósito, deixam dependências e fluxos mais claros.

## Limitações operacionais do Mermaid

Na documentação consultada, a implementação C4 do Mermaid possui limitações relevantes:

- a sintaxe permanece experimental;
- o layout não é totalmente automático e depende da ordem das declarações;
- comandos `Layout_*` de C4-PlantUML não são suportados;
- legendas, tags, links e alguns recursos de estilo ainda não estão completos;
- `RelIndex` usa a ordem das relações, não o índice fornecido.

Quando uma legenda for necessária, inclua uma explicação textual próxima ao diagrama. Não simule tipos arquiteturais diferentes apenas com cores, pois o significado pode desaparecer em outro tema, impressão ou renderizador.

## Checklist de revisão

Antes de publicar, confirme:

1. O título identifica o tipo e o escopo?
2. Existe um único sistema ou container sendo decomposto?
3. Cada elemento corresponde à abstração C4 declarada?
4. Boundaries representam escopo ou ownership conhecido?
5. Algum Bounded Context foi convertido automaticamente em elemento C4?
6. Filas e tópicos foram classificados por papel e ownership antes da escolha da macro?
7. As setas e seus rótulos expressam a mesma direção?
8. Tecnologias e protocolos apresentados são conhecidos, não presumidos?
9. Hipóteses e arquitetura ilustrativa estão identificadas?
10. O diagrama continua compreensível apesar das limitações do Mermaid?

## Referências

- [C4 Model: abstrações](https://c4model.com/abstractions)
- [C4 Model: tipos de diagrama](https://c4model.com/diagrams)
- [C4 Model: notação](https://c4model.com/diagrams/notation)
- [C4 Model: checklist de revisão](https://c4model.com/diagrams/checklist)
- [Domain-Driven Design Reference: Bounded Context](https://www.domainlanguage.com/ddd/reference/)
- [Mermaid: diagramas C4](https://mermaid.js.org/syntax/c4.html)
