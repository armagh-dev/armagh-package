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

# Armagh Installation Script
set -e

display_usage() { 
    echo -e "This script must be run with super-user privileges.\n"
    echo -e "Sets up the provided components.  When no components provided, just builds the base image"
	echo -e "Usage:\n\t$0 [component] [component]... \n"
}

files_exist() {
  shopt -s nullglob
  shopt -s dotglob

  files=($1)
  if [ ${#files[@]} -gt 0 ]; then
    retval=0
  else
    retval=1
  fi

  shopt -u nullglob
  shopt -u dotglob
  return ${retval}
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

echo "Installing Armagh"

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

ARGS=$@
components=("base" ${ARGS[@]})

for component in ${components[@]}; do 
    echo "Installing $component.."
    
    RPM_FILES=${SCRIPT_DIR}/${component}/rpms/*.rpm
    GEM_FILES=${SCRIPT_DIR}/${component}/gems/*.gem
    
    if files_exist ${RPM_FILES}; then
        set +e
        yum localinstall -y --disablerepo=* ${RPM_FILES}
        set -e
    else
        echo "No RPM files to install for $component"
    fi
    
    if files_exist ${GEM_FILES}; then
        set +e
        gem install -Nfl ${GEM_FILES}
        set -e
    else
        echo "No Gem files to install for $component"
    fi
    
    chmod 755 ${SCRIPT_DIR}/${component}/install_${component}.sh
    ${SCRIPT_DIR}/${component}/install_${component}.sh
    
    echo "Finished installation of $component"
done

${SCRIPT_DIR}/verify.sh ${ARGS[@]}