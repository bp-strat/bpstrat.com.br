# Context Map Patterns

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/ddd/context-map-patterns.html

---

# Context Map Patterns: relações entre Bounded Contexts
{: .no_toc }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

Um Context Map descreve os Bounded Contexts relevantes e as relações entre seus modelos, equipes e responsabilidades. Ele não depende de microservices, mensageria ou processos separados.

Dois contextos podem estar no mesmo repositório e no mesmo processo. Também podem ser operados por organizações diferentes. A topologia de deploy informa onde o software executa; o Context Map informa onde modelos são válidos, quem influencia sua evolução e como diferenças semânticas são tratadas.

O primeiro objetivo é mapear a situação existente. Nomear um relacionamento não transforma a organização nem corrige uma integração; torna explícitas as condições que uma estratégia posterior precisará considerar.

## O que registrar no mapa

Para cada Bounded Context, identifique:

- nome e responsabilidade na linguagem do domínio;
- modelo e termos que lhe pertencem;
- equipe ou grupo responsável por decisões sobre o modelo;
- entradas, saídas e pontos de contato com outros contextos;
- hipóteses ou limites ainda incertos.

Para cada relação, registre:

- quais modelos entram em contato;
- se existe dependência upstream/downstream ou dependência mútua;
- quanto o downstream influencia o planejamento do upstream;
- onde ocorre tradução, compartilhamento ou conformidade de modelos;
- como o contrato é publicado e alterado;
- quais equipes coordenam mudanças, testes e releases;
- custo conhecido e risco aceito da relação.

Uma chamada HTTP, um evento ou uma tabela compartilhada demonstra contato técnico. Esses elementos não bastam para concluir que existe Partnership, Customer/Supplier, Conformist ou qualquer outro padrão.

## Direção upstream e downstream

Em uma relação upstream/downstream, mudanças e decisões do upstream afetam o sucesso do downstream de forma mais significativa do que o inverso. O upstream pode conseguir entregar seus objetivos mesmo que o downstream falhe; o downstream depende do que recebe do upstream.

Essa direção expressa influência sobre modelos e planejamento. Ela não é necessariamente a direção da requisição, do evento ou do fluxo de dados. Um contexto pode enviar uma requisição ao upstream e receber a resposta no sentido oposto sem deixar de ser downstream.

Quando os dois contextos precisam ser entregues para que ambos tenham sucesso, a dependência pode ser mútua. Quando o trabalho de um tem pouco efeito sobre o outro, eles podem estar livres para evoluir separadamente.

Use `U` para upstream e `D` para downstream somente depois de descrever a evidência dessa assimetria.

## Categorias de padrões

Os padrões respondem a perguntas diferentes e podem ser combinados na mesma relação:

| Categoria | Pergunta |
|---|---|
| Organização e coordenação | Como as equipes planejam e governam a dependência? |
| Compartilhamento e tradução | Os contextos compartilham, adotam ou traduzem modelos? |
| Publicação de contrato | Como uma capacidade ou linguagem de intercâmbio fica disponível aos consumidores? |
| Isolamento e legado | A integração deve existir? Há um limite de modelo que possa ser descrito? |

`Open Host Service` e `Published Language`, por exemplo, não substituem `Customer/Supplier`, `Conformist` ou `Anticorruption Layer`. Um descreve a oferta do upstream, outro o idioma de intercâmbio, e os demais descrevem coordenação ou tratamento do modelo no downstream.

## Organização e coordenação

### Partnership

**Condição:** os dois contextos possuem dependência mútua; uma falha de entrega ou de integração impede o sucesso de ambos.

**Evidência:** planejamento coordenado, evolução conjunta da interface, compromissos de release e testes de integração mantidos pelas duas equipes.

**Custo:** perda de autonomia de calendário, reuniões de coordenação e necessidade de resolver prioridades em conjunto.

Partnership não é apenas uma relação cordial. Sem dependência mútua e governança conjunta, o nome não descreve a relação observada.

### Shared Kernel — SK

**Condição:** dois contextos compartilham deliberadamente uma parte pequena e explicitamente delimitada do modelo, acompanhada do código ou desenho de persistência correspondente.

**Evidência:** ownership conjunto, mudanças feitas após consulta aos dois lados e integração frequente do kernel compartilhado.

**Custo:** coordenação de mudanças, compatibilidade, testes conjuntos e redução de autonomia. Quanto maior o kernel, maior o risco de os limites dos contextos perderem clareza.

Uma biblioteca técnica ou um banco acessado por dois sistemas não constitui Shared Kernel automaticamente. É necessário compartilhar uma parte reconhecida do modelo e governá-la como tal.

### Customer/Supplier — C/S

**Condição:** existe assimetria upstream/downstream, mas o downstream atua como cliente e suas necessidades entram no planejamento do upstream.

