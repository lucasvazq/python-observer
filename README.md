# Python auto-linter

Uses: pylint

## Usage:

**requirements:** packages to install.

`requirements: "Django==3.1.1 python-resize-image"`

**disable:** disable rules of pylint

`disable: "C0301,C0103"`

**max_line_length:** max line length

`max_line_length: 79`

## Example

```yaml
name: Python auto-linter

on:
  push:
    branches:
      - master
  pull_request:
    branches:
      - master

jobs:
  auto-linter:
    name: Python auto-linter
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v2

      - name: pylint
        uses: lucasvazq/auto-linter@master
        with:
          requirements: "Pillow Jinja2"
          disable: "R0903"
          max_line_length: 119
```
