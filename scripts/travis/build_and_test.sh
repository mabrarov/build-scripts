#!/bin/bash

#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

set -e

this_path="$(cd "$(dirname "${0}")" &> /dev/null && pwd)"

# shellcheck source=travis_jigger.sh
source "${this_path}/travis_jigger.sh"

# shellcheck source=travis_wait.sh
source "${this_path}/travis_wait.sh"

project_dir="$(cd "${this_path}/../.." &> /dev/null && pwd)"

travis_wait 360 powershell -ExecutionPolicy Bypass -File "${project_dir}/scripts/build.ps1"
travis_wait 60 powershell -ExecutionPolicy Bypass -File "${project_dir}/scripts/test.ps1"
