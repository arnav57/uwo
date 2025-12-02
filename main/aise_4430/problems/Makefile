
# PANDOC ENGINE COMMANDS
PDF_ENGINE := xelatex
MD_DIR     := ./md/
MD_FILES   := $(wildcard $(MD_DIR)/*.md)

# COURSE NAMES
MAKEFILE_DIR  := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OUTER_PATH    := $(dir $(patsubst %/,%,$(MAKEFILE_DIR)))
COURSE_NAME   := $(notdir $(patsubst %/,%,$(OUTER_PATH)))
PDF_OUT_NAME  := $(COURSE_NAME)_problems.pdf
PDF_CONFIG    := $(MAKEFILE_DIR)/pdf_config.yaml


info:
	@echo "Output Names  : $(OUTER_NAME).pdf"
	@echo "$(MD_FILES)"

pdf: $(MD_FILES)
	pandoc $(MD_FILES) \
	--from markdown \
	--pdf-engine $(PDF_ENGINE) \
	--metadata-file=$(PDF_CONFIG) \
	--to pdf \
	-o $(PDF_OUT_NAME)

