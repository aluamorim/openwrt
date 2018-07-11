################################################################################
#
# barelib
#
################################################################################
###############################################################################

include $(TOPDIR)/rules.mk

PKG_NAME:=barelib
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://www.dropbox.com/s/5kpuc8nsqsipicu/barelib-1.0.tar.gz?dl=0

PKG_HASH:=8921ac73abb039636d8ce60eec9bee18

PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=0
PKG_LICENSE:=LGPL-2.1

PKG_MAINTAINER := Anderson Amorim <amorim.an@gmail.com>

PKG_DEPENDENCIES := libssl libcrypto libre librem libz

include $(INCLUDE_DIR)/package.mk

define Package/libbaresip-1.0
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=A library for baresip-based applications
  URL:=https://github.com/aluamorim/openwrt
endef

define Package/libbaresip-1.0/description
  libbaresip-1.0 is a C library that gives applications easy access to baresip functionalites
endef


define Build/InstallDev
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
endef

define Package/libbaresip-1.0/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/libbaresip.a $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/libstdc++.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libbaresip-1.0))

# $(CP) $(PKG_INSTALL_DIR)/libcrypto* $(1)/usr/lib/
# $(CP) $(PKG_INSTALL_DIR)/libre* $(1)/usr/lib/
# $(CP) $(PKG_INSTALL_DIR)/libssl* $(1)/usr/lib/
# $(CP) $(PKG_INSTALL_DIR)/libre* $(1)/usr/lib/
# $(CP) $(PKG_INSTALL_DIR)/libz* $(1)/usr/lib/
# $(CP) $(PKG_INSTALL_DIR)/libbaresip.so $(1)/usr/lib/