#!/usr/bin/env bash

main() {
  local owner=$1 name=$2
  git clone https://github.com/wrboyce/helm-charts-repo-template "$name"
  (
    cd "$name"
    ./bin/generate-signing-key.sh
    git checkout gh-pages
    git checkout template
    git branch --delete master
    git branch --move master
    git remote rm origin
    git gc
    git remote add origin "git@github.com:${owner}/${name}.git"
    git branch --set-upstream-to=origin/gh-pages gh-pages
    git branch --set-upstream-to=origin/master master
    docker run --rm -i -v $PWD:/repo ubuntu:20.04 sed -i -e "s/REPO_OWNER/${owner}/g" -e "s/REPO_NAME/${name}/g" /repo/README.md
    git commit -m 'update README' README.md
  )
}

main "${REPO_OWNER-$(whoami)}" "${REPO_NAME-helm-charts}"
