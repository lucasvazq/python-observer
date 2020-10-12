#!/bin/bash

if [ ! -z "$INPUT_REQUIREMENTS" ]; then
    "$($INPUT_REQUIREMENTS)"
fi

if [ ! -z "$INPUT_MAX_LINE_LENGTH" ]; then
    MAX_LINE_LENGTH="$INPUT_MAX_LINE_LENGTH"
else
    MAX_LINE_LENGTH=79
fi

if [ ! -z "$INPUT_REPO_IS_A_PACKAGE" ]; then
    REPO_IS_A_PACKAGE="$INPUT_REPO_IS_A_PACKAGE"
else
    REPO_IS_A_PACKAGE=false
fi

function install_color {
    printf "\e[100m $1 \e[0m\n"
}

function results_color {
    printf "\e[105m $1 \e[0m\n"
}

function install {
    install_color "=========================================================================="
    install_color "> Installing $*"
    for arg in "$@"; do
        uninstall "$arg"
        pip install "$arg"
    done
    for arg in "$@"; do
        install_color "$(pip freeze | grep -E "^$arg==.*")"
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
results_color ">>>>>>>>>>>>>>>> mypy"
mypy /"$PWD" --strict --ignore-missing-imports || true
results_color "<<<<<<<<<<<<<<<<"
rm -rf .mypy_cache
uninstall mypy

###############################################################################
# pytype
# https://google.github.io/pytype/
###############################################################################

install pytype
pytype . -d import-error,bad-return-type || true
results_color ">>>>>>>>>>>>>>>> pytype"
rm -rf .pytype
results_color "<<<<<<<<<<<<<<<<"
uninstall pytype

###############################################################################
# Pyright
# https://github.com/microsoft/pyright
###############################################################################

npm install -g pyright
install_color "$(npm list -g --depth=0 | grep -E "pyright@.*")"
results_color ">>>>>>>>>>>>>>>> Pyright"
pyright . || true
results_color "<<<<<<<<<<<<<<<<"

###############################################################################
# Pyanalyze
# https://github.com/quora/pyanalyze
###############################################################################

install pyanalyze
results_color ">>>>>>>>>>>>>>>> Pyanalyze"
if [ "$REPO_IS_A_PACKAGE" == true ]; then
    find . -type f -name "*.py" | grep -Ev "^./setup.py" | xargs python -m pyanalyze || true
else
    find . -type f -name "*.py" | xargs python -m pyanalyze  || true
fi
results_color "<<<<<<<<<<<<<<<<"
uninstall pyanalyze

###############################################################################
# InspectorTiger
# https://github.com/thg-consulting/it
###############################################################################

install it
results_color ">>>>>>>>>>>>>>>> InspectorTiger"
find . -type f -name "*.py" | xargs it || true
results_color "<<<<<<<<<<<<<<<<"
uninstall it

###############################################################################
# Pyroma
# https://github.com/regebro/pyroma
###############################################################################

if [ "$REPO_IS_A_PACKAGE" == true ]; then
    install pyroma
    results_color ">>>>>>>>>>>>>>>> Pyroma"
    pyroma . || true
    results_color "<<<<<<<<<<<<<<<<"
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

install flake8 pep8-naming flake8-bugbear flake8-comprehensions flake8-assertive flake8-import-order hacking flake8-annotations flake8-broken-line flake8-debugger flake8-builtins flake8-deprecated flake8-executable darglint
results_color ">>>>>>>>>>>>>>>> Flake8"
flake8 . --extend-ignore=ANN101,EXE001,H306,H404,H405,I100,I101,I201 --max-line-length "$MAX_LINE_LENGTH" || true
results_color "<<<<<<<<<<<<<<<<"
uninstall flake8 pep8-naming flake8-bugbear flake8-comprehensions flake8-assertive flake8-import-order hacking flake8-annotations flake8-broken-line flake8-debugger flake8-builtins flake8-deprecated flake8-executable darglint

###############################################################################
# pydocstyle
# https://github.com/PyCQA/pydocstyle/
###############################################################################

install pydocstyle
results_color ">>>>>>>>>>>>>>>> pydocstyle"
pydocstyle . --ignore=D104,D200,D203,D212,D401,D404,D406,D407,D413 --ignore-decorators="overload" || true
results_color "<<<<<<<<<<<<<<<<"
uninstall pydocstyle

###############################################################################
# Pylint
# https://www.pylint.org/
###############################################################################

install pylint
results_color ">>>>>>>>>>>>>>>> Pylint"
find . -type f -name "*.py" | xargs pylint --init-hook="import sys; sys.path.append('.')" --disable=too-few-public-methods,cyclic-import --max-line-length="$MAX_LINE_LENGTH" || true
results_color "<<<<<<<<<<<<<<<<"
uninstall pylint

###############################################################################
# isort
# https://pycqa.github.io/isort/
###############################################################################

install isort
results_color ">>>>>>>>>>>>>>>> isort"
isort . -rc --diff -sl -l "$MAX_LINE_LENGTH" | colordiff
results_color "<<<<<<<<<<<<<<<<"
uninstall isort

###############################################################################
# Black
# https://black.readthedocs.io/en/stable/
###############################################################################

install black
results_color ">>>>>>>>>>>>>>>> Black"
black . --diff -l "$MAX_LINE_LENGTH" | colordiff
results_color "<<<<<<<<<<<<<<<<"
uninstall black

###############################################################################
# autopep8
# https://github.com/hhatto/autopep8/
###############################################################################

install autopep8
results_color ">>>>>>>>>>>>>>>> autopep8"
autopep8 . -r -d --max-line-length "$MAX_LINE_LENGTH" | colordiff
results_color "<<<<<<<<<<<<<<<<"
uninstall autopepe8

###############################################################################
# Bandit
# https://bandit.readthedocs.io/en/latest/
###############################################################################

install bandit
results_color ">>>>>>>>>>>>>>>> Bandit"
bandit . -r || true
results_color "<<<<<<<<<<<<<<<<"
uninstall bandit

###############################################################################
# Pyre and Pysa
# https://pyre-check.org
###############################################################################

install pyre-check
printf "yes\n." | pyre init
results_color ">>>>>>>>>>>>>>>> Pyre"
pyre || true
results_color "<<<<<<<<<<<<<<<<"
if [ ! -z "$INPUT_TAINT_MODELS_PATH" ]; then
    results_color ">>>>>>>>>>>>>>>> Pysa"
    pyre analyze --taint-models-path="$INPUT_TAINT_MODELS_PATH" || true
    results_color "<<<<<<<<<<<<<<<<"
fi
rm -rf .pyre
rm .watchmanconfig .pyre_configuration
uninstall pyre-check

###############################################################################
# docformatter
# https://github.com/myint/docformatter
###############################################################################

install docformatter
results_color ">>>>>>>>>>>>>>>> docformatter"
docformatter . -r --make-summary-multi-line --pre-summary-newline --wrap-summaries "$MAX_LINE_LENGTH" --wrap-descriptions "$MAX_LINE_LENGTH" | colordiff
results_color "<<<<<<<<<<<<<<<<"
uninstall docformatter

###############################################################################
# coala
# https://coala.io/
###############################################################################

install coala-bears
echo "\
[all]
language = Python
bears = coalaBear,FilenameBear,KeywordBear,PyCommentedCodeBear
files = *.py, **/*.py
json, non_interactive = True
file_naming_convention=auto" > .coafile
results_color ">>>>>>>>>>>>>>>> coala-bears"
coala --flush-cach --non-interactive || true
results_color "<<<<<<<<<<<<<<<<"
rm -rf .coafile
uninstall coala-bears
