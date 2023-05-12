
wget https://remote.mistywest.io/download/mh11/rzg2l/VerifiedLinuxPackage_v3.0.0/RTK0EF0045Z0021AZJ-v3.0.0-update2.zip
wget https://remote.mistywest.io/download/mh11/rzg2l/VerifiedLinuxPackage_v3.0.0/RTK0EF0045Z13001ZJ-v1.2_EN.zip
wget https://remote.mistywest.io/download/mh11/rzg2l/VerifiedLinuxPackage_v3.0.0/RTK0EF0045Z15001ZJ-v0.58_EN.zip
wget https://remote.mistywest.io/download/mh11/rzg2l/VerifiedLinuxPackage_v3.0.0/oss_pkg_v3.0.0.7z

cd $WORK || exit 1

unzip -o ~/RTK0EF0045Z0021AZJ-v3.0.0-update2.zip -d ~
tar zxf ~/RTK0EF0045Z0021AZJ-v3.0.0-update2/rzg_bsp_v3.0.0.tar.gz  --no-same-owner

unzip -o ~/RTK0EF0045Z13001ZJ-v1.2_EN.zip -d ~
tar zxf ~/RTK0EF0045Z13001ZJ-v1.2_EN/meta-rz-features.tar.gz  --no-same-owner

unzip -o ~/RTK0EF0045Z15001ZJ-v0.58_EN.zip -d ~
tar zxf ~/RTK0EF0045Z15001ZJ-v0.58_EN/meta-rz-features.tar.gz  --no-same-owner
