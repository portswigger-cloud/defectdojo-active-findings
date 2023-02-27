FROM ghcr.io/portswigger-cloud/defectdojo-utils:latest

CMD [ "python", "/usr/defectdojo-utils/src/active_findings.py" ]