#!/bin/sh

#kversion="4.14.37"
kversion="4.9.77"
ip_addr="192.168.1.1"
path="../openwrt"

if [ "$#" -ne 2 ]; then
    echo "Missing parameters..."
    echo "Usage:  #>copy.sh path_to_openwrt linkit_ip_addr"
    exit
else
	path=$1
	ip_addr=$2
fi 

#kversion="4.9.77"
echo "Copying .ko files from: $1 ... "

cp $path/build_dir/target-mipsel_24kc_musl/linux-ramips_mt76x8/linux-$kversion/sound/soc/mtk/*.ko ../linkit-files/
cp $path/build_dir/target-mipsel_24kc_musl/linux-ramips_mt76x8/linux-$kversion/sound/soc/ralink/*.ko ../linkit-files/
#cp firmware/openwrt/build_dir/target-mipsel_24kc_musl/linux-ramips_mt76x8/linux-4.9.77/sound/soc/codecs/*.ko ./

echo "Sending files to linkit at IP=$2..."
scp ../linkit-files/*.ko root@$ip_addr:/root
scp ../linkit-files/run.sh root@$ip_addr:/root
scp ../linkit-files/accounts root@$ip_addr:/root/.baresip/
scp ../linkit-files/config root@$ip_addr:/root/.baresip/
scp ../linkit-files/.asoundrc root@$ip_addr:/root/
scp ../linkit-files/stereo.wav root@192.168.1.1:/root
#scp male.wav root@192.168.1.1:/root
#scp female.wav root@192.168.1.1:/root
#scp sample16khz.wav root@192.168.1.1:/root
#scp mario.wav root@192.168.1.1:/root

echo "Finished!"