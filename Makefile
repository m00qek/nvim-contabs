CONTABS  := $(shell pwd)
TOOLS    := $(CONTABS)/tools
PLUGINS  := $(TOOLS)/plugins
PROJECTS := $(TOOLS)/projects

.PHONY: prepare clean

clean:
	@rm $(PLUGINS) -rf
	@rm $(PROJECTS) -rf

prepare: clean
	@mkdir -p $(PLUGINS)
	@git clone https://github.com/junegunn/fzf.git $(PLUGINS)/fzf
	@git clone https://github.com/junegunn/fzf.vim.git $(PLUGINS)/fzf.vim
	@mkdir -p $(TOOLS)/projects

	@mkdir -p $(PROJECTS)/clojure/leiningen
	@git init $(PROJECTS)/clojure/leiningen
	@echo '(defproject leiningen "1.0.0")' > $(PROJECTS)/clojure/leiningen/project.clj
	@echo '# Leiningen 1.0.0' > $(PROJECTS)/clojure/leiningen/README.md

	@mkdir -p $(PROJECTS)/clojure/cidr
	@echo '(defproject cidr "1.0.0")' > $(PROJECTS)/clojure/cidr/project.clj
	@echo '# CIDR 1.0.0' > $(PROJECTS)/clojure/cidr/README.md

	@mkdir -p $(PROJECTS)/elm-compiler
	@git init $(PROJECTS)/elm-compiler
	@echo '{}' > $(PROJECTS)/elm-compiler/package.json
	@echo '# ELM Compiler' > $(PROJECTS)/elm-compiler/README.md

nvim:
	@CONTABS=$(CONTABS) nvim -u $(TOOLS)/init.vim --cmd "set rtp=$(CONTABS),$(PLUGINS)/fzf,$(PLUGINS)/fzf.vim"

vim:
	@CONTABS=$(CONTABS) vim -u $(TOOLS)/init.vim --cmd "set rtp=$(CONTABS),$(PLUGINS)/fzf,$(PLUGINS)/fzf.vim"
