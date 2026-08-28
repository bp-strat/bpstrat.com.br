# Autenticação e Gestão de Identidade

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/arquitetura-engenharia/autenticacao.html

---

# Autenticação e Gestão de Identidade
{: .no_toc }

Autenticação e gestão de identidade são capacidades críticas: uma falha pode
interromper o acesso a toda a plataforma ou expor dados e operações. Isso não
significa, porém, que toda organização deva desenvolver seu próprio provedor de
identidade.

Sob a ótica de Domain-Driven Design, identidade costuma ser um **subdomínio
genérico** quando apenas sustenta o acesso às aplicações. Ela pode ser parte do
**core domain** quando o modelo de identidade é uma fonte real de diferenciação,
como em plataformas cuja proposta depende de identidade regulada, consentimento,
administração delegada, prevenção de fraude ou relações complexas entre tenants.

Portanto, classificar identidade como genérica é uma decisão de contexto, não
uma regra universal.

---

## Decisão: adotar, operar ou desenvolver

Para um subdomínio genérico, a recomendação inicial é avaliar uma solução pronta,
gerenciada ou auto-hospedada. Desenvolver internamente só se justifica quando os
requisitos diferenciais não puderem ser atendidos com configuração, extensão ou
integração aceitáveis.

Antes da escolha, registre:

- protocolos e integrações necessários;
- fontes de identidade e requisitos de federação;
- modelo de tenants e de administração delegada;
- requisitos regulatórios, de residência e retenção de dados;
- ameaças relevantes e níveis de autenticação exigidos;
- disponibilidade, RTO e RPO esperados;
- capacidade da equipe para operar, atualizar e recuperar o serviço;
- custo total, incluindo infraestrutura, suporte, atualização e migração;
- extensões que podem criar dependência específica da solução.

O uso de OpenID Connect ou SAML reduz o acoplamento das aplicações ao provedor,
mas não elimina lock-in. Temas, fluxos de autenticação, APIs administrativas,
políticas e extensões proprietárias continuam gerando custo de migração.

---

## Keycloak como candidato

O Keycloak é uma solução open source de Identity and Access Management (IAM).
Ele é um candidato coerente quando a organização precisa de controle sobre a
implantação, integração com diretórios ou provedores existentes e capacidade de
configurar fluxos de autenticação — e aceita assumir sua operação.

Entre as capacidades documentadas estão:

- Single Sign-On e Single Sign-Out;
- clientes OpenID Connect e SAML;
- federação com LDAP e Active Directory;
- papéis de realm e de cliente;
- autenticação com OTP e WebAuthn;
- administração de usuários, grupos, clientes e sessões;
- customização de temas e fluxos de autenticação;
- execução em múltiplos nós com caches distribuídos.

Essa lista demonstra cobertura funcional, não adequação automática. A decisão
deve ser validada contra os requisitos e a capacidade operacional do contexto.

### Quando a opção perde força

Keycloak pode não ser a melhor escolha quando:

- a equipe não pode manter banco, proxy, certificados, atualização, backup e
  recuperação do serviço;
- o prazo favorece um serviço gerenciado e o custo recorrente é aceitável;
- os requisitos dependem de funcionalidades externas ou regulatórias que
  exigiriam extensões extensas;
- a organização não consegue sustentar os objetivos de disponibilidade e
  segurança de uma infraestrutura compartilhada.

---

## Segmentação com realms

No Keycloak, um realm isola usuários, credenciais, papéis, grupos, clientes e
configurações de autenticação. Um usuário pertence e autentica em um realm. Essa
é uma fronteira forte e deve representar uma necessidade real de isolamento.

Separar um **realm externo** de um **realm interno** é uma opção válida quando
existem fronteiras independentes de administração, identidade, política,
auditoria ou ciclo de vida. Por exemplo:

### Realm externo

- usuários finais e aplicações públicas;
- federação com provedores externos;
- políticas e fluxos próprios para cadastro e recuperação;
- escala e ciclo de vida distintos dos usuários internos.

### Realm interno

- equipes internas e aplicações de back-office;
- federação com o diretório corporativo;
- autenticação multifator compatível com o risco;
- administração, auditoria e recuperação sob controles internos.

Essa divisão não deve ser aplicada apenas porque as aplicações têm públicos
diferentes. Se as mesmas identidades precisam de SSO, governança e ciclo de vida
comuns, um único realm com clientes, grupos, papéis e escopos separados pode ser
mais simples.

