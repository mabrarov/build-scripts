#!/bin/bash

#
# Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

set -e

this_path="$(cd "$(dirname "$0")" && pwd)"

# shellcheck source=travis_jigger.sh
source "${this_path}/travis_jigger.sh"

# shellcheck source=travis_wait.sh
source "${this_path}/travis_wait.sh"

timeout="${1}"
shift

travis_wait "${timeout}" "${@}"
