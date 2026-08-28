# Guia de publicação

## Deploy da BPSTRAT

O deploy parte sempre deste repositório fonte. O repositório irmão
`bpstrat.com.br` é apenas o snapshot publicado e não deve receber edições
manuais.

Antes do deploy, faça commit de todas as mudanças da fonte. Em seguida, valide
o fluxo sem alterar repositórios remotos:

```bash
./bin/deploy.sh --check
```

Para publicar:

```bash
./bin/deploy.sh
```

O script executa o mesmo contrato operacional do gpupo.com:

1. exige a fonte sem alterações não commitadas e o compilado na branch `main`;
2. gera o build de produção com o SHA atual da fonte;
3. valida os arquivos públicos essenciais e prepara um commit-raiz isolado;
4. publica a branch atual da fonte;
5. publica duas referências raiz consecutivas com o mesmo tree, ambas usando
   `force-with-lease`;
6. mantém somente a segunda referência na `main` e interrompe o deploy se o
   remoto mudar entre as etapas;
7. remove todas as outras branches e tags locais e remotas do compilado;
8. sincroniza a cópia local e confirma que a `main` possui exatamente um
   commit e que o worktree está limpo.

O build compilado é deliberadamente descartável. Conteúdo, documentação e
histórico permanente pertencem ao repositório fonte. Para recuperar uma
publicação, corrija ou selecione o commit da fonte e execute o deploy novamente.

Por padrão, o compilado deve existir em `../bpstrat.com.br`. Outro caminho pode
ser informado quando necessário:

```bash
BPSTRAT_COMPILED_REPO=/caminho/absoluto/bpstrat.com.br ./bin/deploy.sh
```

O build isolado pode ser executado diretamente:

```bash
./bin/build.sh /tmp/bpstrat-site
```
