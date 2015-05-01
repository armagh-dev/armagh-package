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

COMPONENT="base"

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TEMP_DIR="$SCRIPT_DIR/../tmp"
BASE_DIR="$TEMP_DIR/armagh"
BUILD_PATH="$BASE_DIR/$COMPONENT"
VERSION_INFO="$BASE_DIR/VERSION_INFO"
GEM_PATH="$BUILD_PATH/gems"
RPM_PATH="$BUILD_PATH/rpms"
TEMP_PATH="$SCRIPT_DIR/tmp/$COMPONENT-tmp"
mkdir -p ${GEM_PATH} ${RPM_PATH}

set +e
rm -rf ${TEMP_PATH}
set -e

# May have to run before
#   sudo yum install -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel rpm-build yum-utils

######### DOWNLOAD RPMS #########
# Download the rpms that we need.  Note that some need EPEL and RepoForge
# One package per yumdownloader call because yumdownloader not-real-package returns 1 (error) correctly, but
#  yumdownloader w3m not-real-package returns 0 (indicating no error)
yumdownloader --destdir=${RPM_PATH} w3m
yumdownloader --destdir=${RPM_PATH} libyaml 
yumdownloader --destdir=${RPM_PATH} screen 
yumdownloader --destdir=${RPM_PATH} iftop 
yumdownloader --destdir=${RPM_PATH} gc 
yumdownloader --destdir=${RPM_PATH} gpm-libs 
yumdownloader --destdir=${RPM_PATH} vim-enhanced 
yumdownloader --destdir=${RPM_PATH} vim-common 
yumdownloader --destdir=${RPM_PATH} libpcap
yumdownloader --destdir=${RPM_PATH} perl 
yumdownloader --destdir=${RPM_PATH} perl-Module-Pluggable 
yumdownloader --destdir=${RPM_PATH} perl-Pod-Escapes 
yumdownloader --destdir=${RPM_PATH} perl-Pod-Simple 
yumdownloader --destdir=${RPM_PATH} perl-libs 
yumdownloader --destdir=${RPM_PATH} perl-version
yumdownloader --destdir=${RPM_PATH} htop

# Handle a bug from yumdownloader downloading i686 as well
set +e
rm -f ${RPM_PATH}/*i686*.rpm
set -e


########## BUILD RUBY  ##########
# Build Ruby
wget -P ${TEMP_PATH}/SOURCES http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.gz
rpmbuild -bb ${SCRIPT_DIR}/ruby.spec --define "_topdir $TEMP_PATH"

if ! type "ruby" > /dev/null; then
  sudo yum -y localinstall ${TEMP_PATH}/RPMS/*/ruby*.rpm
  sudo gem install -N bundler
fi

mv ${TEMP_PATH}/RPMS/*/*.rpm ${RPM_PATH}

# Bundler Gem (bundler can't be downloaded from bundler like the rest)
pushd ${GEM_PATH}
gem fetch bundler
popd


rm -rf ${TEMP_PATH}