**Direção:** Supplier é `U`; Customer é `D`.

**Evidência:** compromissos negociados, orçamento ou capacidade reservada para demandas downstream, critérios de aceitação compartilhados e datas conhecidas.

**Custo:** o upstream cede parte da autonomia de priorização; o downstream precisa tornar suas necessidades testáveis e participar do planejamento.

Consumir uma API não torna o consumidor Customer nesse padrão. Sem influência verificável sobre prioridades e contrato, pode existir apenas uma dependência técnica.

## Compartilhamento e tradução de modelos

### Conformist — CF

**Condição:** o downstream possui pouca influência sobre o upstream e decide adotar seu modelo sem tradução relevante.

**Direção:** upstream `U` → downstream `D`.

**Evidência:** termos, estruturas e regras do upstream aparecem diretamente no modelo downstream; não existe uma camada responsável por preservar significados locais diferentes.

**Custo:** integração inicial menor, mas maior acoplamento semântico e menor liberdade para o downstream modelar suas próprias necessidades.

Conformist é uma decisão de aceitar o modelo upstream. Cumprir um contrato de API ou usar o mesmo formato de mensagem não prova conformidade se o downstream traduz esse contrato para seu próprio modelo.

### Anticorruption Layer — ACL

**Condição:** o downstream precisa integrar uma capacidade upstream, mas quer expressá-la em termos de seu próprio modelo.

**Direção:** a ACL pertence ao lado downstream e traduz em uma ou nas duas direções.

**Evidência:** adaptadores, tradutores ou fachadas com regras explícitas de correspondência; testes que protegem invariantes e vocabulário downstream; ownership definido para a tradução.

**Custo:** código adicional, tratamento de incompatibilidades, testes de contrato e manutenção sempre que um dos modelos mudar.

Antes de escolher uma ACL, avalie:

- O downstream possui invariantes e vocabulário próprios?
- Os conceitos do upstream conflitam com esse modelo?
- Os dados participam de decisões do domínio ou apenas de consultas e relatórios?
- As regras de tradução podem ser testadas e ter um responsável definido?
- A duração e o valor da integração justificam uma camada adicional?

Uma ACL não é obrigatória em toda integração. Para dados apenas expositivos, contratos estáveis ou relações de baixo valor, uma adaptação mais simples pode ser suficiente. Registre onde a tradução ocorre e quem assume seu custo.

## Publicação de contratos

### Open Host Service — OHS

**Condição:** um contexto upstream precisa oferecer um protocolo coerente para vários consumidores, evitando uma interface diferente para cada integração.

**Direção:** o contexto que publica o serviço é upstream dos clientes desse serviço.

**Evidência:** protocolo acessível aos consumidores previstos, política de evolução, documentação e tratamento separado para necessidades idiossincráticas que não devem deformar o contrato comum.

**Custo:** compatibilidade, suporte a consumidores, versionamento e governança do protocolo.

OHS não significa apenas “API pública”. É uma estratégia para manter uma oferta de integração coerente quando há vários consumidores. Um cliente do OHS ainda pode ser Conformist ou proteger seu modelo com uma ACL.

### Published Language — PL

**Condição:** contextos precisam de uma linguagem de intercâmbio documentada que expresse as informações compartilhadas sem transformar diretamente um dos modelos internos no contrato comum.

**Direção:** Published Language não define upstream/downstream por si só.

**Evidência:** vocabulário, semântica, schemas e regras de compatibilidade publicados; cada contexto sabe como traduzir entre seu modelo e essa linguagem.

**Custo:** documentação, versionamento, compatibilidade e traduções em cada participante.

Um JSON Schema ou arquivo OpenAPI documenta estrutura, mas só funciona como Published Language quando os significados também são estáveis e compreendidos. PL costuma acompanhar OHS, porém nenhum dos dois implica o outro.

## Isolamento e legado

### Separate Ways — SW

**Condição:** o valor da integração é menor que seu custo, ou as funcionalidades não possuem relação significativa.

**Direção:** não há relação de integração a classificar.

**Evidência:** decisão explícita de manter modelos e soluções independentes, incluindo a duplicação ou o processo manual aceito como consequência.

**Custo:** dados ou funcionalidades duplicados, experiência menos integrada e trabalho manual. Esses custos precisam ser menores que os custos e riscos da integração evitada.

Separate Ways não é recomendação automática para MVP. É uma decisão econômica e semântica que deve declarar o que deixa de ser integrado.

### Big Ball of Mud — BBoM

**Condição:** uma parte do sistema mistura modelos e possui limites inconsistentes, tornando regras e conceitos ambíguos.

**Evidência:** vocabulários conflitantes no mesmo espaço, dependências cruzadas e ausência de ownership ou fronteiras que possam ser descritas de maneira confiável.

