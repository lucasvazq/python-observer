# Python Observant

<details><summary>List of packages that check the code</summary>

- [mypy](http://www.mypy-lang.org/)
- [pytype](https://google.github.io/pytype/)
- [Pyright](https://github.com/microsoft/pyright)
- [Pyanalyze](https://github.com/quora/pyanalyze)
- [InspectorTiger](https://github.com/thg-consulting/it)
- [Pyroma](https://github.com/regebro/pyroma)
- [Flake8](https://gitlab.com/pycqa/flake8)
  - Plugins:
    - flake8-annotations
    - flake8-assertive
    - flake8-broken-line
    - flake8-builtins
    - flake8-bugbear
    - flake8-comprehensions
    - flake8-debugger
    - flake8-deprecated
    - flake8-executable
    - flake8-import-order
    - darglint
    - dlint
    - hacking
    - pep8-naming
- [pydocstyle](https://github.com/PyCQA/pydocstyle/)
- [Pylint](https://www.pylint.org/)
- [isort](https://pycqa.github.io/isort/)
- [Black](https://black.readthedocs.io/en/stable/)
- [autopep8](https://github.com/hhatto/autopep8/)
- [Bandit](https://bandit.readthedocs.io/en/latest/)
- [Pyre and Pysa](https://pyre-check.org)
- [docformatter](https://github.com/myint/docformatter)
- [coala](https://coala.io/)

You can found more details looking at [entryping.sh](./entrypoint.sh)

</details>

Recomended tools that aren't include in this action and can be used to improve the python code:
  - [Sourcery.ai](https://sourcery.ai/)
  - [MonkeyType](https://github.com/Instagram/MonkeyType)

<table>
  <thead>
    <tr>
      <th>Input</th>
      <th>Description</th>
      <th>Type</th>
      <th>Default value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>requirements</td>
      <td>Command to install required packages</td>
      <td>str</td>
      <td>""</td>
    </tr>
    <tr>
      <td>max_line_length</td>
      <td>Max line length</td>
      <td>int</td>
      <td>79</td>
    </tr>
    <tr>
      <td>repo_is_package</td>
      <td>Define if repo is a package</td>
      <td>bool</td>
      <td>false</td>
    </tr>
    <tr>
      <td>taint_models_path</td>
      <td>Path to taint folder where are stored all *.pysa files and the taint config. If path is not provided, Pysa don't execute.</td>
      <td>str</td>
      <td>""</td>
    </tr>
  </tbody>
</table>

## Example

```yaml
name: Python Observant

on:
  pull_request:
    branches:
      - master

jobs:
  Python-Observant:
    name: Python Observant
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v2

      - name: Python Observant
        uses: lucasvazq/auto-linter@master
        with:
          requirements: 'pip install -r requirements.txt'
          max_line_length: 119
          repo_is_package: true
          taint_models_path: 'stubs/taint'
```
