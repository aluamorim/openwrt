#!/bin/sh

#kversion="4.14"

kversion="4.9.77"
ip_addr="192.168.1.1"
path="../lede/kernel-4.9"

if [ "$#" -ne 3 ]; then
    echo "Missing parameters..."
    echo "Usage:  #>copy.sh path_to_openwrt kernel_version linkit_ip_addr"
    exit
else
	path=$1
	kversion=$2
	ip_addr=$3
fi 

#kversion="4.9.77"
echo "Copying .ko files from: $path ... "

cp $path/build_dir/target-mipsel_24kc_musl/linux-ramips_mt76x8/linux-$kversion/sound/soc/mtk/*.ko ../linkit-files/modules/
cp $path/build_dir/target-mipsel_24kc_musl/linux-ramips_mt76x8/linux-$kversion/sound/soc/ralink/*.ko ../linkit-files/modules/

echo "Copying image file ..."
cp $path/bin/targets/ramips/mt76x8/*.bin ../linkit-files/lks7688-$kversion.img


echo "Sending files to linkit at IP=$ip_addr ..."
scp ../linkit-files/modules/*.ko root@$ip_addr:/root
scp ../linkit-files/run.sh root@$ip_addr:/root
scp ../linkit-files/install_baresip_dep.sh root@$ip_addr:/root
scp -pr ../linkit-files/accounts root@$ip_addr:/root/.baresip/
scp -pr ../linkit-files/config root@$ip_addr:/root/.baresip/
scp ../linkit-files/.asoundrc root@$ip_addr:/root/
scp ../linkit-files/stereo.wav root@192.168.1.1:/root
#scp male.wav root@192.168.1.1:/root
#scp female.wav root@192.168.1.1:/root
#scp sample16khz.wav root@192.168.1.1:/root
#scp mario.wav root@192.168.1.1:/root

echo "Finished!"