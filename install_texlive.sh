#!/bin/bash
set -e

TEXLIVE_VERSION="${1:-${TEXLIVE_VERSION}}"
# TEXLIVE_LATEST_VERSION="2024"
# TEXLIVE_REPO_URL="ftp://tug.org/texlive/tlnet/tlpkg/texlive.tlpdb"
# TEXLIVE_REPO_URL="ftp://tug.org/historic/systems/texlive/${TEXLIVE_VERSION}"
# if [ "$TEXLIVE_VERSION" -lt "${TEXLIVE_LATEST_VERSION}" ]; then
#   TEXLIVE_REPO_URL="ftp://tug.org/historic/systems/texlive/${TEXLIVE_VERSION}/tlnet-final"
# fi

if [ -z "${TEXLIVE_VERSION}" ]
then
  echo "texlive version not specified!"
  exit 1
fi

apt-get update
apt-get install -y perl curl

echo "Downloading TeXLive ${TEXLIVE_VERSION} installer..."

cd /tmp

curl -L -o install-tl-unx.tar.gz https://texlive.info/historic/systems/texlive/${TEXLIVE_VERSION}/install-tl-unx.tar.gz
mkdir tl
tar -xzf install-tl-unx.tar.gz -C tl --strip-components=1

cd /tmp/tl

case "$TEXLIVE_VERSION" in
  2024 | 2023)
    _OPTS="-no-doc-install -no-src-install"
    ;;
  *)
    _OPTS=""
    ;;
esac

# perl ./install-tl -repository "${TEXLIVE_REPO_URL}" -no-interaction ${_OPTS}
perl ./install-tl -no-interaction ${_OPTS}

cd /tmp

rm -rf texlive.profile tl

echo "Installing LaTeX Workshop dependencies..."

apt-get install -y libyaml-tiny-perl libfile-homedir-perl

echo "Cleanup..."

apt clean
rm -rf /var/lib/apt/lists/*
