SHELL=/bin/bash
NOW=`date +%Y%m%d%H%M%S`

__PWD=$(shell pwd)
__SHELL=$(shell which bash)
__JAVA=$(shell which java)
__TMP_DIR=$(__PWD)/.tmp
__DATA_DIR=$(__TMP_DIR)/data
__BIN_DIR=$(__TMP_DIR)/bin

__OUTPUT_DIR=$(__PWD)/dist

__DOWNLOAD_URL_BITWARDN_OPENAPI_FILE=https://bitwarden.com/help/api/specs/public/swagger.json
__BITWARDEN_OPENAPI_FILE=$(__DATA_DIR)/swagger.json

OPENAPI_GENERATOR_VERSION=5.3.0
__OPENAPI_GENERATOR_JAR=$(__BIN_DIR)/openapi-generator-cli-$(OPENAPI_GENERATOR_VERSION).jar
__DOWNLOAD_URL_OPENAPI_GENERATOR_JAR=https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/$(OPENAPI_GENERATOR_VERSION)/openapi-generator-cli-$(OPENAPI_GENERATOR_VERSION).jar

OPENAPI_GENERATOR_LANG=dart-dio-next


all: init gen

.PHONY: valid
valid:
	@if [ "x$(__JAVA)" == "x" ]; then \
		echo "[ERROR] JAVA runtime has been installed."; \
		exit 1; \
	fi

.PHONY: init
init: valid
	@mkdir -p $(__TMP_DIR)/{data,bin}

	@rm -f $(__BITWARDEN_OPENAPI_FILE) && \
		curl -sL -o $(__BITWARDEN_OPENAPI_FILE) $(__DOWNLOAD_URL_BITWARDN_OPENAPI_FILE)

	@if [ ! -f $(__OPENAPI_GENERATOR_JAR) ]; then \
		curl -sL -o $(__OPENAPI_GENERATOR_JAR) $(__DOWNLOAD_URL_OPENAPI_GENERATOR_JAR); \
	fi


gen: valid
	rm -rf $(__OUTPUT_DIR)
	# echo "`cat $(__BITWARDEN_OPENAPI_FILE) | jq -r '.info.version'`-$(NOW)";

	# VERSION=`cat $(__BITWARDEN_OPENAPI_FILE) | jq '.info.version'`-$(NOW); \

	java -jar $(__OPENAPI_GENERATOR_JAR) generate \
		-i $(__BITWARDEN_OPENAPI_FILE) \
		-o $(__OUTPUT_DIR) \
		-g $(OPENAPI_GENERATOR_LANG) \
		--additional-properties pubLibrary="bitwarden" \
		--additional-properties pubName="bitwarden" \
		--additional-properties pubVersion="0.0.$(NOW)-`cat $(__BITWARDEN_OPENAPI_FILE) | jq -r '.info.version'`" \
		--additional-properties pubAuthor="CAM, Inc." \
		--additional-properties pubDescription="A Dart library for Bitwarden API." \
		--additional-properties pubHomepage="https://github.com/cam-inc/bitwarden"


clean:
	rm -rf $(__TMP_DIR)