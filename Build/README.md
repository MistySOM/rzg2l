
# README

## VerifiesLinuxPackage_v3.0.0

### Description

Yocto build container with external download cache.
Builds Yocto kernel, device tree, rootfs and the SDK (when `-e` is submitted to the `./run.sh` script)with Mali GPU driver & video codec.

### Usage

#### build.sh

Execute the script `./build.sh`  to build the OCI container image.

#### run.sh

Upon completion of the build script, start the container by execution of the `run.sh` script to invoke the build of images. It can be supplied with arguments: 

- The `run.sh` script can be supplied with an external path to a directory with `-d /path/to/dir` or `--dpath /path/to/dir` where the Yocto downloads can be cached (it requires about 7.3GB of empty space as of 10/04/2022) so that they do not need to be re-downloaded for every container run (just resubmit the same path).  To allow the container to cache the data, the target directory needs to be writeable by uid and gid 1000 (which is the default user id  & group id of the first user on a Linux system, confirm with `id -u`& `id -g`).
- When no download path is submitted, the container will build the binaries in offline mode, utilizing the data & files that have been downloaded during the container build.  

| Arg | Description |
|-----|-------------|
| `-d` `--dpath` `DIRECTORY`| Path to download cache directory
| `-n` `--no` | Container will start, setup the environment but not auto issue a build but instead start a dev shell |
| `-s` `--sdk` | Container will build the SDK |

##### SDK

The `run.sh` script in addition can be started with the argument `-s` to auto trigger compilation of the SDK after the initial Yocto build has finished.

### Output

After the compilation finishes, the shell in the container will remain active. The output is available in 

-  images: `/home/yocto/rzv2l_bsp_v100/build/tmp/deploy/images/smarc-rzv2l/`

- sdk: `/home/yocto/rzv2l_bsp_v100/build/tmp/deploy/sdk/`

The files in the abbove `images` directory include:

| Description | Filename |
|--------------|------------------------|
| Linux kernel | `Image-smarc-rzv2l.bin` |
| Device tree file |`r9a07g05l2-smarc.dtb` |
| Root filesystem | `<image-name>-smarc-rzv2l.tar.bz2` |
| Boot Loader |`bl2_bp-smarc-rzv2l_pmic.srec` & `fip-smarc-rzv2l_pmic.srec` |
| FlashWriter |`Flash_Writer_SCIF_RZV2L_SMARC_PMIC_DDR4_2GB_1PCS.mot` |



and the resources can simply be copied to the host with `docker cp  NAME:SRC DST` where `NAME` is the name of the running container thata can be retrieved by running `docker ps` on the host.

### Note to WSL users:
Make sure to work with files on Linux mounts (avoid use of mounted Windows partitions)


### Files 
Filesthat get downloaded by the Dockerfile on build are stored under:
Z:\WebDownload\mh11\rzv2l\VerifiedLinuxPackage_v3.0.0

### Run time information
 - `./build.sh` Builds the container image from the Dockerfile and downloads the required files, from the above resource
 - `./run.sh` Will start the container image, upon start, the `exec.sh` script is executed from within the container
     - `exec.sh` invokes `start.sh` which sets up the Yocto build environment inside the container
- after the environment has been setup, `exec.sh` will invoke the bitbake commands required to build the binary files
