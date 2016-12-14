#
# Copyright (C) 2006-2012 OpenWrt.org
# Copyright (C) 2016 LEDE project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

OPENWRT_GIT = http://git.openwrt.org
LEDE_GIT = https://git.lede-project.org

DOWNLOAD_RDEP=$(STAMP_PREPARED) $(HOST_STAMP_PREPARED)

# Try to guess the download method from the URL
define dl_method
$(strip \
  $(if $(2),$(2), \
    $(if $(filter @APACHE/% @GITHUB/% @GNOME/% @GNU/% @KERNEL/% @SF/% @SAVANNAH/% ftp://% http://% https://% file://%,$(1)),default, \
      $(if $(filter git://%,$(1)),git, \
        $(if $(filter svn://%,$(1)),svn, \
          $(if $(filter cvs://%,$(1)),cvs, \
            $(if $(filter hg://%,$(1)),hg, \
              $(if $(filter sftp://%,$(1)),bzr, \
                unknown \
              ) \
            ) \
          ) \
        ) \
      ) \
    ) \
  ) \
)
endef

# code for creating tarballs from cvs/svn/git/bzr/hg/darcs checkouts - useful for mirror support
dl_pack/bz2=bzip2 -c > $(1)
dl_pack/gz=gzip -nc > $(1)
dl_pack/xz=xz -zc -7e > $(1)
dl_pack/unknown=$(error ERROR: Unknown pack format for file $(1))
define dl_pack
	$(if $(dl_pack/$(call ext,$(1))),$(dl_pack/$(call ext,$(1))),$(dl_pack/unknown))
endef
define dl_tar_pack
	$(TAR) --numeric-owner --owner=0 --group=0 --sort=name $$$${TAR_TIMESTAMP:+--mtime="$$$$TAR_TIMESTAMP"} -c $(2) | $(call dl_pack,$(1))
endef

ifdef CHECK
check_escape=$(subst ','\'',$(1))
#')
check_warn = $(info $(shell printf "$(_R)WARNING: %s$(_N)" '$(call check_escape,$(call C_$(1),$(2),$(3),$(4)))'))
gen_sha256sum = $(shell openssl dgst -sha256 $(DL_DIR)/$(1) | awk '{print $$2}')

C_download_missing = $(1) is missing, please run make download before re-running this check
C_hash_mismatch = $(3) does not match $(1) hash $(call gen_sha256sum,$(1))
C_hash_deprecated = $(3) uses deprecated hash, set to $(call gen_sha256sum,$(1))
C_hash_missing = $(3) is missing, set to $(call gen_sha256sum,$(1))

check_hash = \
  $(if $(wildcard $(DL_DIR)/$(1)), \
    $(if $(filter-out x,$(2)), \
      $(if $(filter 64,$(shell printf '%s' '$(2)' | wc -c)), \
        $(if $(filter $(2),$(call gen_sha256sum,$(1))),, \
          $(call check_warn,hash_mismatch,$(1),$(2),$(3)) \
        ), \
        $(call check_warn,hash_deprecated,$(1),$(2),$(3)), \
      ), \
      $(call check_warn,hash_missing,$(1),$(2),$(3)) \
    ), \
    $(call check_warn,download_missing,$(1),$(2),$(3)) \
  )

C_md5_deprecated = Use of $(2) is deprecated, switch to $(3)

# Skip MD5SUM check in feeds until OpenWrt is updated
ifneq ($(filter $(foreach dir,package tools toolchain, $(TOPDIR)/$(dir)/%),$(CURDIR)),)
check_md5 = \
  $(if $(filter-out x,$(1)), \
    $(call check_warn,md5_deprecated,$(1),$(2),$(3)) \
  )
endif

hash_var = $(if $(filter-out x,$(1)),MD5SUM,HASH)
endif

define DownloadMethod/unknown
	@echo "ERROR: No download method available"; false
endef

define DownloadMethod/default
	$(SCRIPT_DIR)/download.pl "$(DL_DIR)" "$(FILE)" "$(HASH)" "$(URL_FILE)" $(foreach url,$(URL),"$(url)") \
	$(if $(filter check,$(1)), \
		$(call check_hash,$(FILE),$(HASH),$(2)$(call hash_var,$(MD5SUM))) \
		$(call check_md5,$(MD5SUM),$(2)MD5SUM,$(2)HASH) \
	)
endef

define wrap_mirror
$(if $(if $(MIRROR),$(filter-out x,$(MIRROR_HASH))),$(SCRIPT_DIR)/download.pl "$(DL_DIR)" "$(FILE)" "$(MIRROR_HASH)" "" || ( $(3) ),$(3)) \
$(if $(filter check,$(1)), \
	$(call check_hash,$(FILE),$(MIRROR_HASH),$(2)MIRROR_$(call hash_var,$(MIRROR_MD5SUM))) \
	$(call check_md5,$(MIRROR_MD5SUM),$(2)MIRROR_MD5SUM,$(2)MIRROR_HASH) \
)
endef

define DownloadMethod/cvs
	$(call wrap_mirror,$(1),$(2), \
		echo "Checking out files from the cvs repository..."; \
		mkdir -p $(TMP_DIR)/dl && \
		cd $(TMP_DIR)/dl && \
		rm -rf $(SUBDIR) && \
		[ \! -d $(SUBDIR) ] && \
		cvs -d $(URL) export $(VERSION) $(SUBDIR) && \
		echo "Packing checkout..." && \
		$(call dl_tar_pack,$(TMP_DIR)/dl/$(FILE),$(SUBDIR)) && \
		mv $(TMP_DIR)/dl/$(FILE) $(DL_DIR)/ && \
		rm -rf $(SUBDIR); \
	)
endef

define DownloadMethod/svn
	$(call wrap_mirror,$(1),$(2), \
		echo "Checking out files from the svn repository..."; \
		mkdir -p $(TMP_DIR)/dl && \
		cd $(TMP_DIR)/dl && \
		rm -rf $(SUBDIR) && \
		[ \! -d $(SUBDIR) ] && \
		( svn help export | grep -q trust-server-cert && \
		svn export --non-interactive --trust-server-cert -r$(VERSION) $(URL) $(SUBDIR) || \
		svn export --non-interactive -r$(VERSION) $(URL) $(SUBDIR) ) && \
		echo "Packing checkout..." && \
		export TAR_TIMESTAMP="" && \
		$(call dl_tar_pack,$(TMP_DIR)/dl/$(FILE),$(SUBDIR)) && \
		mv $(TMP_DIR)/dl/$(FILE) $(DL_DIR)/ && \
		rm -rf $(SUBDIR); \
	)
endef

define DownloadMethod/git
	$(call wrap_mirror,$(1),$(2), \
		echo "Checking out files from the git repository..."; \
		mkdir -p $(TMP_DIR)/dl && \
		cd $(TMP_DIR)/dl && \
		rm -rf $(SUBDIR) && \
		[ \! -d $(SUBDIR) ] && \
		git clone $(OPTS) $(URL) $(SUBDIR) && \
		(cd $(SUBDIR) && git checkout $(VERSION) && \
		git submodule update --init --recursive) && \
		echo "Packing checkout..." && \
		export TAR_TIMESTAMP=`cd $(SUBDIR) && git log -1 --format='@%ct'` && \
		rm -rf $(SUBDIR)/.git && \
		$(call dl_tar_pack,$(TMP_DIR)/dl/$(FILE),$(SUBDIR)) && \
		mv $(TMP_DIR)/dl/$(FILE) $(DL_DIR)/ && \
		rm -rf $(SUBDIR); \
	)
endef

define DownloadMethod/bzr
	$(call wrap_mirror,$(1),$(2), \
		echo "Checking out files from the bzr repository..."; \
		mkdir -p $(TMP_DIR)/dl && \
		cd $(TMP_DIR)/dl && \
		rm -rf $(SUBDIR) && \
		[ \! -d $(SUBDIR) ] && \
		bzr export --per-file-timestamps -r$(VERSION) $(SUBDIR) $(URL) && \
		echo "Packing checkout..." && \
		export TAR_TIMESTAMP="" && \
		$(call dl_tar_pack,$(TMP_DIR)/dl/$(FILE),$(SUBDIR)) && \
		mv $(TMP_DIR)/dl/$(FILE) $(DL_DIR)/ && \
		rm -rf $(SUBDIR); \
	)
endef

define DownloadMethod/hg
	$(call wrap_mirror,$(1),$(2), \
		echo "Checking out files from the hg repository..."; \
		mkdir -p $(TMP_DIR)/dl && \
		cd $(TMP_DIR)/dl && \
		rm -rf $(SUBDIR) && \
		[ \! -d $(SUBDIR) ] && \
		hg clone -r $(VERSION) $(URL) $(SUBDIR) && \
		export TAR_TIMESTAMP=`cd $(SUBDIR) && hg log --template '@{date}' -l 1` && \
		find $(SUBDIR) -name .hg | xargs rm -rf && \
		echo "Packing checkout..." && \
		$(call dl_tar_pack,$(TMP_DIR)/dl/$(FILE),$(SUBDIR)) && \
		mv $(TMP_DIR)/dl/$(FILE) $(DL_DIR)/ && \
		rm -rf $(SUBDIR); \
	)
endef

define DownloadMethod/darcs
	$(call wrap_mirror, $(1), $(2), \
		echo "Checking out files from the darcs repository..."; \
		mkdir -p $(TMP_DIR)/dl && \
		cd $(TMP_DIR)/dl && \
		rm -rf $(SUBDIR) && \
		[ \! -d $(SUBDIR) ] && \
		darcs get -t $(VERSION) $(URL) $(SUBDIR) && \
		export TAR_TIMESTAMP=`cd $(SUBDIR) && LC_ALL=C darcs log --last 1 | sed -ne 's!^Date: \+!!p'` && \
		find $(SUBDIR) -name _darcs | xargs rm -rf && \
		echo "Packing checkout..." && \
		$(call dl_tar_pack,$(TMP_DIR)/dl/$(FILE),$(SUBDIR)) && \
		mv $(TMP_DIR)/dl/$(FILE) $(DL_DIR)/ && \
		rm -rf $(SUBDIR); \
	)
endef

Validate/cvs=VERSION SUBDIR
Validate/svn=VERSION SUBDIR
Validate/git=VERSION SUBDIR
Validate/bzr=VERSION SUBDIR
Validate/hg=VERSION SUBDIR
Validate/darcs=VERSION SUBDIR

define Download/Defaults
  URL:=
  FILE:=
  URL_FILE:=
  PROTO:=
  HASH=$$(MD5SUM)
  MD5SUM:=x
  SUBDIR:=
  MIRROR:=1
  MIRROR_HASH=$$(MIRROR_MD5SUM)
  MIRROR_MD5SUM:=x
  VERSION:=
  OPTS:=
endef

define Download/default
  FILE:=$(PKG_SOURCE)
  URL:=$(PKG_SOURCE_URL)
  SUBDIR:=$(PKG_SOURCE_SUBDIR)
  PROTO:=$(PKG_SOURCE_PROTO)
  $(if $(PKG_SOURCE_MIRROR),MIRROR:=$(filter 1,$(PKG_MIRROR)))
  $(if $(PKG_MIRROR_MD5SUM),MIRROR_MD5SUM:=$(PKG_MIRROR_MD5SUM))
  $(if $(PKG_MIRROR_HASH),MIRROR_HASH:=$(PKG_MIRROR_HASH))
  VERSION:=$(PKG_SOURCE_VERSION)
  $(if $(PKG_MD5SUM),MD5SUM:=$(PKG_MD5SUM))
  $(if $(PKG_HASH),HASH:=$(PKG_HASH))
endef

define Download
  $(eval $(Download/Defaults))
  $(eval $(Download/$(1)))
  $(foreach FIELD,URL FILE $(Validate/$(call dl_method,$(URL),$(PROTO))),
    ifeq ($($(FIELD)),)
      $$(error Download/$(1) is missing the $(FIELD) field.)
    endif
  )

  $(foreach dep,$(DOWNLOAD_RDEP),
    $(dep): $(DL_DIR)/$(FILE)
  )
  download: $(DL_DIR)/$(FILE)

  $(DL_DIR)/$(FILE):
	mkdir -p $(DL_DIR)
	$(call locked, \
		$(if $(DownloadMethod/$(call dl_method,$(URL),$(PROTO))), \
			$(call DownloadMethod/$(call dl_method,$(URL),$(PROTO)),check,$(if $(filter default,$(1)),PKG_,Download/$(1):)), \
			$(DownloadMethod/unknown) \
		),\
		$(FILE))

endef
