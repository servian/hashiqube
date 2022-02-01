HELL := /bin/bash
TIMESTAMP := $(shell date +%Y-%m-%d)
PROJECT_ID := $(shell gcloud projects list | tail -n 1 | tr -s " " | cut -d " " -f1)
#PROJECT_ID := $(shell gcloud projects list --format="value(projectId)" | tr " " "\n" | head -n 1)

test:
	@echo $(TIMESTAMP)

test2:
	@echo $(TIMESTAMP)

project:
	@echo $(PROJECT_ID)
