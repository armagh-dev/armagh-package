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

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TEMP_DIR="$SCRIPT_DIR/../tmp"
BUILD_PATH="$TEMP_DIR/armagh"
VERSION_FILE="$SCRIPT_DIR/VERSION"
VERSION_INFO="$BUILD_PATH/VERSION_INFO"
VERSION=`cat ${VERSION_FILE}`
OUT_DIR="$SCRIPT_DIR/../pkg"

set +e
rm -rf ${OUT_DIR}
set -e

${SCRIPT_DIR}/build_base.sh

cp ${SCRIPT_DIR}/../install/install.sh ${BUILD_PATH}/
cp ${SCRIPT_DIR}/../install/install_component.sh ${BUILD_PATH}/
cp ${SCRIPT_DIR}/../verify/verify.sh ${BUILD_PATH}/
cp ${SCRIPT_DIR}/../install/install_base.sh ${BUILD_PATH}/base/
cp ${SCRIPT_DIR}/../verify/verify_base.sh ${BUILD_PATH}/base/

chmod 755 ${BUILD_PATH}/*.sh

components=( "bishop" "data" "monk" )

for component in "${components[@]}"; do
	${SCRIPT_DIR}/build_${component}.sh
	cp ${SCRIPT_DIR}/../install/install_${component}.sh ${BUILD_PATH}/${component}/
	cp ${SCRIPT_DIR}/../verify/verify_${component}.sh ${BUILD_PATH}/${component}/
done
cp ${VERSION_FILE} ${BUILD_PATH}

mkdir -p ${OUT_DIR}
tar -C ${TEMP_DIR} -czvpf ${OUT_DIR}/armagh-${VERSION}.tgz armagh/

rm -rf ${TEMP_DIR}

echo "Build completed successfully"

