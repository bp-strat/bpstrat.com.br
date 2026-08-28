# Linguagem Ubíqua e Glossário do Domínio

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/ddd/o-dicion%C3%A1rio-ub%C3%ADquo-eliminando-a-ambiguidade.html

---

# Linguagem Ubíqua e Glossário do Domínio
{: .no_toc }


## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

![](/assets/778c20920959a526ebf72c20644ef884_MD5.jpg){: .rounded }

Em **Domain-Driven Design (DDD)**, o conceito central é a **Linguagem Ubíqua**, não um dicionário isolado. Eric Evans a define como uma linguagem estruturada em torno do modelo de domínio e usada pelos integrantes da equipe dentro de um **Bounded Context**. Um glossário pode registrar termos importantes, mas é apenas um artefato de apoio.

  

A linguagem é desenvolvida colaborativamente por desenvolvedores, especialistas do domínio e outras pessoas que trabalham no mesmo contexto. Ela aparece nas conversas, nos cenários, nos diagramas e no código que expressa o modelo.

  

O objetivo é tornar ambiguidades e divergências visíveis para que a equipe possa discuti-las e refinar o modelo. Isso reduz problemas de tradução, mas não garante entendimento idêntico. O limite do Bounded Context também importa: um mesmo termo pode ter significados diferentes em contextos distintos.

A definição usada aqui segue a [referência de DDD de Eric Evans](https://www.domainlanguage.com/ddd/reference/).

  

### Principais Características e Benefícios

  

1. Reduz Ambiguidades: Quando negócio e desenvolvimento usam termos diferentes, a equipe precisa traduzir conceitos continuamente. A Linguagem Ubíqua oferece um vocabulário comum dentro de um contexto, enquanto as conversas e o modelo revelam onde ainda existem interpretações incompatíveis.
    
    1. Exemplo: O termo "Cliente" pode significar coisas diferentes para Vendas, Marketing e Suporte. Em vez de forçar uma definição corporativa única, identifique em qual Bounded Context cada significado é válido.
        
2. Conecta o Código ao Negócio: A característica mais poderosa do Dicionário Ubíquo é que ele é usado diretamente no código-fonte. Nomes de classes, métodos, variáveis, módulos e bancos de dados devem refletir a linguagem do negócio.
    
    1. Isso torna o código mais expressivo e fácil de entender por novos desenvolvedores e até mesmo por analistas de negócio com alguma noção técnica. O código passa a ser um reflexo fiel do modelo de negócio.
        
    2. Em vez de: _class CustMgr { void processOrder(data) }_
        
    3. Usa-se: _class Cliente { void RealizarPedido(Pedido pedido) }_
        
3. Facilita a Comunicação: Quando todos falam a mesma língua, a comunicação se torna mais fluida e eficiente. As conversas entre desenvolvedores e especialistas do domínio são mais ricas e focadas em resolver problemas de negócio, não em decifrar jargões.
    
4. Evolução Contínua: O Dicionário Ubíquo não é estático. Ele evolui à medida que o entendimento do domínio pela equipe se aprofunda. Novas descobertas sobre o negócio levam a refinamentos na linguagem, que por sua vez são refletidos no código.
    

  

### Como é Criado e Mantido?

- Colaboração Intensa: Ele nasce de sessões de brainstorming, workshops e conversas contínuas entre desenvolvedores e especialistas do domínio.
    
- Ouvir Ativamente: Os desenvolvedores devem prestar muita atenção aos termos que os especialistas usam para descrever os processos e as regras de negócio.
    
- Questionar e Esclarecer: É crucial questionar termos vagos ou ambíuos até que um consenso seja alcançado.
    
- Documentação (Leve): Um glossário em uma wiki ou documento compartilhado pode registrar definições e questões abertas. Ele não substitui o uso e o refinamento da linguagem nas conversas, nos exemplos e no código.
    

  

### Exemplo Prático: E-commerce de Seguros

Imagine uma equipe construindo um portal de seguros.

- Termo Vago: "Apólice"
    
- Conversa Colaborativa:
    
    - Analista de Negócio: "O cliente compra uma apólice e depois a gente emite."
        
    - Desenvolvedor: "Ok, mas o que é 'comprar' versus 'emitir'? São a mesma coisa? O que acontece entre um e outro?"
        
    - Analista de Negócio: "Não. Primeiro, o cliente solicita uma cotação. Se ele aceitar, a proposta é gerada. A proposta passa por uma análise de risco. Se for aprovada, aí sim a apólice é emitida e entra em vigor."
        
- Termos Resultantes para o Dicionário Ubíquo:
    
    - Cotação: Uma estimativa de preço para uma cobertura, sem compromisso.
        
    - Proposta: Uma solicitação formal de seguro feita pelo cliente com base em uma cotação aceita.
        
    - Análise de Risco: O processo de avaliação de uma Proposta.
        
    - Apólice: O contrato de seguro formal e emitido, que está em vigor.
        
          
        

Esses termos são candidatos a aparecer no código se o modelo confirmar que representam conceitos relevantes naquele contexto. O exemplo não basta para demonstrar que sejam classes, entidades ou a representação definitiva do processo real.
