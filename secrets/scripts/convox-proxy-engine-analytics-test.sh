#!/usr/bin/env sh

# Change to LFS compatible directory for steam-run to work

cd ~ && steam-run convox proxy 2443:server.engine-analytics.cx-test.leeroy.se:443 -r test
