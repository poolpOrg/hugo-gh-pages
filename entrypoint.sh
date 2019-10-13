#!/usr/bin/env sh

set -e

PLAIN='\033[0m'
BOLD='\033[1;37m'

if [ "${INPUT_CNAME}" ]; then
  NAME=${INPUT_CNAME}
else
  NAME=${GITHUB_REPOSITORY}
fi

[ -z "${INPUT_GITHUB_TOKEN}" ] && \
  (echo -e "\n${BOLD}ERROR: Missing GITHUB_TOKEN.${PLAIN}" ; exit 1)

[ -z "${INPUT_BRANCH}" ] && \
  INPUT_BRANCH=gh-pages

echo -e "\n${BOLD}Versions:${PLAIN}"
echo -ne "${BOLD}Hugo: ${PLAIN}"
hugo version
echo -ne "${BOLD}Pygments: ${PLAIN}"
pygmentize -V
echo -ne "${BOLD}Asciidoctor: ${PLAIN}"
asciidoctor --version
echo -ne "${BOLD}PostCSS: ${PLAIN}"
postcss --version
echo -ne "${BOLD}Pandoc: ${PLAIN}"
pandoc -v

echo -e "\n${BOLD}Generating Site ${NAME} at commit ${GITHUB_SHA}${PLAIN}"
hugo "$@"


echo -e "\n${BOLD}Setting up Git${PLAIN}"
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
echo "machine github.com login ${GITHUB_ACTOR} password ${GITHUB_TOKEN}" > ~/.netrc

git clone --depth=1 --single-branch --branch "${INPUT_BRANCH}" "https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" /tmp/gh-pages


echo -e "\n${BOLD}Commiting${PLAIN}"
rm -rf /tmp/gh-pages/*
cp -a public/* /tmp/gh-pages/
cd /tmp/gh-pages

[ "${INPUT_CNAME}" ] && \
  echo "${INPUT_CNAME}" > CNAME

git add -A && git commit --allow-empty -am "Publishing Site ${NAME} at ${GITHUB_SHA} on $(date -u)"

echo -e "\n${BOLD}Pushing${PLAIN}"
git push --force


echo -e "\n${BOLD}Site ${NAME} at ${GITHUB_SHA} was successfully deployed!${PLAIN}"
