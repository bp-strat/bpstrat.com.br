# Inteligência Artificial no Combate à Fraude, Uma Oportunidade Ainda Pouco Explorada

Published: 2024-05-16
Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/post/ia-no-combate-fraude-uma-oportunidade-pouco-explorada/

---

Em uma [pesquisa realizada no fim de 2023](https://www.sas.com/pt_br/news/press-releases/2024/february/pesquisa-antifraude-ia-generativa.html) com aproximadamente 1.200 membros da Association of Certified Fraud Examiners, 18% dos respondentes disseram que suas organizações utilizavam inteligência artificial ou machine learning em iniciativas antifraude. Outros 32% declararam que pretendiam adotar essas tecnologias nos dois anos seguintes. Na América Latina, a intenção declarada de adoção chegou a 46%.

A mesma pesquisa registrou que 83% dos profissionais consultados esperavam incorporar inteligência artificial generativa às iniciativas antifraude. Esses percentuais medem uso declarado e intenção de adoção. Eles não demonstram que a tecnologia foi implementada nem que melhorou a detecção de fraude.

Uma [nova edição da pesquisa, publicada em 2026](https://cms.acfe.com/about-the-acfe/newsroom-for-media/press-releases/press-release-detail?s=2026-anti-fraud-technology-benchmarking-report-pr), registrou uso de IA ou ML por 25% das organizações representadas pelos respondentes. Minha interpretação é que o interesse cresceu mais rapidamente que a implementação. Como as duas edições utilizaram amostras diferentes, essa comparação indica uma tendência, mas não permite acompanhar as mesmas organizações ao longo do período.

Os levantamentos também não sustentam promessas de maior precisão, análise em milésimos de segundo ou redução de perdas. Esses resultados dependem dos dados, do modelo, do limite de falsos positivos e da capacidade operacional de cada organização. É nesse nível que um projeto antifraude precisa ser avaliado.

Antes de escolher o modelo ou a infraestrutura, [formular o problema de produto para machine learning](https://www.gpupo.com/artigos/gestao-de-produto-e-machine-learningh-uma-combinacao-poderosa-para-impulsionar-o-futuro-das-empresas/) ajuda a explicitar a decisão apoiada, a linha de base e os custos de falsos positivos e negativos.

### Hipótese de Sistema para Fraude em Seguros de Saúde

A hipótese é usar dados históricos de solicitações de reembolso para priorizar casos que precisam de revisão. O modelo não determinaria sozinho se houve fraude. Ele atribuiria um indicador de risco para apoiar a análise humana.

#### Fluxo a ser testado

1. identificar solicitações anteriores com resultado conhecido;
2. selecionar apenas informações disponíveis no momento da análise;
3. estabelecer o processo atual como linha de base;
4. treinar um modelo inicial e comparar seus alertas com essa linha de base;
5. encaminhar casos de maior risco para revisão;
6. registrar o resultado da revisão para avaliar e ajustar o modelo.

#### Condições para o experimento

Antes da implementação, seria necessário verificar:

- qualidade e representatividade dos dados históricos;
- critérios usados para confirmar uma fraude;
- impacto de falsos positivos sobre segurados e analistas;
- capacidade da equipe para revisar os alertas;
- controles de acesso às informações;
- mudanças de comportamento que possam degradar o modelo.

Python e Scikit-Learn podem ser avaliados durante a prototipação, mas a escolha da infraestrutura depende do volume de dados, dos requisitos de segurança e da capacidade operacional da equipe. O uso de uma plataforma de nuvem, por si só, não garante robustez nem segurança.

#### Critério de Validação

Sem um conjunto de dados identificado, uma linha de base e um experimento controlado, não é possível estimar quanto esse sistema reduziria as fraudes.

Eu avaliaria o projeto comparando o processo atual com o modelo proposto. A validação deveria registrar:

- fraudes detectadas antes e depois;
- precisão e recall do modelo;
- falsos positivos enviados para análise;
- custo da revisão manual;
- perdas evitadas no período;
- comportamento do modelo diante de novos padrões de fraude.

O sistema só deveria avançar para produção se melhorar a detecção sem criar um volume de revisões incompatível com a capacidade operacional da seguradora.
