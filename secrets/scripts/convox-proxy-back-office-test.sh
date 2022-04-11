#!/usr/bin/env sh

# Change to LFS compatible directory for steam-run to work

cd ~ && steam-run convox proxy 5443:cloud-back-office.cx-test.leeroy.se:443 -r test
