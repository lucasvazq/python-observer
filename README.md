# Python Observer

_A Github Action that uses a large number of packages to analyze Python code._<br>
_The action checks type hints, code format, requirements, bugs, and bad practices._

<details><summary>List of included packages</summary>

- [mypy](http://www.mypy-lang.org/)
- [pytype](https://google.github.io/pytype/)
- [Pyright](https://github.com/microsoft/pyright)
- [Pyanalyze](https://github.com/quora/pyanalyze)
- [InspectorTiger](https://github.com/thg-consulting/it)
- [Pyroma](https://github.com/regebro/pyroma)
- [Flake8](https://gitlab.com/pycqa/flake8)
  - Plugins:
    - [flake8-annotations](https://github.com/sco1/flake8-annotations)
    - [flake8-assertive](https://github.com/jparise/flake8-assertive)
    - [flake8-broken-line](https://github.com/sobolevn/flake8-broken-line)
    - [flake8-builtins](https://github.com/gforcada/flake8-builtins)
    - [flake8-bugbear](https://github.com/PyCQA/flake8-bugbear)
    - [flake8-comprehensions](https://github.com/adamchainz/flake8-comprehensions)
    - [flake8-debugger](https://github.com/jbkahn/flake8-debugger)
    - [flake8-deprecated](https://github.com/gforcada/flake8-deprecated)
    - [flake8-executable](https://github.com/xuhdev/flake8-executable)
    - [flake8-import-order](https://github.com/PyCQA/flake8-import-order)
    - [darglint](https://github.com/terrencepreilly/darglint)
    - [hacking](https://docs.openstack.org/hacking/latest/)
    - [pep8-naming](https://github.com/PyCQA/pep8-naming)
- [pydocstyle](https://github.com/PyCQA/pydocstyle/)
- [Pylint](https://www.pylint.org/)
- [isort](https://pycqa.github.io/isort/)
- [Black](https://black.readthedocs.io/en/stable/)
- [autopep8](https://github.com/hhatto/autopep8/)
- [Bandit](https://bandit.readthedocs.io/en/latest/)
- [Pyre and Pysa](https://pyre-check.org)
- [docformatter](https://github.com/myint/docformatter)
- [coala](https://coala.io/)

You can found more details looking at [entrypoint.sh](./entrypoint.sh)

</details>

Here I list some recommended tools that aren't included in this action, but can be used in the development of Python code:
  - [Sourcery.ai](https://sourcery.ai/)
  - [MonkeyType](https://github.com/Instagram/MonkeyType)

## Parameters

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
name: Python Observer

on: [push, pull_request]

jobs:
  Python-Observer:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v2
      - name: Run Python Observer
        uses: lucasvazq/python-observer@master
        with:
          requirements: 'pip install -r requirements.txt'
          max_line_length: 119
          repo_is_package: true
          taint_models_path: 'stubs/taint'
```
