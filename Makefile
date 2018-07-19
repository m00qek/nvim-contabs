CONTABS := $(shell pwd)
TOOLS   := $(CONTABS)/tools
PLUGINS := $(TOOLS)/plugins

.PHONY: prepare clean

clean:
	@rm $(PLUGINS) -rf

prepare: clean
	@mkdir -p $(PLUGINS)
	@git clone https://github.com/junegunn/fzf.git $(PLUGINS)/fzf
	@git clone https://github.com/junegunn/fzf.vim.git $(PLUGINS)/fzf.vim

nvim:
	@nvim -u $(TOOLS)/init.vim --cmd "set rtp=$(CONTABS),$(PLUGINS)/fzf,$(PLUGINS)/fzf.vim"
