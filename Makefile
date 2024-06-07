SHELL := bash

DOTFILES_DIR ?= ${HOME}/.dotfiles
SUBDIRS = config local ssh

make_subdirs = $(addprefix ${HOME}/.,$(SUBDIRS))
link_subdirs = $(foreach dir,$(SUBDIRS),$(wildcard $(dir)/*))
link_home = $(shell ls -A home)

.PHONY: install
install: link_dotfiles_dir $(link_subdirs) $(link_home)

.PHONY: link_dotfiles_dir
link_dotfiles_dir:
	ln -svfn $(CURDIR) $(DOTFILES_DIR)

.PHONY: $(link_subdirs)
$(link_subdirs): $(make_subdirs)
	ln -svfn ${DOTFILES_DIR}/$@ ${HOME}/.$@

.PHONY: $(make_subdirs)
$(make_subdirs):
	mkdir -p $@

.PHONY: $(link_home)
$(link_home):
	ln -svfn ${DOTFILES_DIR}/home/$@ ${HOME}/$@

.PHONY: install-nvim
install-nvim:
	$(eval TMPDIR := $(shell mktemp -d))
	wget -O $(TMPDIR)/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
	tar -xzf $(TMPDIR)/nvim-linux64.tar.gz -C $(TMPDIR)
	cp -rv $(TMPDIR)/nvim-linux64/* ${HOME}/.local/
	rm -rf $(TMPDIR)
