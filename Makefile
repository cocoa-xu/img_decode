PRIV_DIR = $(MIX_APP_PATH)/priv
IMG_DECODE_SO = $(PRIV_DIR)/imgdecode.so

C_SRC = $(shell pwd)/c_src
LIB_SRC = $(shell pwd)/lib
THIRD_PARTY = $(shell pwd)/3rd_party
STB_INCLUDE_DIR = $(THIRD_PARTY)/stb
CMAKE_IMG_DECODE_BUILD_DIR = $(MIX_APP_PATH)/cmake_imgdecode
MAKE_BUILD_FLAGS ?= "-j1"
ifdef CMAKE_TOOLCHAIN_FILE
	CMAKE_CONFIGURE_FLAGS=-D CMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)"
endif

.DEFAULT_GLOBAL := build

build: $(IMG_DECODE_SO)

$(IMG_DECODE_SO):
	@ git submodule update --init --recursive
	@ mkdir -p $(PRIV_DIR)
	@ mkdir -p $(CMAKE_IMG_DECODE_BUILD_DIR)
	@ cd "$(CMAKE_IMG_DECODE_BUILD_DIR)" && \
		cmake -D C_SRC="$(C_SRC)" \
		-D CMAKE_TOOLCHAIN_FILE="$(TOOLCHAIN_FILE)" \
		-D PRIV_DIR="$(PRIV_DIR)" \
		-D ERTS_INCLUDE_DIR="$(ERTS_INCLUDE_DIR)" \
		-D STB_INCLUDE_DIR=$(STB_INCLUDE_DIR) \
		-S "$(shell pwd)" $(CMAKE_CONFIGURE_FLAGS) && \
		make "$(MAKE_BUILD_FLAGS)"
	@ cp "$(CMAKE_IMG_DECODE_BUILD_DIR)/imgdecode.so" "$(IMG_DECODE_SO)"
