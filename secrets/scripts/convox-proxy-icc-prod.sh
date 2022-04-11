#!/usr/bin/env sh

# Change to LFS compatible directory for steam-run to work

cd ~ && steam-run convox proxy 4443:integration-central-configuration.cx-prod.leeroy.se:443 -r prod
