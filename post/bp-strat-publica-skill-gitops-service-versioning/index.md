# BP STRAT publica skill aberta para governança de versões em ambientes GitOps

Published: 2026-07-09
Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/post/bp-strat-publica-skill-gitops-service-versioning/
Tags: Notícias, Engenharia, Inteligência Artificial

---

**Press release — 9 de julho de 2026.**

A BP STRAT publicou uma nova skill aberta para apoiar equipes técnicas na governança de versões de serviços em ambientes GitOps. A skill, chamada **GitOps Service Versioning**, orienta agentes de IA a auditar tags de imagens, identificar drift entre configuração local e upstream, revisar registros vivos de versões e manter documentação técnica alinhada com a implementação real.

O repositório está disponível em [github.com/bp-strat/skills](https://github.com/bp-strat/skills).

Ambientes modernos de tecnologia combinam múltiplos modelos de execução: containers Docker, jobs Nomad, serviços em LXC, manifestos declarativos, playbooks Ansible e bancos compartilhados. Conforme essa malha cresce, uma pergunta simples fica difícil de responder com confiança: **qual versão está realmente rodando em produção?**

A skill GitOps Service Versioning organiza esse problema em quatro camadas:

- estado desejado versionado em Git;
- motor de auditoria para extrair e comparar versões;
- registro vivo com versões locais, versões upstream e status de drift;
- documentação pública e operacional refletindo a realidade.

O objetivo é reduzir o uso de tags móveis como `latest`, `main` e `stable`, melhorar a rastreabilidade de imagens em serviços multi-container e evitar falsos positivos como marcar um serviço como atualizado quando a versão upstream não pode ser descoberta.

> "Governança de versões não precisa começar com uma plataforma complexa. Ela pode começar com uma regra simples: o repositório precisa dizer a verdade sobre o que roda, o que deveria rodar e onde existe drift", afirma Gilmar Pupo, fundador da BP STRAT.

A publicação da skill também reforça uma diretriz importante para o uso profissional de agentes de IA: o conhecimento operacional deve ser transformado em instruções reutilizáveis, auditáveis e versionadas. Em vez de depender apenas da memória do time ou de prompts soltos, a skill captura critérios objetivos para avaliar maturidade técnica em repositórios GitOps.

Uma discussão mais ampla desse formato está em [AI Skills são fluxos reutilizáveis, não agentes](https://www.gpupo.com/posts/ai-skills-como-capacidades-configuradas/), que separa contexto, ferramentas, limites e critérios de conclusão.

Entre os critérios cobertos pela skill estão:

- proibição ou justificativa explícita para tags móveis em produção;
- cobertura completa de imagens em serviços com múltiplas tarefas;
- diferenciação entre versão desejada no Git e versão observada em runtime;
- status específico para upstream desconhecido;
- revisão de dependências de bancos, caches e filas;
- alinhamento entre whitepapers, runbooks e código.

A BP STRAT pretende evoluir o repositório de skills como uma base aberta de práticas para agentes de IA aplicados a engenharia, operação e governança técnica.

Repositório: [https://github.com/bp-strat/skills](https://github.com/bp-strat/skills)
