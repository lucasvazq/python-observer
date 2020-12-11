#!/bin/bash

function color_print {
    printf "\e[105m %s \e[0m\n" "$1"
}

function install {
    for arg in "$@"; do
        uninstall "$arg"
        pip install "$arg" > /dev/null 2>&1
    done
}

function uninstall {
    function uninstall_command {
        yes | pip uninstall "$1"
    }
    uninstall_command "$1" > /dev/null 2>&1
}

if [ -n "$INPUT_REQUIREMENTS" ]; then
    eval "$INPUT_REQUIREMENTS" > /dev/null 2>&1
fi

if [ -n "$INPUT_MAX_LINE_LENGTH" ]; then
    MAX_LINE_LENGTH="$INPUT_MAX_LINE_LENGTH"
else
    MAX_LINE_LENGTH=79
fi

if [ -n "$INPUT_REPO_IS_A_PACKAGE" ]; then
    REPO_IS_A_PACKAGE="$INPUT_REPO_IS_A_PACKAGE"
else
    REPO_IS_A_PACKAGE=false
fi

###############################################################################
# mypy
# http://www.mypy-lang.org/
###############################################################################

color_print ">>>>>>>>>>>>>>>> mypy"
install mypy
mypy /"$PWD" --strict --ignore-missing-imports || true
rm -rf .mypy_cache > /dev/null 2>&1
uninstall mypy

###############################################################################
# pytype
# https://google.github.io/pytype/
###############################################################################

color_print ">>>>>>>>>>>>>>>> pytype"
install pytype
pytype . -d import-error,bad-return-type || true
rm -rf .pytype > /dev/null 2>&1
uninstall pytype

###############################################################################
# Pyright
# https://github.com/microsoft/pyright
###############################################################################

color_print ">>>>>>>>>>>>>>>> Pyright"
npm install -g pyright > /dev/null 2>&1
pyright . || true

###############################################################################
# Pyanalyze
# https://github.com/quora/pyanalyze
###############################################################################

color_print ">>>>>>>>>>>>>>>> Pyanalyze"
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

color_print ">>>>>>>>>>>>>>>> InspectorTiger"
install it
find . -type f -name "*.py" | xargs it || true
uninstall it

###############################################################################
# Pyroma
# https://github.com/regebro/pyroma
###############################################################################

if [ "$REPO_IS_A_PACKAGE" == true ]; then
    color_print ">>>>>>>>>>>>>>>> Pyroma"
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

color_print ">>>>>>>>>>>>>>>> Flake8"
install flake8 pep8-naming flake8-bugbear flake8-comprehensions flake8-assertive flake8-import-order hacking flake8-annotations flake8-broken-line flake8-debugger flake8-builtins flake8-deprecated flake8-executable darglint
flake8 . --extend-ignore=ANN101,EXE001,H306,H404,H405,I100,I101,I201 --max-line-length "$MAX_LINE_LENGTH" || true
uninstall flake8 pep8-naming flake8-bugbear flake8-comprehensions flake8-assertive flake8-import-order hacking flake8-annotations flake8-broken-line flake8-debugger flake8-builtins flake8-deprecated flake8-executable darglint

###############################################################################
# pydocstyle
# https://github.com/PyCQA/pydocstyle/
###############################################################################

color_print ">>>>>>>>>>>>>>>> pydocstyle"
install pydocstyle
pydocstyle . --ignore=D200,D203,D212,D406,D407,D413 --ignore-decorators="overload" || true
uninstall pydocstyle

###############################################################################
# Pylint
# https://www.pylint.org/
###############################################################################

color_print ">>>>>>>>>>>>>>>> Pylint"
install pylint
find . -type f -name "*.py" | xargs pylint --init-hook="import sys; sys.path.append('.')" --disable=too-few-public-methods,cyclic-import --max-line-length="$MAX_LINE_LENGTH" || true
uninstall pylint

###############################################################################
# isort
# https://pycqa.github.io/isort/
###############################################################################

color_print ">>>>>>>>>>>>>>>> isort"
install isort
isort . --diff --sl -l "$MAX_LINE_LENGTH" | colordiff
uninstall isort

###############################################################################
# Black
# https://black.readthedocs.io/en/stable/
###############################################################################

color_print ">>>>>>>>>>>>>>>> Black"
install black
black . --diff -l "$MAX_LINE_LENGTH" | colordiff
uninstall black

###############################################################################
# autopep8
# https://github.com/hhatto/autopep8/
###############################################################################

color_print ">>>>>>>>>>>>>>>> autopep8"
install autopep8
autopep8 . -r -d --max-line-length "$MAX_LINE_LENGTH" | colordiff
uninstall autopepe8

###############################################################################
# Bandit
# https://bandit.readthedocs.io/en/latest/
###############################################################################

color_print ">>>>>>>>>>>>>>>> Bandit"
install bandit
bandit . -r || true
uninstall bandit

###############################################################################
# Pyre and Pysa
# https://pyre-check.org
###############################################################################

color_print ">>>>>>>>>>>>>>>> Pyre"
install pyre-check
printf "yes\n." | pyre init
pyre || true
if [ -n "$INPUT_TAINT_MODELS_PATH" ]; then
    color_print ">>>>>>>> Pysa"
    pyre analyze --taint-models-path="$INPUT_TAINT_MODELS_PATH" || true
    color_print "<<<<<<<<"
fi
rm -rf .pyre
rm .watchmanconfig .pyre_configuration
uninstall pyre-check

###############################################################################
# docformatter
# https://github.com/myint/docformatter
###############################################################################

color_print ">>>>>>>>>>>>>>>> docformatter"
install docformatter
docformatter . -r --make-summary-multi-line --pre-summary-newline --wrap-summaries "$MAX_LINE_LENGTH" --wrap-descriptions "$MAX_LINE_LENGTH" | colordiff
uninstall docformatter
