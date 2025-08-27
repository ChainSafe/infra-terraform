# Makefile

SHELL := /bin/bash
.PHONY: all

all:
	@echo "Usage: make <module name>"

%:
	@if [ -z "$@" ]; then \
		echo "Error: folder name is required"; \
		exit 1; \
	fi
	@if [[ -d "modules/$@" ]]; then \
  	echo "Module $@ already exists"; \
  	exit 1; \
   fi
	@./scripts/init-new-module.sh "$@"
