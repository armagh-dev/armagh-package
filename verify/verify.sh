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

# Armagh Verification Script
set -e

display_usage() { 
    echo -e "This script must be run with super-user privileges.\n"
    echo -e "Verifies the provided components.  When no components provided, verifies the base image"
	echo -e "Usage:\n\t$0 [component] [component]... \n"
}

if [[ ( $1 == "--help") ||  $1 == "-h" ]]; then
    display_usage
    exit 0
fi

# Run as root
if [[ $EUID -ne 0 ]]; then
   display_usage
   exit 1
fi

echo "Verifying Armagh"

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

ARGS=$@
components=("base" ${ARGS[@]})

for component in ${components[@]}; do
    echo "Verifying $component.."
    
    chmod 755 ${SCRIPT_DIR}/${component}/install_${component}.sh
    ${SCRIPT_DIR}/${component}/verify_${component}.sh
    
    echo "Finished verification of $component"
done