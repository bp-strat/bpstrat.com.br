# Dev Containers e DAGs

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/data-engineering/apache-airflow/dev-containers-no-vscode-ambientes-reproduz%C3%ADveis-para-desenvolver-dags-do-apache-airflow.html

---

# Dev Containers no VS Code para desenvolver DAGs do Airflow
{: .no_toc }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

Um Dev Container permite versionar parte relevante do ambiente de desenvolvimento junto com o projeto. A configuração pode declarar uma imagem ou um Dockerfile, dependências, ferramentas, extensões do editor e serviços auxiliares. O objetivo é reduzir diferenças de setup e tornar a reconstrução do ambiente verificável, não eliminar toda dependência da máquina hospedeira.

No desenvolvimento de DAGs do Airflow, um Dev Container pode reduzir variações de setup ao fixar a imagem-base, as versões do Python, do Airflow, dos providers e das ferramentas de desenvolvimento. Isso melhora a reprodutibilidade, mas não torna o ambiente automaticamente seguro ou equivalente à produção. Executor, banco de metadados, rede, credenciais, recursos e serviços externos ainda podem apresentar diferenças que precisam ser documentadas e testadas.

![](/assets/8086e0da790e5d050d4a7b45521db3d4_MD5.png){: .rounded }

## O que é um Dev Container?

Um **Dev Container** é uma configuração que permite abrir uma pasta ou um repositório em um container e usá-lo como ambiente de desenvolvimento. O arquivo `devcontainer.json` descreve essa configuração e pode referenciar um Dockerfile ou arquivos do Docker Compose. A [documentação do VS Code](https://code.visualstudio.com/docs/devcontainers/create-dev-container) mostra essas opções e também requisitos que permanecem no host, como o Docker e o compartilhamento de arquivos.

Quando a imagem e as dependências estão fixadas, o time compartilha a mesma base declarada. Ainda podem existir diferenças de arquitetura, runtime do Docker, volumes, permissões, rede e recursos disponíveis no host.

## Pré-requisitos para começar

- Docker instalado na máquina.
    
- VS Code configurado.
    
- Extensão Dev Containers.
    
- (Opcional) Docker Compose para setups mais avançados.
    

## Como funciona na prática

1. Você cria um diretório de projeto e abre no VS Code.
    
2. O editor gera ou reconhece a pasta `.devcontainer`, onde ficam as definições do ambiente.
    
3. Ao reabrir no container, o VS Code executa terminal, ferramentas e extensões configuradas naquele ambiente.
    

Assim, **as ferramentas e dependências vivem no container, e não no seu sistema operacional**, evitando conflitos e poluição da máquina local.

## Vantagens de usar Dev Containers

- **Base compartilhada**: os desenvolvedores podem reconstruir a mesma configuração declarada.
    
- **Menor dependência do sistema operacional**: o container isola ferramentas e bibliotecas, mas o funcionamento ainda depende do Docker, do sistema de arquivos e da arquitetura do host.
    
- **Customização sob medida**: instale pacotes, ferramentas e extensões só dentro do container.
    
- **Integração com VS Code**: debug, autocomplete e execução de scripts acontecem dentro do ambiente configurado.
    

## Aplicando no desenvolvimento de DAGs do Airflow

Quando falamos em **Apache Airflow**, os Dev Containers se tornam ainda mais valiosos:

- É possível fixar as versões do Airflow e das bibliotecas para aproximar o ambiente de desenvolvimento daquele usado em produção. A equivalência deve ser verificada por meio de imagens versionadas, arquivos de constraints ou lockfiles e testes executados na integração contínua.
    
- Não há necessidade de instalar o Airflow e suas dependências diretamente no sistema operacional do host.
    
- O VS Code pode executar extensões e ferramentas de linguagem dentro do container, permitindo configurar **linting, autocomplete e debug** dos DAGs no ambiente declarado.
    
- A pasta `dags/` pode ser montada no container. O tempo para uma alteração
  aparecer no Airflow depende do backend de DAG Bundle e dos intervalos de
  atualização e parsing configurados.
    

## Benefícios práticos para times

- **Onboarding mais verificável**: novos desenvolvedores podem reconstruir o ambiente a partir da configuração versionada, desde que atendam aos pré-requisitos do host.
    
- **Menos investigação de incompatibilidades**: o benefício deve ser confirmado observando tempo de configuração, falhas de build e diferenças entre máquinas.
    
- **Padronização operacional**: mudanças no ambiente podem passar por revisão e ser distribuídas com o repositório.

## Dependências e segurança

Para instalações via `pip` ou `uv`, use o arquivo de constraints correspondente
às versões do Airflow e do Python. Fixar apenas `apache-airflow` e deixar
providers sem controle ainda permite que duas reconstruções produzam ambientes
diferentes.

Não grave secrets em `devcontainer.json`, Dockerfile, Compose ou arquivos
versionados. Injete credenciais de desenvolvimento por um mecanismo fora do
repositório e limite seu privilégio. Montar o socket do Docker dentro do Dev
Container também amplia o acesso ao host e precisa de uma decisão explícita.

## Validação mínima

Uma reconstrução limpa deve executar as mesmas verificações usadas na integração
contínua. Para detectar DAGs que não carregam:

```bash
airflow dags list-import-errors --output=json
```

O resultado esperado é uma lista vazia. Para testar o fluxo de um DAG sem
depender da UI, o objeto também pode chamar `dag.test()` em um ambiente isolado.
Esse teste pode executar código e acessar integrações conforme a configuração;
use credenciais e destinos próprios para teste.

Considere o ambiente reproduzível somente quando uma reconstrução limpa utilizar
imagem e dependências fixadas e passar pelos testes de importação, unidade e
integrações relevantes. Registre também diferenças intencionais de executor,
banco, rede e recursos em relação à produção.

## Referências

MICROSOFT. *Create a Dev Container*. Disponível em:
[https://code.visualstudio.com/docs/devcontainers/create-dev-container](https://code.visualstudio.com/docs/devcontainers/create-dev-container)

APACHE AIRFLOW. *Installation of Airflow*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/installation/index.html](https://airflow.apache.org/docs/apache-airflow/stable/installation/index.html)

APACHE AIRFLOW. *Using the Command Line Interface*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/howto/usage-cli.html](https://airflow.apache.org/docs/apache-airflow/stable/howto/usage-cli.html)

APACHE AIRFLOW. *DAGs — Testing a DAG*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dags.html](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dags.html)
