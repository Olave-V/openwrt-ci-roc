# 修改默认IP & 固件名称
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i "s/hostname='.*'/hostname='OpenWRT'/g" package/base-files/files/bin/config_generate

# 调整NSS驱动q6_region内存区域预留大小（ZN-M2 1GB内存版，对应ipq6018.dtsi）
# 带WiFi必须至少预留54MB，以下为1GB设备推荐配置（64MB，兼顾稳定与内存占用）
sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]+>/reg = <0x0 0x4ab00000 0x0 0x04000000>/' target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018.dtsi

# Go语言环境依赖
rm -rf feeds/packages/lang/golang
git clone --depth=1 https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# Go & openclash主程序和核心
git clone --depth=1 https://github.com/vernesong/OpenClash package/OpenClash
rm -rf feeds/luci/applications/luci-app-openclash
mv -f package/OpenClash feeds/luci/applications/luci-app-openclash

./scripts/feeds update -a
./scripts/feeds install -a
