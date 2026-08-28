# Tasks de SEO e Semantica

Objetivo: melhorar os sinais semanticos e SEO do site mantendo a stack atual
(Jekyll, Just the Docs e jekyll-seo-tag).

Restricao aceita: manter o bloco visual `Canonical:` no rodape.

## Escopo

- [x] Manter o `Canonical:` visivel no rodape.
- [x] Preservar o `jekyll-seo-tag` como fonte principal de tags SEO comuns.
- [x] Evitar troca de tema ou stack.

## Tasks

- [x] Adicionar `description:` especifica nas paginas principais:
  - `index.md`
  - `contato.md`
  - `servicos/index.md`
  - paginas em `servicos/`
  - `parceiros/index.md`
  - paginas em `parceiros/`
  - `post/index.md`

- [x] Adicionar `description:` nas paginas de documentacao mais relevantes, priorizando:
  - `docs/index.md`
  - secoes raiz em `docs/*/index.md`
  - paginas com maior valor comercial ou tecnico.

- [x] Adicionar `image:` no front matter das paginas e posts que ja possuem imagem principal.

- [x] Definir metadados institucionais em `_config.yml`, conforme suportado pelo `jekyll-seo-tag`:
  - organizacao/site
  - autor padrao
  - perfis sociais
  - logo institucional.

- [x] Adicionar JSON-LD complementar em `_includes/head_custom.html`:
  - `Organization`
  - `ProfessionalService` ou tipo equivalente
  - dados de contato
  - links sociais
  - catalogo basico de servicos, se fizer sentido.

- [x] Melhorar `_layouts/post.html` com semantica de artigo:
  - `<article>`
  - `<header>`
  - `<time datetime="">`
  - lista semantica de tags.

- [x] Corrigir post sem layout:
  - `_posts/2024-05-16-IA-no-Combate-Fraude-uma-oportunidade-pouco-explorada.md`
  - adicionar `layout: post`.

- [x] Corrigir hierarquia de headings para manter um unico `h1` por pagina:
  - `docs/ddd/dominios-subdominios.md`
  - `docs/metodologia/sdd/sdd-Spec-Driven-Development-tatica.md`.

- [x] Revisar imagens sem texto alternativo quando a imagem tiver valor de conteudo.
  Imagens puramente decorativas podem continuar com alt vazio.

- [x] Validar o HTML gerado apos as alteracoes:
  - canonical no `<head>`
  - `Canonical:` visual preservado no rodape
  - uma unica tag `h1` por pagina relevante
  - descriptions especificas no HTML final
  - JSON-LD valido.

## Fora do Escopo

- [ ] Remover o `Canonical:` visual do rodape.
- [ ] Trocar o tema Just the Docs.
- [ ] Trocar Jekyll por outra stack.
- [ ] Fazer redesign visual amplo.

## Observacao de Ambiente

O build local depende do Bundler definido no `Gemfile.lock`. A validacao desta
iteracao foi executada com Bundler 2.4.10 instalado no usuario e gems locais em
`vendor/bundle`.
