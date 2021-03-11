# Repo Setup

Template repository to bootstrap a new helm chart repository with automatic chart linting/testing/signing/releasing.

## Automatic Setup

* Create a [new repository](https://github.com/new).
* Run installation script -- `curl -s https://raw.githubusercontent.com/wrboyce/helm-charts-repo-template/master/bin/init-repo.sh | REPO_OWNER=$(whoami) REPO_NAME=helm-charts bash`.
* Set `GPG_KEYRING_BASE64` and `GPG_PASSPHRASE_BASE64` secrets.
* Push `master` and `gh-pages` branches -- `git push --all`.

## Manual Setup

### Clone Template Repository

```console
git clone template https://github.com/wrboyce/helm-charts-repo-template helm-charts
cd helm-charts
```

### Generate Signing Key

```console
./bin/generate-signing-key.sh
[...]
=============== Github Actions Secrets  =================
GPG_KEYRING_BASE64: [...]
GPG_PASSPHRASE_BASE64: [...]
=========================================================
```

### Setup Github Repository

* Create a [new repository](https://github.com/new).
* Set `GPG_KEYRING_BASE64` and `GPG_PASSPHRASE_BASE64` secrets.

### Initialise Repository

```console
git checkout gh-pages
git checkout template
git branch --delete master
git branch --move master
git remote rm origin
git gc
git remote add origin git@github.com:$(whoami)/helm-charts.git
git branch --set-upstream-to=origin/gh-pages gh-pages
git branch --set-upstream-to=origin/master master
```

### Update README

Update `REPO_OWNER` and `REPO_NAME` in the README.md template then commit changes with `git commit -m 'update README' README.md`.

### Push All Branches

```console
git push origin master
git push origin --all
```

## Final Setup

Optionally enable [renovate](http://github.com/apps/renovate) for automatic action/dependency updates and setup any desired branch protections.

## Start Adding Charts!

PRs will be linted and tested, commits to master will trigger a release if required.
