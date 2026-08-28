# CoALA como Referência para Arquiteturas de Agentes

Published: 2024-10-21
Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/post/cognitive-architecture-md/
Tags: IA, Arquitetura

---

Agentes de linguagem combinam modelos de linguagem com recursos externos, memória, ferramentas e fluxos de controle. Essas combinações criam novas possibilidades de automação, mas também introduzem riscos de respostas incorretas, ações indevidas e uso inadequado de dados.

O artigo **Cognitive Architectures for Language Agents (CoALA)** propõe um framework conceitual para organizar esses sistemas. Ele descreve componentes modulares de memória, um espaço estruturado de ações e um processo de decisão. CoALA não é uma implementação pronta e não demonstra que agentes imitem processos humanos.

![Ilustração sobre arquitetura cognitiva e aplicações corporativas com IA](/assets/2aadd08ba3a0efe1c332f164d88135fc_MD5.jpg)

Usar essa estrutura pode ajudar uma equipe a explicitar onde o agente obtém informações, quais ações pode executar e como decide o próximo passo. O valor empresarial, porém, depende da implementação, das permissões, da qualidade dos dados e dos resultados observados em um caso de uso delimitado.

Uma decomposição mais simples em modelo, estado, ferramentas e limites aparece em [Além dos copilotos: como pensar em agentes de IA](https://www.gpupo.com/posts/agentes-de-ia-alem-dos-copilotos/).

## Hipótese de arquitetura inspirada em CoALA

CoALA pode servir como referência conceitual para decompor um agente de atendimento em memória, ações e processo de decisão. Isso não fornece essas capacidades automaticamente: cada componente precisa ser implementado, restringido e avaliado.

Em um experimento de atendimento multicanal, a arquitetura poderia incluir:

1. **Memória de trabalho:** mantém apenas as informações necessárias para a interação atual.
2. **Memória de longo prazo:** recupera dados autorizados do cliente e registros anteriores. Persistência não significa aprendizado automático; atualização, retenção e exclusão precisam de regras explícitas.
3. **Ações externas:** consulta pedidos e bases de conhecimento. Operações que alteram estado, como aprovar uma devolução, exigem autorização, validação das regras de negócio e, nos casos de maior risco, revisão humana.
4. **Processo de decisão:** seleciona entre responder, consultar uma ferramenta, solicitar informações ou encaminhar o atendimento. As decisões e suas fontes devem ser registradas para auditoria.

Multimodalidade, continuidade entre canais e adaptação do estilo são capacidades adicionais, não consequências de adotar CoALA.

Antes de ampliar o uso, compare o experimento com o fluxo atual usando:

- taxa de resolução corretamente auditada;
- encaminhamentos necessários e indevidos;
- ações incorretas ou não autorizadas;
- satisfação do cliente;
- latência e custo por atendimento;
- incidentes de privacidade e segurança.

Os benefícios permanecem como hipóteses até que esses resultados sejam medidos. O experimento deve começar com ações reversíveis, permissões mínimas e critérios de interrupção definidos.
