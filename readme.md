## docker-coreboot-build
Build environment to compile and update an existing Coreboot instance.  This is intended for the Thinkpad X220 but
could easily be adapted for other systems.

Note: **DO NOT FLASH COREBOOT OVER THE STOCK BIOS**.  Use this guide [to use a Raspberry Pi 3 to flash the stock BIOS](http://karlcordes.com/coreboot-x220/).  To speed up the process, [this Docker build will create a Raspbian image ready to read and flash the stock bios](https://github.com/Thrilleratplay/pi-flashrom/).  Remember to backup the stock bios binary dump and make a note of the type of chip your BIOS is.

#### Basic usage
* Clone this repo
* Copy the backed up stock bios binary dump of your BIOS to `build/stock_bios.bin`
* Execute `run.sh`.  This will handle the container building, pulling the latest Coreboot code, parsing the stock bios and compiling.

When complete, you should find you new BIOS under `build/coreboot.rom`.  To update internally, execute:
```
sudo flashrom -c <YOUR CHIPSET> -p internal:laptop=force_I_want_a_brick -w build/coreboot.rom
```