**Custo:** mudanças difíceis de prever, propagação de conceitos inconsistentes e integração defensiva nos contextos vizinhos.

Big Ball of Mud caracteriza um limite existente; não é um estilo desejado de relacionamento. Delimite a área para evitar que suas inconsistências se espalhem. Uma ACL pode proteger um downstream com modelo próprio quando a tradução justificar o custo, mas não é obrigatória para toda leitura ou integração.

## Exemplo hipotético: Pricing e Ordering

O cenário abaixo é didático e declara as informações necessárias para reconhecer os padrões. Ele não descreve um sistema observado.

### Modelos e responsabilidades

- **Pricing Context:** decide regras de preço e possui os conceitos `PriceRule`, `PriceQuote` e `ValidityWindow`.
- **Ordering Context:** aceita pedidos e possui `Order`, `OrderLine` e `AgreedPrice`.
- Uma mudança em `PriceQuote` pode impedir Ordering de confirmar pedidos; Pricing consegue cumprir seus outros objetivos sem uma release de Ordering. Portanto, Pricing é `U` e Ordering é `D` neste relacionamento.
- A equipe de Ordering negocia requisitos e testes de aceitação que entram no planejamento de Pricing.
- Pricing publica o contrato versionado `PriceQuote v1`, com significado, schema e política de compatibilidade documentados.
- Ordering traduz `PriceQuote` para `AgreedPrice` e valida expiração sem incorporar `PriceRule` ao seu modelo.

### Relação resultante

```text
Pricing [U, Supplier] — PriceQuote v1 [PL] → [ACL] Ordering [D, Customer]
```

As evidências sustentam:

- **Customer/Supplier:** Ordering influencia o planejamento de Pricing por compromissos e testes negociados;
- **Published Language:** `PriceQuote v1` possui semântica e compatibilidade publicadas;
- **Anticorruption Layer:** Ordering traduz o contrato para seu próprio conceito `AgreedPrice`.

O cenário não sustenta Conformist porque existe tradução e um modelo downstream próprio. Também não sustenta OHS: há somente um consumidor descrito e nenhuma evidência de um protocolo projetado para vários clientes.

Se os dois contextos estivessem no mesmo processo, essas relações continuariam possíveis. A diferença seria o mecanismo técnico de comunicação, não a semântica nem a influência organizacional.

## C4 como visualização complementar

Um diagrama C4 pode mostrar software systems, containers, componentes e suas comunicações. Ele não demonstra, sozinho, Bounded Contexts ou padrões de Context Map.

Ao usar C4 junto do Context Map:

- documente como cada Bounded Context corresponde aos elementos C4, sem presumir equivalência;
- mantenha upstream/downstream separado da direção das setas de runtime;
- não atribua OHS, CF, PL ou ACL apenas pela existência de uma API ou evento;
- use o Context Map como fonte da relação semântica e o C4 como visão da estrutura de software;
- siga a [convenção C4 em Mermaid](/docs/metodologia/c4model/c4-mermaid.html) para preservar o escopo de cada diagrama.

Se uma anotação do padrão for adicionada ao C4, ela deve apontar para a relação já documentada. A anotação não substitui as evidências, a direção e os custos registrados no Context Map.

## Registro da relação

Use um registro curto para impedir que o nome do padrão substitua a análise:

```yaml
contexts:
  upstream:
  downstream:
models_in_contact:
organizational_dependency:
planning_influence:
translation_or_sharing:
published_contract:
patterns:
evidence:
costs:
risks:
owners:
open_questions:
review_signals:
```

Se upstream/downstream não se aplicar, registre a dependência como mútua, livre ou ainda desconhecida. Um mapa honesto pode conter relações sem classificação enquanto faltarem evidências.

## Checklist de revisão

1. Os Bounded Contexts e seus modelos estão nomeados?
2. A topologia de deploy foi tratada separadamente?
3. A direção `U/D` deriva de influência e dependência, não da seta técnica?
4. Padrões organizacionais estão apoiados por práticas reais de coordenação?
5. Compartilhamento, conformidade e tradução possuem ownership definido?
6. O contrato publicado inclui semântica, evolução e compatibilidade?
7. Os custos e riscos da relação estão registrados?
8. Algum padrão foi inferido apenas de API, evento, banco ou biblioteca?
9. O mapa descreve a situação atual antes de propor a situação desejada?
10. Hipóteses e relações ainda desconhecidas permanecem visíveis?

## Referências

- [Eric Evans: Domain-Driven Design Reference — Context Mapping](https://www.domainlanguage.com/ddd/reference/)
- [DDD Crew: Context Mapping](https://github.com/ddd-crew/ddd-starter-modelling-process)
- [C4 Model: abstrações](https://c4model.com/abstractions)
