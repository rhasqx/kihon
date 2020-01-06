#!/bin/bash

BRANCH=$(perl -pe 's/.*\/|\n//g' ".git/HEAD")
COMMIT=$(cat .git/refs/heads/${BRANCH})

echo -n "${COMMIT}"
