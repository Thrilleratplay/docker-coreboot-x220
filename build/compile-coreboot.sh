BUILD_DIR="/root/build"
COREBOOT_DIR="$BUILD_DIR/coreboot"
STOCK_BIOS_ROM="stock_bios.bin"

if [ ! -d "$COREBOOT_DIR" ]; then
  # Clone Coreboot and fetch submodules
  git clone http://review.coreboot.org/coreboot.git $COREBOOT_DIR
  cd $COREBOOT_DIR
  git submodule update --init --recursive --remote
  # blobs are ignored from updates.  Manually clone to prevent compile errors later from non empty directory cloning
  git clone http://review.coreboot.org/blobs.git 3rdparty/blobs/

  # Make and install ifdtool
  cd $COREBOOT_DIR/util/ifdtool
  make
  make install

  mkdir -p $COREBOOT_DIR/3rdparty/blobs/mainboard/lenovo/x220/
  cd $COREBOOT_DIR/3rdparty/blobs/mainboard/lenovo/x220/
  ifdtool -x $BUILD_DIR/$STOCK_BIOS_ROM
  rm flashregion_1_bios.bin
  mv flashregion_0_flashdescriptor.bin descriptor.bin
  mv flashregion_2_intel_me.bin me.bin
  mv flashregion_3_gbe.bin gbe.bin

  ## Add Coreboot cross architechture gcc
  make crossgcc-i386 CPUS=4 -b
  make iasl

  cd $COREBOOT_DIR
else
  cd $COREBOOT_DIR
  git pull origin master
  git submodule update --recursive --remote
fi

if [ ! -f "$BUILD_DIR/.config" ]; then
  make nconfig
  mv $COREBOOT_DIR/.config $BUILD_DIR/.config
  ln $BUILD_DIR/.config $COREBOOT_DIR/.config
elif [ ! -e "$COREBOOT_DIR/.config"  ]; then
  ln $BUILD_DIR/.config $COREBOOT_DIR/.config
fi

make

if [ ! -d "$COREBOOT_DIR" ]; then
  "Your new BIOS is ./build/coreboot/build/coreboot.rom"
else
  echo "Uh oh. Things did not go according to plan."
fi
