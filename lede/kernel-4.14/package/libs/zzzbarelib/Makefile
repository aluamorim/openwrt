################################################################################
#
# barelib
#
################################################################################
###############################################################################

include $(TOPDIR)/rules.mk

PKG_NAME:=zzzbarelib
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://www.dropbox.com/s/3p8kfg8sqkmsuq0/zzzbarelib-1.0.tar.gz?dl=0

PKG_HASH:=41c399ac12dc6d44738c0f65efcf2c0f

PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=0
PKG_LICENSE:=LGPL-2.1

PKG_MAINTAINER := Anderson Amorim <amorim.an@gmail.com>

PKG_DEPENDENCIES := PACKAGE_zlib PACKAGE_libopenssl

include $(INCLUDE_DIR)/package.mk

define Package/zzzbarelib-1.0
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=A library for baresip-based applications
  URL:=https://github.com/aluamorim/openwrt
endef

define Package/zzzbarelib-1.0/description
  zzzbarelib-1.0 is a C library that gives applications easy access to baresip functionalites
endef


define Build/InstallDev
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
endef

define Package/zzzbarelib-1.0/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/root
	$(CP) $(PKG_INSTALL_DIR)/libbaresip.a $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/libstdc++.so $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/libstdc++.so.6 $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/accounts $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/config $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/.asoundrc $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/vrau.wav $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/libre.so $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/librem.so $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/libcrypto.so.1.0.0 $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/libz.so.1 $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/libssl.so.1.0.0 $(1)/root/
	$(CP) $(PKG_INSTALL_DIR)/libbaresip.so $(1)/root/

endef

$(eval $(call BuildPackage,zzzbarelib-1.0))

# $(CP) $(PKG_INSTALL_DIR)/libcrypto* $(1)/usr/lib/
# $(CP) $(PKG_INSTALL_DIR)/libre* $(1)/usr/lib/
# $(CP) $(PKG_INSTALL_DIR)/libssl* $(1)/usr/lib/
# $(CP) $(PKG_INSTALL_DIR)/libre* $(1)/usr/lib/
# $(CP) $(PKG_INSTALL_DIR)/libz* $(1)/usr/lib/
# $(CP) $(PKG_INSTALL_DIR)/libbaresip.so $(1)/usr/lib/
