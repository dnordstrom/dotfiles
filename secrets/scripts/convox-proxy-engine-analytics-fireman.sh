#!/usr/bin/env sh

# Change to LFS compatible directory for steam-run to work

cd ~ && steam-run convox proxy 5432:engine-analytics-db.cx-prod.leeroy.se:5432 -r prod
