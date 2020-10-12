# Python PR checklist

## Usage:

**requirements:** packages to install.

`requirements: "Django==3.1.1 python-resize-image"`

**max_line_length:** max line length (default 79).

`max_line_length: 79`

**repo_is_package:** boolean used to define if repo is a package (default false).

`repo_is_package: true`

### Pysa

**taint_models_path:** path to taint folder where are stored all *.pysa files and the taint config. If path is not provided, Pysa don't execute.

`taint_models_path: stubs/taint`

## Example

```yaml
name: Python observant

on:
  pull_request:
    branches:
      - master

jobs:
  Python observant:
    name: Python observant
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v2

      - name: Python observant
        uses: lucasvazq/auto-linter@master
        with:
          requirements: "Pillow Jinja2"
          max_line_length: 119
          repo_is_package: true
```
