# Run Buildroot in a docker container

## Preparation

### Build the Docker image

```
➜  buildroot-docker git:(main) ✗ sh build.sh 
[+] Building 0.2s (9/9) FINISHED                                                                                                                                                
 => [internal] load build definition from Dockerfile                                                                                                                       0.0s
 => => transferring dockerfile: 559B                                                                                                                                       0.0s
 => [internal] load .dockerignore                                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                                            0.0s
 => [internal] load metadata for docker.io/library/debian:bullseye                                                                                                         0.0s
 => [1/5] FROM docker.io/library/debian:bullseye                                                                                                                           0.0s
 => CACHED [2/5] WORKDIR /buildroot                                                                                                                                        0.0s
 => CACHED [3/5] RUN apt update                                                                                                                                            0.0s
 => CACHED [4/5] RUN apt install -y build-essential git curl xz-utils file wget cpio unzip bc rsync file libncurses-dev libssl-dev python3                                 0.0s
 => CACHED [5/5] RUN git clone git://git.buildroot.net/buildroot --depth=1 --branch=2022.02 /buildroot                                                                     0.0s
 => exporting to image                                                                                                                                                     0.0s
 => => exporting layers                                                                                                                                                    0.0s
 => => writing image sha256:ccd8f28fbf79c73241597f5c2ea148ba15b805af6e6b032c972b8581fef76c5f                                                                               0.0s
 => => naming to docker.io/library/buildroot:2022.02                                                                                                                       0.0s
➜  buildroot-docker git:(main) ✗ 
```

### Create the container for download cache

```
➜  buildroot-docker git:(main) ✗ docker run --name buildroot_state buildroot:2022.02 echo "data"                                                            
make: *** No rule to make target 'echo'.  Stop.
➜  buildroot-docker git:(main) ✗ 
```

## Run the build

### Create default config

```
➜  buildroot-docker git:(main) ✗ ./run.sh avenger96_defconfig
mkdir -p /output/build/buildroot-config/lxdialog
PKG_CONFIG_PATH="" /usr/bin/make CC="/usr/bin/gcc" HOSTCC="/usr/bin/gcc" \
    obj=/output/build/buildroot-config -C support/kconfig -f Makefile.br conf
make[1]: Entering directory '/buildroot/support/kconfig'
/usr/bin/gcc -I/usr/include/ncursesw -DCURSES_LOC="<curses.h>"  -DNCURSES_WIDECHAR=1 -DLOCALE  -I/output/build/buildroot-config -DCONFIG_=\"\"  -MM *.c > /output/build/buildroot-config/.depend 2>/dev/null || :
/usr/bin/gcc -I/usr/include/ncursesw -DCURSES_LOC="<curses.h>"  -DNCURSES_WIDECHAR=1 -DLOCALE  -I/output/build/buildroot-config -DCONFIG_=\"\"   -c conf.c -o /output/build/buildroot-config/conf.o
/usr/bin/gcc -I/usr/include/ncursesw -DCURSES_LOC="<curses.h>"  -DNCURSES_WIDECHAR=1 -DLOCALE  -I/output/build/buildroot-config -DCONFIG_=\"\"  -I. -c /output/build/buildroot-config/zconf.tab.c -o /output/build/buildroot-config/zconf.tab.o
/usr/bin/gcc -I/usr/include/ncursesw -DCURSES_LOC="<curses.h>"  -DNCURSES_WIDECHAR=1 -DLOCALE  -I/output/build/buildroot-config -DCONFIG_=\"\"   /output/build/buildroot-config/conf.o /output/build/buildroot-config/zconf.tab.o  -o /output/build/buildroot-config/conf
rm /output/build/buildroot-config/zconf.tab.c
make[1]: Leaving directory '/buildroot/support/kconfig'
  GEN     /output/Makefile
#
# configuration written to /output/.config
#
➜  buildroot-docker git:(main) ✗ 
```

### Launch the build

```
➜  buildroot-docker git:(main) ✗ ./run.sh -j$(nproc) all

[......]

>>>   Executing post-image script board/stmicroelectronics/common/stm32mp157/post-image.sh
INFO: cmd: "mkdir -p "/output/build/genimage.tmp"" (stderr):
INFO: cmd: "rm -rf "/output/build/genimage.tmp"/*" (stderr):
INFO: cmd: "mkdir -p "/output/build/genimage.tmp"" (stderr):
INFO: cmd: "cp -a "/tmp/tmp.vdxA440ZMy" "/output/build/genimage.tmp/root"" (stderr):
INFO: cmd: "find '/output/build/genimage.tmp/root' -depth -type d -printf '%P\0' | xargs -0 -I {} touch -r '/tmp/tmp.vdxA440ZMy/{}' '/output/build/genimage.tmp/root/{}'" (stderr):
INFO: hdimage(sdcard.img): The option 'gpt' is deprecated. Use 'partition-table-type' instead
INFO: cmd: "mkdir -p "/output/images"" (stderr):
INFO: hdimage(sdcard.img): adding partition 'fsbl1' (in MBR) from 'tf-a-stm32mp157a-avenger96.stm32' ...
INFO: hdimage(sdcard.img): adding partition 'fsbl2' (in MBR) from 'tf-a-stm32mp157a-avenger96.stm32' ...
INFO: hdimage(sdcard.img): adding partition 'ssbl' (in MBR) from 'u-boot.stm32' ...
INFO: hdimage(sdcard.img): adding partition 'rootfs' (in MBR) from 'rootfs.ext4' ...
INFO: hdimage(sdcard.img): adding partition '[MBR]' ...
INFO: hdimage(sdcard.img): adding partition '[GPT header]' ...
INFO: hdimage(sdcard.img): adding partition '[GPT array]' ...
INFO: hdimage(sdcard.img): adding partition '[GPT backup]' ...
INFO: hdimage(sdcard.img): writing GPT
INFO: hdimage(sdcard.img): writing protective MBR
INFO: hdimage(sdcard.img): writing MBR
➜  buildroot-docker git:(main) ✗ 
```

The build output is contained in the $PWD/output directory:

```
➜  buildroot-docker git:(main) ✗ find output/target/boot 
output/target/boot
output/target/boot/zImage
output/target/boot/stm32mp157a-dhcor-avenger96.dtb
output/target/boot/extlinux
output/target/boot/extlinux/extlinux.conf
➜  buildroot-docker git:(main) ✗ 
```
