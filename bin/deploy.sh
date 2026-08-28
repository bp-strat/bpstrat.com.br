#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso: bin/deploy.sh [--check]

  --check  executa preflight, build e validações sem alterar repositórios remotos

O deploy normal publica a branch atual da fonte e substitui a main do
bpstrat.com.br por um novo commit-raiz. Todas as outras branches e tags do
repositório compilado são removidas.
USAGE
}

fail() {
  printf 'Erro: %s\n' "$*" >&2
  exit 1
}

mode="deploy"
case "${1:-}" in
  "") ;;
  --check) mode="check" ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

for command_name in bundle git rsync; do
  command -v "$command_name" >/dev/null 2>&1 || fail "comando ausente: $command_name"
done

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source_repo="$(git -C "$script_dir/.." rev-parse --show-toplevel)"
workspace_dir="$(dirname -- "$source_repo")"
compiled_repo="${BPSTRAT_COMPILED_REPO:-$workspace_dir/bpstrat.com.br}"

git -C "$compiled_repo" rev-parse --git-dir >/dev/null 2>&1 || \
  fail "repositório compilado não encontrado em $compiled_repo"

source_branch="$(git -C "$source_repo" symbolic-ref --quiet --short HEAD)" || \
  fail "a fonte precisa estar em uma branch"
compiled_branch="$(git -C "$compiled_repo" symbolic-ref --quiet --short HEAD)" || \
  fail "o compilado precisa estar em uma branch"

[[ "$compiled_branch" == "main" ]] || \
  fail "o compilado precisa estar na branch main; branch atual: $compiled_branch"

[[ -z "$(git -C "$source_repo" status --porcelain)" ]] || \
  fail "a fonte possui alterações não commitadas"

untracked_compiled="$(git -C "$compiled_repo" ls-files --others --exclude-standard)"
[[ -z "$untracked_compiled" ]] || \
  fail "o compilado possui arquivos não rastreados; revise-os antes do deploy"

source_remote="$(git -C "$source_repo" remote get-url origin)"
compiled_remote="$(git -C "$compiled_repo" remote get-url origin)"

case "$source_remote" in
  *git.homelab.gpupo.com*/gpupo/website-source.git) ;;
  *) fail "remote da fonte não reconhecido: $source_remote" ;;
esac

case "$compiled_remote" in
  *github.com:bp-strat/bpstrat.com.br.git|*github.com/bp-strat/bpstrat.com.br.git) ;;
  *) fail "remote do compilado não reconhecido: $compiled_remote" ;;
esac

source_sha="$(git -C "$source_repo" rev-parse HEAD)"
source_short_sha="$(git -C "$source_repo" rev-parse --short HEAD)"
expected_main="$(git ls-remote --heads "$compiled_remote" refs/heads/main | awk 'NR == 1 { print $1 }')"
[[ -n "$expected_main" ]] || fail "a main remota do compilado não foi encontrada"

author_name="$(git -C "$source_repo" config user.name)"
author_email="$(git -C "$source_repo" config user.email)"
[[ -n "$author_name" && -n "$author_email" ]] || \
  fail "user.name e user.email precisam estar configurados na fonte"

deploy_tmp="$(mktemp -d /tmp/bpstrat-deploy.XXXXXX)"
cleanup() {
  if [[ -d "$deploy_tmp" && "$deploy_tmp" == /tmp/bpstrat-deploy.* ]]; then
    find "$deploy_tmp" -depth -delete
  fi
}
trap cleanup EXIT

build_dir="$deploy_tmp/site"
staging_repo="$deploy_tmp/repository"
mkdir -p "$build_dir" "$staging_repo"

"$script_dir/build.sh" "$build_dir"

for required_file in index.html 404.html CNAME feed.xml sitemap.xml llms.txt; do
  [[ -s "$build_dir/$required_file" ]] || \
    fail "build incompleto: $required_file não foi gerado"
done

git init --quiet --initial-branch=main "$staging_repo"
cp -a "$build_dir/." "$staging_repo/"
git -C "$staging_repo" add --all
git -C "$staging_repo" \
  -c user.name="$author_name" \
  -c user.email="$author_email" \
  commit --quiet \
  -m "chore(site): prepara build da fonte $source_short_sha" \
  -m "Cycle:
- [x] compilar e validar a fonte $source_short_sha
- [x] preparar o tree do snapshot como commit-raiz

Next:
- publicar a referência final com o mesmo tree

Risks:
- a propagação do GitHub Pages e de caches pode atrasar a versão pública"

