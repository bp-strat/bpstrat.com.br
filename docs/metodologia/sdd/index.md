# SDD

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/metodologia/sdd/

---

# Spec-Driven Development
{: .no_toc }

Este material propõe um modelo de Spec-Driven Development no qual agentes de IA executam parte da codificação, enquanto pessoas definem intenção, restrições, critérios de aceitação e limites operacionais. A proposta mantém práticas de engenharia como revisão, testes, rastreabilidade e responsabilidade pela operação.

Agentes capazes de ler o repositório, executar comandos e alterar arquivos ampliam o trabalho que pode ser delegado. Esse acesso também aumenta o impacto de uma instrução incorreta ou de uma permissão excessiva. Por isso, autonomia deve ser delimitada pelo risco da tarefa e acompanhada de validação.

![](/assets/slides-assets/sdd-header.png){: .rounded }

Neste modelo, a **IA agentic** é tratada operacionalmente como um participante do fluxo, não apenas como autocomplete. A metáfora de “membro da equipe” significa que o agente recebe um escopo, produz artefatos e devolve resultados para revisão; não significa transferir a ele responsabilidade técnica ou de negócio.


Um agente pode receber uma solicitação de funcionalidade, trabalhar sobre o repositório e apresentar uma implementação. O resultado ainda pode estar incompleto, divergir dos requisitos ou introduzir riscos. O fluxo precisa definir o que o agente pode alterar, quais verificações deve executar, quem revisa e quais condições impedem o merge.

![](/assets/eb4e62cfb18c3fe2d5268652abc54be9_MD5.png){: .rounded }
**VS**

![](/assets/slides-assets/vibecoding-aleatory.png){: .rounded }

Quando documentos de especificação são descartados ou deixam de acompanhar as mudanças, o código e o comportamento em produção passam a ser as evidências mais confiáveis sobre o sistema. Isso torna decisões anteriores e requisitos implícitos mais difíceis de recuperar.

A proposta deste **spec-driven** é fazer da especificação a principal referência de intenção do sistema e tratar o código como uma implementação dessas decisões. O código continua sendo um artefato operacional crítico: é ele que executa, interage com dados e revela detalhes que podem não ter sido registrados.

Regenerar uma funcionalidade em outra tecnologia é uma hipótese do método, não uma consequência automática. Ela exige especificações suficientes, critérios de aceitação executáveis, contratos de dados, configurações conhecidas e testes capazes de comparar comportamento. Para validar essa hipótese, eu reconstruiria primeiro uma parte delimitada em uma branch isolada e compararia:

- comportamento funcional e casos de borda;
- compatibilidade de dados e integrações;
- requisitos não funcionais;
- falhas, observabilidade e recuperação;
- diferenças que precisaram ser inferidas a partir do código anterior.

Se a reconstrução depender repetidamente de decisões ausentes, essa é evidência de que a especificação ainda não funciona como referência suficiente. As páginas [SDD Estratégico](/docs/metodologia/sdd/sdd-Spec-Driven-Development-estrategia/) e [SDD Tático](/docs/metodologia/sdd/sdd-Spec-Driven-Development-tatica/) detalham os controles e a fase autoral de arquivamento usada para reduzir essa divergência.
