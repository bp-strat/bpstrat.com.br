# RAG: Quando a Recuperação Externa Ajuda um LLM

Published: 2024-05-15
Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/post/rag-md/
Tags: IA, Agents

---

Um modelo de linguagem pode responder com base apenas nos padrões aprendidos durante o treinamento, mesmo quando a aplicação exige informações privadas, recentes ou específicas de um domínio. RAG, sigla de **Retrieval-Augmented Generation**, adiciona uma etapa de recuperação para fornecer fontes externas ao modelo no momento da resposta.

## Como funciona

Um fluxo básico recebe a pergunta, procura trechos relevantes em um conjunto de documentos e inclui os resultados no contexto enviado ao modelo. O modelo gera a resposta a partir da pergunta e do material recuperado. A consulta pode ser transformada antes da busca, mas isso não é obrigatório.

O [artigo que introduziu RAG](https://papers.nips.cc/paper_files/paper/2020/hash/6b493230205f780e1bc26945df7481e5-Abstract.html) avaliou uma combinação de recuperação densa e geração em tarefas específicas intensivas em conhecimento. Esses resultados não demonstram que qualquer implementação de RAG produzirá respostas corretas.

## Quando eu consideraria RAG

RAG é uma opção quando a resposta depende de um corpus que muda com frequência, não faz parte do treinamento do modelo ou precisa ser limitado pelas permissões do usuário. Exemplos incluem políticas internas, documentação técnica e catálogos de produtos.

Um experimento com [LLM local para descrição de produto](https://www.gpupo.com/lessons/uso-de-um-llm-pequeno-para-melhoria-de-descricao-de-produto/) mostra também um contraexemplo: RAG havia sido considerado, mas os fatos necessários já estavam no prompt e o problema estava na forma de validar a saída.

Eu compararia essa opção com alternativas mais simples:

- busca tradicional, quando o usuário pode avaliar diretamente os documentos;
- consulta estruturada a uma API ou banco de dados, quando a resposta exige valores exatos;
- contexto fixo, quando o conjunto de instruções é pequeno e estável;
- ajuste do modelo, quando o objetivo é alterar comportamento recorrente, não recuperar fatos.

## Onde tende a falhar

Adicionar documentos ao contexto não os torna verdadeiros nem garante que o modelo os utilizará corretamente. Os principais pontos de falha são:

- a busca não recuperar a fonte necessária;
- a divisão dos documentos remover contexto importante;
- fontes desatualizadas ou contraditórias ocuparem as primeiras posições;
- o usuário receber conteúdo ao qual não deveria ter acesso;
- instruções maliciosas em documentos influenciarem o modelo;
- a resposta incluir afirmações que não aparecem nas fontes recuperadas;
- recuperação e geração aumentarem latência e custo.

## Como avaliar

Eu avaliaria recuperação e geração separadamente. Para a recuperação, observaria se as fontes necessárias aparecem entre os primeiros resultados. Para a resposta, verificaria correção, cobertura pelas fontes, citações, abstenção quando falta evidência, latência e custo.

O teste deve usar perguntas representativas e fontes esperadas definidas antes da execução. Compare pelo menos uma versão sem RAG, uma busca simples e a arquitetura proposta. Se o sistema executar ações ou tratar dados sensíveis, inclua testes de autorização, conteúdo adversarial e encaminhamento para revisão humana.

RAG faz sentido quando a recuperação melhora um resultado medido o suficiente para compensar sua complexidade. Sem essa comparação, ele permanece uma hipótese de arquitetura.
