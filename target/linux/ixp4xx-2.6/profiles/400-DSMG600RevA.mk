#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/DSMG600RevA
  NAME:=DSM-G600 Rev A
  PACKAGES:=kmod-via-velocity \
	kmod-madwifi wireless-tools \
	kmod-scsi-core kmod-libata kmod-pata-artop \
	kmod-usb-core kmod-usb2 kmod-usb-storage \
	kmod-fs-ext2 kmod-fs-ext3
endef

define Profile/DSMG600RevA/Description
	Package set optimized for the DSM-G600 Rev A
endef
$(eval $(call Profile,DSMG600RevA))

