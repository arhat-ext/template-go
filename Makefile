# Copyright 2020 The arhat.dev Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# IMAGE_REPOS is the comma separated list of image registries
IMAGE_REPOS ?= docker.io/arhatdev,ghcr.io/arhat-dev

export IMAGE_REPOS

DEFAULT_IMAGE_MANIFEST_TAG ?= latest

include scripts/lint.mk

GOMOD := GOPROXY=direct GOSUMDB=off go mod
.PHONY: vendor
vendor:
	${GOMOD} tidy
	${GOMOD} vendor

# testing
include scripts/test/unit.mk

# binary build
include scripts/build/template-arhat-device.mk

# image
include scripts/image/template-arhat-device.mk

image.build.linux.all: \
	image.build.template-arhat-device.linux.all

image.build.windows.all: \
	image.build.template-arhat-device.windows.all

image.push.linux.all: \
	image.push.template-arhat-device.linux.all

image.push.windows.all: \
	image.push.template-arhat-device.windows.all

# packaging
include scripts/package/template-arhat-device.mk

# optional private scripts
-include private/scripts.mk