Múltiplos realms também têm custos: configuração duplicada, usuários duplicados,
integrações adicionais e experiência fragmentada entre fronteiras. A decisão
deve registrar qual risco o isolamento reduz e por que os controles dentro de um
único realm seriam insuficientes.

---

## Restrição de acesso ao back-office

Um realm não limita acesso por rede de forma automática. Restrições a rede
corporativa, VPN ou endereços permitidos devem ser aplicadas no proxy reverso,
ingress, gateway ou firewall.

Em uma implantação exposta à internet:

- publique somente os caminhos necessários para autenticação;
- mantenha a interface e a API administrativas em acesso interno quando isso for
  compatível com a operação;
- não exponha endpoints de métricas e saúde ao público;
- configure hostname, TLS e cabeçalhos de proxy explicitamente;
- impeça acesso direto ao Keycloak que contorne o proxy;
- teste os controles a partir das redes permitidas e bloqueadas.

A documentação do Keycloak recomenda restringir no proxy os caminhos
administrativos e os endpoints de autenticação do realm administrativo. Esses
controles **reduzem** a superfície exposta, mas não garantem segurança por si
sós.

---

## Autenticação e autorização

O mecanismo de autenticação deve corresponder ao risco. Back-office e operações
privilegiadas podem exigir MFA com OTP ou WebAuthn, mas a simples ativação de um
segundo fator não encerra o trabalho. Também é necessário definir recuperação de
conta, revogação de credenciais, proteção contra elevação de privilégio e
procedimentos para perda do autenticador.

Para autorização:

- use escopos e papéis mínimos nos tokens;
- restrinja URIs de redirecionamento e origens de cada cliente;
- limite duração de sessões e tokens conforme o risco;
- revise contas administrativas e permissões delegadas;
- mantenha decisões voláteis do domínio nos serviços ou em um componente de
  políticas apropriado.

O provedor pode transportar identidade, escopos e papéis. Regras como limite de
crédito, aprovação de pedido ou acesso condicionado ao estado de uma entidade
pertencem ao domínio que possui essas informações. Colocá-las no IAM pode
acoplar a evolução do negócio à infraestrutura de identidade.

---

## Disponibilidade e operação

Executar múltiplas instâncias não garante alta disponibilidade. O resultado
depende também de banco de dados, caches, balanceador, DNS, certificados,
capacidade, estratégia de atualização e topologia de falha.

Antes de produção, valide pelo menos:

- falha e substituição de uma instância;
- indisponibilidade e recuperação do banco;
- persistência ou encerramento esperado das sessões;
- rotação de chaves e certificados;
- backup e restauração de dados e configurações;
- atualização e rollback de versão;
- comportamento do proxy e dos health checks;
- capacidade sob pico e degradação de dependências;
- emissão de eventos, logs e alertas úteis para investigação.

Os testes devem produzir evidências para os objetivos de disponibilidade, RTO e
RPO definidos. Sem esses testes, “clustering” descreve uma configuração, não uma
garantia operacional.

---

## Critérios de decisão

Keycloak pode ser adotado quando um experimento ou avaliação comprovar que:

1. os fluxos críticos de login, logout, recuperação e federação funcionam;
2. os limites entre realms, clientes e papéis correspondem ao modelo de acesso;
3. os controles de rede bloqueiam interfaces e caminhos não públicos;
4. aplicações recebem apenas os escopos e papéis necessários;
5. backup, restauração, atualização e falha de instância atendem aos objetivos;
6. a equipe consegue operar e corrigir a plataforma no tempo requerido;
7. o custo total e o custo de saída são aceitáveis.

Se esses critérios não forem atendidos, compare uma oferta gerenciada, outra
solução ou uma redução de escopo. A escolha deve permanecer reversível na medida
compatível com o custo do sistema.

## Referências

KEYCLOAK TEAM. *Server Administration Guide*. Disponível em:
[https://www.keycloak.org/docs/latest/server_admin/](https://www.keycloak.org/docs/latest/server_admin/)

KEYCLOAK TEAM. *Configuring a reverse proxy*. Disponível em:
[https://www.keycloak.org/server/reverseproxy](https://www.keycloak.org/server/reverseproxy)

KEYCLOAK TEAM. *Configuring Keycloak for production*. Disponível em:
[https://www.keycloak.org/server/configuration-production](https://www.keycloak.org/server/configuration-production)

KEYCLOAK TEAM. *High availability overview*. Disponível em:
[https://www.keycloak.org/high-availability/introduction](https://www.keycloak.org/high-availability/introduction)
