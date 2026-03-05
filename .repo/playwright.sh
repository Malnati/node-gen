#!/bin/bash

# The Playwright CLI can be configured using a JSON configuration file. You can specify the configuration file using the --config command line option:
# playwright-cli --config path/to/config.json open example.com

npm install -g @playwright/cli@latest
playwright-cli --help
playwright-cli install --skills
