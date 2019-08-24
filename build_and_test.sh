#!/bin/bash

#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

set -e

this_path="$(cd "$(dirname "${0}")" && pwd)"

# shellcheck source=travis/travis_jigger.sh
source "${this_path}/travis/travis_jigger.sh"

# shellcheck source=travis/travis_wait.sh
source "${this_path}/travis/travis_wait.sh"

# Full build disabled due to testing and resource consumption
# travis_wait 360 powershell -ExecutionPolicy Bypass -File "${this_path}/build.ps1"
#travis_wait 60 powershell -ExecutionPolicy Bypass -File "${this_path}/test.ps1"
travis_wait 60 powershell -ExecutionPolicy Bypass -File "${this_path}/docker/windows-dev/build.ps1"
travis_wait 20 powershell -ExecutionPolicy Bypass -File "${this_path}/docker/windows-dev/test.ps1"
