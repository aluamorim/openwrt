#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/FAST2404
  NAME:=Sagem F@ST2404
  PACKAGES:=kmod-b43 wpad-mini
endef
define Profile/FAST2404/Description
  Package set optimized for F@ST2404.
endef
$(eval $(call Profile,FAST2404))

define Profile/FAST2604
  NAME:=Sagem F@ST2604
  PACKAGES:=kmod-b43 wpad-mini
endef
define Profile/FAST2604/Description
  Package set optimized for F@ST2604.
endef
$(eval $(call Profile,FAST2604))
