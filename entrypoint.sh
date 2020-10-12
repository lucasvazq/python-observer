#!/bin/bash

printf "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
printf "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
printf "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
printf "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

echo "$INPUT_REQUIREMENTS"
echo "$REQUIREMENTS"
echo "$1"

if [ -z "$INPUT_REQUIREMENTS" ]; then
    "$($INPUT_REQUIREMENTS)"
fi

if [ -z "$INPUT_MAX_LINE_LENGTH" ]; then
    MAX_LINE_LENGTH="$INPUT_MAX_LINE_LENGHT"
else
    MAX_LINE_LENGTH=79
fi

if [ -z "$INPUT_REPO_IS_A_PACKAGE" ]; then
    REPO_IS_A_PACKAGE="$INPUT_REPO_IS_A_PACKAGE"
else
    REPO_IS_A_PACKAGE=false
fi

function color {
    printf "\e[100m $1 \e[0m"
}

function install {
    color "=========================================================================="
    color "> Installing $*"
    for arg in "$@"; do
        uninstall "$arg"
        pip install --upgrade "$arg"
    done
    for arg in "$@"; do
        color "$(pip freeze | grep -E "^$arg==.*")"
    done
}

function uninstall {
    yes | pip uninstall "$1"
}

###############################################################################
# mypy
# http://www.mypy-lang.org/
###############################################################################

install mypy
mypy /"$PWD" --strict --ignore-missing-imports || true
rm -rf .mypy_cache
uninstall mypy

###############################################################################
# pytype
# https://google.github.io/pytype/
###############################################################################

install pytype
pytype . -d import-error,bad-return-type || true
rm -rf .pytype
uninstall pytype

###############################################################################
# Pyright
# https://github.com/microsoft/pyright
###############################################################################

npm install -g pyright
pyright . || true
color "$(npm list -g --depth=0 | grep -E "pyright@.*")"

###############################################################################
# Pyanalyze
# https://github.com/quora/pyanalyze
###############################################################################

install pyanalyze
if [ "$REPO_IS_A_PACKAGE" == true ]; then
    find . -type f -name "*.py" | grep -Ev "^./setup.py" | xargs python -m pyanalyze || true
else
    find . -type f -name "*.py" | xargs python -m pyanalyze  || true
fi
uninstall pyanalyze

###############################################################################
# InspectorTiger
# https://github.com/thg-consulting/it
###############################################################################

install it
find . -type f -name "*.py" | xargs it || true
uninstall it

###############################################################################
# Pyroma
# https://github.com/regebro/pyroma
###############################################################################

if [ "$REPO_IS_A_PACKAGE" == true ]; then
    install pyroma
    pyroma . || true
    uninstall pyroma
fi

###############################################################################
# Flake8
# https://gitlab.com/pycqa/flake8
#
# It's include by default:
# - PyFlakes
# - pycodestyle / pep8
# - mccabe
###############################################################################

install flake8 pep8-naming flake8-bugbear flake8-comprehensions flake8-assertive flake8-import-order hacking flake8-annotations flake8-broken-line flake8-debugger flake8-builtins flake8-deprecated flake8-executable dlint darglint
flake8 . --extend-ignore=ANN101,EXE001,H306,H404,H405,I100,I101,I201 --max-line-length "$MAX_LINE_LENGTH" || true
uninstall flake8 pep8-naming flake8-bugbear flake8-comprehensions flake8-assertive flake8-import-order hacking flake8-annotations flake8-broken-line flake8-debugger flake8-builtins flake8-deprecated flake8-executable dlint darglint

###############################################################################
# pydocstyle
# https://github.com/PyCQA/pydocstyle/
###############################################################################

install pydocstyle
pydocstyle . --ignore=D104,D200,D203,D212,D401,D404,D406,D407,D413 --ignore-decorators="overload" || true
uninstall pydocstyle

###############################################################################
# Pylint
# https://www.pylint.org/
###############################################################################

install pylint
find . -type f -name "*.py" | xargs pylint --init-hook="import sys; sys.path.append('.')" --disable=too-few-public-methods,cyclic-import --max-line-length="$MAX_LINE_LENGTH" || true
uninstall pylint

###############################################################################
# isort
# https://pycqa.github.io/isort/
###############################################################################

install isort
isort . -rc --diff -sl -l "$MAX_LINE_LENGTH" | colordiff
uninstall isort

###############################################################################
# Black
# https://black.readthedocs.io/en/stable/
###############################################################################

install black
black . --diff -l "$MAX_LINE_LENGTH" | colordiff
uninstall black

###############################################################################
# autopep8
# https://github.com/hhatto/autopep8/
###############################################################################

install autopep8
autopep8 . -r -d --max-line-length "$MAX_LINE_LENGTH" | colordiff
uninstall autopepe8

###############################################################################
# Bandit
# https://bandit.readthedocs.io/en/latest/
###############################################################################

install bandit
bandit . -r || true
uninstall bandit

###############################################################################
# Pyre and Pysa
# https://pyre-check.org
###############################################################################

install pyre-check
printf "yes\n." | pyre init
pyre || true
if [ -z "$INPUT_TAINT_MODELS_PATH" ]; then
    pyre analyze --taint-models-path="$INPUT_TAINT_MODELS_PATH" || true
fi
rm -rf .pyre
rm .watchmanconfig .pyre_configuration
uninstall pyre-check

###############################################################################
# docformatter
# https://github.com/myint/docformatter
###############################################################################

install docformatter
docformatter . -r --make-summary-multi-line --pre-summary-newline --wrap-summaries "$MAX_LINE_LENGTH" --wrap-descriptions "$MAX_LINE_LENGTH" | colordiff
uninstall docformatter

###############################################################################
# coala
# https://coala.io/
###############################################################################

install coala-bears
echo "\
[all]
language = Python
bears = BanditBear,coalaBear,FilenameBear,KeywordBear,PyCommentedCodeBear,PyUnusedCodeBear
files = *.py, **/*.py
json, non_interactive = True
file_naming_convention=auto" > .coafile
coala --flush-cach --non-interactive || true
rm -rf .coafile
uninstall coala-bears


echo "ENDDDDDDD"
printf "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo "$INPUT_REQUIREMENTS"
echo "$REQUIREMENTS"
echo "$1"

echo "ENDDDDDDD"