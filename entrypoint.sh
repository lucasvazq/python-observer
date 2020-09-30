#!/bin/bash
set -e

if [ -z "${INPUT_REQUIREMENTS}" ]; then
    pip install "${INPUT_REQUIREMENTS}"
fi

local disable
if [ -z "${INPUT_DISABLE}" ]; then
    disable="--disable=${INPUT_DISABLE}"
else
    disable=""
fi

local max_line_length
if [ -z "${INPUT_MAX_LINE_LENGTH}" ]; then
    max_line_length="--max-line-lenght=${INPUT_MAX_LINE_LENGHT}"
else
    max_line_length=""
fi

find . -type f -name "*.py" | xargs pylint --init-hook="import sys; sys.path.append('.')" "${max_line_length}" "${disable}"
