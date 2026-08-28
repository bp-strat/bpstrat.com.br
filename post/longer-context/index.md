# Contextos Longos em LLMs: Capacidade não é Uso Efetivo

Published: 2024-05-15
Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/post/longer-context/
Tags: IA

---

A janela de contexto define quanto conteúdo tokenizado um modelo pode receber durante uma execução. Uma janela maior permite enviar documentos ou históricos mais extensos, mas não demonstra que o modelo localizará e usará corretamente todas as informações presentes.

## O que muda com uma janela maior

Informações que excedem a janela precisam ser removidas, resumidas ou recuperadas por outro mecanismo. Quando cabem na janela, ficam disponíveis ao modelo durante aquela execução. Isso não equivale a memória persistente: lembrar informações entre sessões exige armazenamento e recuperação externos.

Uma janela maior pode ser útil para analisar um documento completo, comparar vários textos, manter uma conversa extensa ou trabalhar com uma base de código. O benefício depende da tarefa, da distribuição da informação relevante e da capacidade efetiva do modelo.

## Limite declarado e capacidade efetiva

O estudo [Lost in the Middle](https://direct.mit.edu/tacl/article/doi/10.1162/tacl_a_00638/119630/Lost-in-the-Middle-How-Language-Models-Use-Long) avaliou modelos em perguntas sobre vários documentos e recuperação de pares chave-valor. Nos modelos e tarefas estudados, o desempenho variou conforme a posição da informação: foi frequentemente melhor no início ou no fim e pior quando o conteúdo relevante estava no meio.

Esse resultado não deve ser transferido automaticamente para todo modelo atual, mas demonstra por que o tamanho máximo anunciado não basta como critério de escolha. A aplicação precisa testar a tarefa real nas posições e extensões relevantes.

## Custos e alternativas

Enviar mais tokens pode aumentar latência, custo e uso de memória. Conteúdo irrelevante também pode competir com as instruções e evidências necessárias. Além disso, incluir documentos completos amplia a quantidade de dados exposta ao provedor ou ao ambiente de inferência.

Uma análise complementar sobre [a janela de contexto como variável de custo](https://www.gpupo.com/posts/custo-da-janela-de-contexto/) mostra quais medidas ajudam a tornar esse consumo visível em um fluxo de trabalho.

Antes de usar todo o contexto disponível, eu compararia:

- contexto completo;
- recuperação dos trechos mais relevantes;
- resumo estruturado;
- uma combinação de recuperação e contexto longo.

A melhor opção depende de quanto material precisa ser relacionado, da precisão exigida, das permissões dos dados e do custo aceitável.

## Como avaliar

Monte um conjunto de casos representativos e varie deliberadamente o tamanho do conteúdo e a posição da evidência. Meça:

- respostas corretas e sustentadas pelo texto;
- informações relevantes omitidas;
- afirmações sem suporte;
- latência;
- quantidade de tokens e custo;
- comportamento quando a entrada excede o limite.

Eu escolheria uma janela maior somente quando ela superar alternativas mais simples nessa comparação. Capacidade nominal é um limite de entrada; utilidade depende do desempenho observado na tarefa.