candidate_sha="$(git -C "$staging_repo" rev-parse HEAD)"
candidate_tree="$(git -C "$staging_repo" rev-parse "$candidate_sha^{tree}")"
new_compiled_sha="$(
  git -C "$staging_repo" \
    -c user.name="$author_name" \
    -c user.email="$author_email" \
    commit-tree "$candidate_tree" \
    -m "chore(site): publica build da fonte $source_short_sha" \
    -m "Cycle:
- [x] compilar e validar a fonte $source_short_sha
- [x] preparar duas referências raiz com tree idêntico

Next:
- publicar a main e verificar o site

Risks:
- a propagação do GitHub Pages e de caches pode atrasar a versão pública"
)"
git -C "$staging_repo" update-ref refs/heads/main "$new_compiled_sha" "$candidate_sha"

[[ "$candidate_tree" == "$(git -C "$staging_repo" rev-parse "$new_compiled_sha^{tree}")" ]] || \
  fail "as referências de publicação não possuem o mesmo tree"
[[ "$(git -C "$staging_repo" rev-list --count main)" == "1" ]] || \
  fail "o snapshot preparado não possui exatamente um commit"
[[ "$(git -C "$staging_repo" rev-list --max-parents=0 --count main)" == "1" ]] || \
  fail "o snapshot preparado não é um commit-raiz"

if [[ "$mode" == "check" ]]; then
  printf 'Check concluído: fonte %s; candidato %s; snapshot único %s.\n' \
    "$source_sha" "$candidate_sha" "$new_compiled_sha"
  exit 0
fi

git -C "$source_repo" push origin "HEAD:refs/heads/$source_branch"

git -C "$staging_repo" push \
  --force-with-lease="refs/heads/main:$expected_main" \
  "$compiled_remote" \
  "$candidate_sha":refs/heads/main

git -C "$staging_repo" push \
  --force-with-lease="refs/heads/main:$candidate_sha" \
  "$compiled_remote" \
  main:refs/heads/main

mapfile -t remote_branches < <(
  git ls-remote --heads "$compiled_remote" |
    awk '$2 != "refs/heads/main" { sub("refs/heads/", "", $2); print $2 }'
)
for branch_name in "${remote_branches[@]}"; do
  git -C "$staging_repo" push "$compiled_remote" --delete "$branch_name"
done

mapfile -t remote_tags < <(
  git ls-remote --tags --refs "$compiled_remote" |
    awk '{ sub("refs/tags/", "", $2); print $2 }'
)
for tag_name in "${remote_tags[@]}"; do
  git -C "$staging_repo" push "$compiled_remote" --delete "refs/tags/$tag_name"
done

rsync --archive --delete --exclude='.git/' "$build_dir/" "$compiled_repo/"
git -C "$compiled_repo" fetch origin --prune
git -C "$compiled_repo" reset --mixed origin/main

mapfile -t local_branches < <(
  git -C "$compiled_repo" for-each-ref --format='%(refname:short)' refs/heads
)
for branch_name in "${local_branches[@]}"; do
  if [[ "$branch_name" != "main" ]]; then
    git -C "$compiled_repo" branch --delete --force -- "$branch_name"
  fi
done

mapfile -t local_tags < <(git -C "$compiled_repo" tag --list)
for tag_name in "${local_tags[@]}"; do
  git -C "$compiled_repo" tag --delete "$tag_name"
done

git -C "$compiled_repo" fetch origin --prune

mapfile -t final_remote_heads < <(git ls-remote --heads "$compiled_remote")
[[ "${#final_remote_heads[@]}" == "1" ]] || \
  fail "o compilado remoto ainda possui mais de uma branch"
[[ "${final_remote_heads[0]}" == "$new_compiled_sha"$'\t'"refs/heads/main" ]] || \
  fail "a única branch remota não é a main recém-publicada"
[[ -z "$(git ls-remote --tags --refs "$compiled_remote")" ]] || \
  fail "o compilado remoto ainda possui tags"
[[ "$(git -C "$compiled_repo" rev-list --count main)" == "1" ]] || \
  fail "a main local não possui exatamente um commit"
[[ "$(git -C "$compiled_repo" for-each-ref --count=2 --format='%(refname)' refs/heads | wc -l)" == "1" ]] || \
  fail "o compilado local ainda possui mais de uma branch"
[[ -z "$(git -C "$compiled_repo" status --porcelain)" ]] || \
  fail "o compilado local divergiu do snapshot publicado"

printf 'Deploy concluído: fonte %s; compilado %s (main, um commit).\n' \
  "$source_sha" "$new_compiled_sha"
