#!/usr/bin/env bash
set -e

# setup kubectl and krew
# https://krew.sigs.k8s.io/docs/user-guide/quickstart/
# https://krew.sigs.k8s.io/docs/user-guide/setup/install/#bash

if ! command -v git > /dev/null; then
  echo "git is required to run this script"
  exit 1
fi

(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

"${HOME}/.krew/bin/kubectl-krew" install \
 doctor get-all krew outdated preflight restart sniff tail
