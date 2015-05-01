#!/bin/bash
# Copyright 2015 Noragh Analytics, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either 
# express or implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

COMPONENT="monk"

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TEMP_DIR="$SCRIPT_DIR/../tmp"
BASE_DIR="$TEMP_DIR/armagh"
BUILD_PATH="$BASE_DIR/$COMPONENT"
VERSION_INFO="$BASE_DIR/VERSION_INFO"
GEM_PATH="$BUILD_PATH/gems"
RPM_PATH="$BUILD_PATH/rpms"
TEMP_PATH="$SCRIPT_DIR/tmp/$COMPONENT-tmp"
mkdir -p ${GEM_PATH} ${RPM_PATH}


# GEM INSTALL
bundle package --gemfile=${SCRIPT_DIR}/Gemfile.monk --path=${TEMP_PATH}
mv ${TEMP_PATH}/vendor/cache/*.gem ${GEM_PATH}

# Update Version Details
gem_version=$(grep "armagh-monk " ${SCRIPT_DIR}/Gemfile.monk.lock | sed -r 's/.*\((.+)\).*/\1/')
echo "$COMPONENT: $gem_version" >> ${VERSION_INFO}

rm -rf $TEMP_PATH
