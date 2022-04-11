#!/usr/bin/env sh

# Change to LFS compatible directory for steam-run to work

cd ~ && steam-run convox proxy 1443:engine.cx-prod.leeroy.se:443 -r prod
