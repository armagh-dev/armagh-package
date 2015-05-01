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

set +e
useradd armagh
set -e

mkdir -p /var/run/armagh
chown armagh:armagh /var/run/armagh

mkdir -p /var/log/armagh
chown armagh:armagh /var/log/armagh

mkdir -p /etc/armagh
chown armagh:armagh /etc/armagh
