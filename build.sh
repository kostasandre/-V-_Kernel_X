# Note: CROSS_COMPILE must beset manually before executing this

# This builds the zImage (kernel)
# The -jx tells make how many CPUs to use, where x is the number of CPUs + 1
# So, for my Dual-core system, x= 2 + 1 = 3
make -j3 ARCH=arm

echo ""
echo "zImage done"
echo ""
echo "dtbTool starting"
echo ""

# This combines the dtbs into a single, bootable one (dt.img)
./dtbToolCM -2 -o ./arch/arm/boot/dt.img -s 2048 -p ./scripts/dtc/ ./arch/arm/boot/

echo ""
echo "dtbTool done"
echo ""
echo "Coping files to template"
echo ""

# Copy zImage and dt.img to the template (AnyKernel2)
cp -avf arch/arm/boot/zImage AnyKernel2
cp -avf arch/arm/boot/dt.img AnyKernel2

