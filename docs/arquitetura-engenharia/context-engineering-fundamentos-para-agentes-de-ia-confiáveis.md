# Context Engineering

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/arquitetura-engenharia/context-engineering-fundamentos-para-agentes-de-ia-confi%C3%A1veis.html

---

# Context Engineering: fundamentos para agentes de IA confiáveis
{: .no_toc }


## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

Ao colocar um agente em produção, o contexto passa a incluir mais que o prompt: instruções, histórico, resultados de ferramentas, documentos recuperados, memória e estado do fluxo. [Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) é o trabalho de decidir quais dessas informações entram na janela do modelo, em qual formato e em qual momento.

Um contexto melhor pode aumentar a chance de uma resposta útil, mas não garante precisão. O resultado também depende do modelo, das ferramentas, da qualidade das fontes, das permissões e da forma como o sistema valida a saída.

## O que precisa ser administrado

Em um agente, eu trataria como contexto:

- instruções do sistema e do usuário;
- descrições e resultados de ferramentas;
- documentos recuperados;
- histórico da interação;
- memória persistente;
- estado atual da tarefa;
- limites, permissões e critérios de conclusão.

O objetivo não é fornecer o máximo de informação possível. É disponibilizar o conjunto necessário para a tarefa sem esconder instruções importantes em conteúdo irrelevante.

## Falhas que o Context Engineering precisa considerar

Uma estratégia de contexto pode falhar quando:

- a busca não recupera o documento necessário;
- a fonte está desatualizada ou incorreta;
- instruções entram em conflito;
- um resumo remove uma exceção importante;
- informações antigas permanecem na memória;
- conteúdo não confiável é tratado como instrução;
- o volume de contexto reduz a atenção sobre os dados relevantes.

Essas falhas não são resolvidas apenas aumentando a janela do modelo. Cada mecanismo de seleção, recuperação ou compressão precisa ser testado para o fluxo em que será utilizado.

## Técnicas a avaliar

Dependendo da tarefa, eu compararia:

- recuperação de documentos no momento da execução;
- carregamento sob demanda por meio de ferramentas;
- estado estruturado para decisões e resultados;
- resumos incrementais;
- separação entre memória da sessão e memória persistente;
- remoção ou compactação de histórico antigo.

Nenhuma técnica deve ser adotada apenas por reduzir tokens. A economia precisa ser comparada com omissões, respostas sem fundamento, latência e custo operacional.

## Exemplo: resumo de atendimentos longos

Em uma conversa extensa, enviar todo o histórico pode aumentar custo e dificultar o uso das informações relevantes. Um resumo incremental é uma alternativa, mas cria outro risco: decisões, exceções ou compromissos podem desaparecer durante sucessivas atualizações.

Eu compararia pelo menos três configurações:

1. histórico completo;
2. janela recente sem resumo;
3. resumo estruturado acompanhado das mensagens mais recentes.

A avaliação deveria registrar:

- respostas corretas para perguntas sobre decisões anteriores;
- restrições omitidas;
- afirmações sem apoio no histórico;
- tokens consumidos;
- latência;
- falhas que exigiram recuperação manual do histórico.

O resumo só deveria substituir parte do histórico se reduzir custo ou latência sem ultrapassar o limite de omissões aceito para o atendimento.

O [contexto suficiente](https://research.google/blog/deeper-insights-into-retrieval-augmented-generation-the-role-of-sufficient-context/) pode melhorar o resultado, mas Context Engineering não torna o agente confiável por si só. Em produção, ele precisa ser combinado com avaliações, controle de permissões, validação das ações e uma forma segura de interromper ou encaminhar casos que o sistema não consegue resolver.
