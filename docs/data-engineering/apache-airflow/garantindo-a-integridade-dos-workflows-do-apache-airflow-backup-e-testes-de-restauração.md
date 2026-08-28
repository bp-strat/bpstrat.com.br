# Backup e Restauração do Airflow

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/data-engineering/apache-airflow/garantindo-a-integridade-dos-workflows-do-apache-airflow-backup-e-testes-de-restaura%C3%A7%C3%A3o.html

---

# Backup e Restauração do Apache Airflow
{: .no_toc }


## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

![](/assets/68bf2eadc1e7fab5e4af59a7dc9723fb_MD5.jpg){: .rounded }

Um backup do banco de metadados não representa sozinho um ambiente Airflow recuperável. DAGs, plugins, configuração, versões, chaves, segredos, logs e dados externos podem estar distribuídos entre repositórios, imagens, bancos e serviços diferentes.

O objetivo deste procedimento é tornar a recuperação testável. Ele reduz risco, mas não garante continuidade nem ausência de perda.

## Defina o que precisa ser recuperado

Antes de escolher uma ferramenta, registre:

- **cenários de falha:** exclusão acidental, corrupção do banco, perda de credenciais, implantação defeituosa ou indisponibilidade do ambiente;
- **RPO:** quanto estado recente pode ser perdido;
- **RTO:** quanto tempo a recuperação pode levar;
- **responsáveis:** quem inicia, executa, valida e encerra a recuperação;
- **efeitos externos:** quais tarefas podem cobrar clientes, enviar mensagens ou alterar outros sistemas caso sejam reexecutadas.

Sem esses critérios, não é possível concluir se a política de backup atende à necessidade operacional.

## Inventário de recuperação

### DAGs, plugins e código

Mantenha o código em controle de versão e preserve a revisão exata, os arquivos de build e as imagens usadas na implantação. Em instalações com vários nós, o Airflow exige que cada componente tenha os DAGs e configurações apropriados ao seu papel; a [documentação de produção](https://airflow.apache.org/docs/apache-airflow/stable/administration-and-deployment/production-deployment.html) recomenda mecanismos de distribuição versionada para DAGs.

### Banco de metadados

Use o mecanismo de backup consistente e, quando necessário, recuperação pontual oferecido pelo banco adotado. A cópia precisa considerar escritas do scheduler, API, workers e outros componentes. Parar apenas um serviço não demonstra consistência.

SQLite é adequado para desenvolvimento e testes, não para uma implantação de produção. A documentação do Airflow recomenda PostgreSQL ou MySQL como backend externo em produção.

### Configuração e versões

Registre a versão do Airflow e dos providers, a imagem ou pacote instalado, o executor, as variáveis de ambiente, os manifests de implantação e a versão do schema do banco. Restaurar metadados com software incompatível pode exigir migração ou falhar antes da validação.

### Segredos e material criptográfico

Connections e Variables podem estar no banco de metadados, em variáveis de ambiente ou em um backend externo de segredos. Portanto, exportar ou restaurar apenas o banco pode deixar valores ausentes. A [documentação de Connections](https://airflow.apache.org/docs/apache-airflow/stable/howto/connection.html) descreve essas três origens.

Quando valores estão criptografados no metastore, preserve o procedimento de recuperação da chave Fernet e dos demais segredos de segurança. Não coloque chaves de descriptografia junto do backup que elas protegem. Exports de Connections e Variables contêm dados sensíveis e devem seguir controles de acesso, criptografia e descarte próprios.

### Logs, XComs e dados externos

Logs remotos, XComs armazenados em object storage e dados produzidos pelas tarefas não são necessariamente recuperados junto com o metastore. Inventarie cada armazenamento, sua política de retenção e a ordem em que precisa voltar. O backup do Airflow não substitui a proteção dos bancos, buckets e APIs manipulados pelos DAGs.

## Produza e proteja os backups

Para cada componente, documente:

- mecanismo e frequência;
- consistência esperada;
- retenção e expiração;
- criptografia e controle de acesso;
- cópia fora do domínio de falha principal;
- evidência de conclusão e alerta de falha.

Escolha backup online, snapshot ou janela de manutenção conforme as garantias do banco e o RPO definido. Se o procedimento exigir interrupção, identifique todos os processos capazes de escrever e confirme que ficaram inativos antes da cópia.

## Teste a restauração

Faça o teste em ambiente isolado para não executar tarefas contra produção por engano:

1. provisione versões compatíveis do Airflow, dos providers e do banco;
2. restaure configuração, permissões e acesso aos segredos necessários;
3. restaure o metastore pelo procedimento nativo do banco;
4. disponibilize a revisão correta dos DAGs e plugins;
5. reconecte logs, XComs e dependências externas previstas no escopo;
6. inicie os componentes de forma controlada, mantendo DAGs com efeitos externos desativados;
7. valide importação dos DAGs, acesso ao banco, saúde do scheduler, API e leitura dos logs;
8. execute um DAG preparado para teste e confirme seus resultados;
9. registre duração, perda observada, erros, intervenções manuais e itens não recuperados.

Não aplique migrações de schema automaticamente antes de confirmar a compatibilidade do ponto restaurado e o procedimento de rollback.

## Critério de conclusão

Considere o teste concluído somente quando houver evidência de que:

- o RPO e o RTO foram atendidos ou o desvio foi aceito;
- DAGs e plugins carregaram sem erros relevantes;
- chaves, Connections e Variables necessárias ficaram disponíveis;
- logs e estados esperados puderam ser consultados;
- uma execução controlada terminou com o resultado previsto;
- nenhuma integração de produção recebeu efeitos indevidos;
- o runbook foi atualizado com falhas e passos manuais encontrados.

A frequência dos testes deve acompanhar o risco e as mudanças no ambiente. Uma restauração aprovada antes de alterações de versão, executor, banco, segredos ou armazenamento não valida automaticamente a configuração nova.

## Referências

APACHE AIRFLOW. *Production Deployment*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/administration-and-deployment/production-deployment.html](https://airflow.apache.org/docs/apache-airflow/stable/administration-and-deployment/production-deployment.html)

APACHE AIRFLOW. *Managing Connections*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/howto/connection.html](https://airflow.apache.org/docs/apache-airflow/stable/howto/connection.html)

APACHE AIRFLOW. *Fernet*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/security/secrets/fernet.html](https://airflow.apache.org/docs/apache-airflow/stable/security/secrets/fernet.html)

APACHE AIRFLOW. *Logging for Tasks*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/administration-and-deployment/logging-monitoring/logging-tasks.html](https://airflow.apache.org/docs/apache-airflow/stable/administration-and-deployment/logging-monitoring/logging-tasks.html)
