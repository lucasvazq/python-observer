# Python Observant

<details><summary>List of packages that check your code</summary>

...

</details>

Recomendation of [Sourcery.ai](https://sourcery.ai/)

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
      <td>Packages to install</td>
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
          requirements: 'Django==3.1.1 Jinja2'
          max_line_length: 119
          repo_is_package: true
          taint_models_path: 'stubs/taint'
```
