# DefectDojo Active Findings v1

This GitHub Action that queries the number of active finding in DefectDojo by product and writes a summary out to the GitHub Actions summary.

portswigger-cloud/defectdojo-active-findings@v1

__Example output__

DefectDojo active findings summary for my-product
* Total: 10
* Critical: 2
* High: 2
* Medium: 2
* Low: 2
* Info: 2

## About DefectDojo

[DefectDojo](https://github.com/DefectDojo/django-DefectDojo) is a security orchestration and vulnerability management platform. DefectDojo allows you to manage your application security program, maintain product and application information, triage vulnerabilities and push findings to systems like JIRA and Slack. DefectDojo enriches and refines vulnerability data using a number of heuristic algorithms that improve with the more you use the platform.

## Inputs

| Input Name                   | Required |
| ---------------------------- | -------- | 
| defectdojo-url               | True     |
| defectdojo-username          | True     |
| defectdojo-password          | True     |
| defectdojo-product           | True     |

## Outputs

| Output Name | Description                                                                                   |
| ----------- | --------------------------------------------------------------------------------------------- | 
| total       | the total number of active findings registered against this product in DefectDojo             |
| critical    | the number of active critical severity findings registered against this product in DefectDojo |
| high        | the number of active high severity findings registered against this product in DefectDojo     |
| medium      | the number of active medium severity findings registered against this product in DefectDojo   |
| low         | the number of active low severity findings registered against this product in DefectDojo      |
| info        | the number of active info severity findings registered against this product in DefectDojo     |

## Examples

### Simple example

```
name: create-active-security-findings-summary-by-product-from-defectdojo
on:
  push
jobs:
  query_active_findings_from_defectdojo:
    runs-on: ubuntu-latest
    steps:
      - name: get active findings from defectdojo
        id: get-active-findings-from-defectdojo
        uses: portswigger-cloud/defectdojo-active-findings@main
        with:
          defectdojo-url: ${{ inputs.defectdojo-url }}
          defectdojo-username: ${{ secrets.defectdojo-username }}
          defectdojo-password: ${{ secrets.defectdojo-password }}
          defectdojo-product: my-product
```

### Using the total output to fail the build if total findings are greater than 0

```
name: generate-active-security-findings-summary-by-product
on:
  push
jobs:
  query-active-findings-from-defectdojo:
    runs-on: ubuntu-latest
    steps:
      - name: get active findings from defectdojo
        id: get-active-findings-from-defectdojo
        uses: portswigger-cloud/defectdojo-active-findings@v1
        with:
          defectdojo-url: ${{ inputs.defectdojo-url }}
          defectdojo-username: ${{ secrets.defectdojo-username }}
          defectdojo-password: ${{ secrets.defectdojo-password }}
          defectdojo-product: my-product
  fail-build-on-total-security-findings-thresholds:
    needs: query-active-findings-from-defectdojo
    runs-on: ubuntu-latest
    steps:
      - name: fail build on total finding
        id: fail-build-on-total-finding
        if: ${{ needs.query-active-findings-from-defectdojo.outputs.total > 0 }}
        run: |
          echo "::error ::total number of security findings threshold has been exceeded please resolve in DefectDojo before continuing"
          exit 1
```