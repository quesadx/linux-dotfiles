{ config, host, pkgs, lib, ... }:

let
  isMacbookPro141 = host.hostname == "macbook-pro";
  driverVersion = "ca3ff74436029a960d85018459e79dd97e08dfbe";

  sndHdaCirrus =
    if isMacbookPro141 then
      pkgs.stdenv.mkDerivation {
        pname = "snd-hda-cirrus";
        version = driverVersion;

        src = pkgs.fetchgit {
          url = "https://github.com/davidjo/snd_hda_macbookpro";
          rev = driverVersion;
          hash = "sha256-NKOkK9oQBJEwsfpG5fF/373qK8VSJa1XDIb6jrg/IWI=";
        };

        hardeningDisable = [ "pic" ];
        nativeBuildInputs = config.boot.kernelPackages.kernel.moduleBuildDependencies;

        NIX_CFLAGS_COMPILE = [
          "-g"
          "-Wall"
          "-Wno-unused-variable"
          "-Wno-unused-function"
        ];

        makeFlags =
          (lib.filter (
            flag:
              !(lib.hasPrefix "O=" flag)
              && !(lib.hasPrefix "--eval=" flag)
          ) config.boot.kernelPackages.kernel.makeFlags)
          ++ [
            "INSTALL_MOD_PATH=${placeholder "out"}"
            "KERNELRELEASE=${config.boot.kernelPackages.kernel.modDirVersion}"
            "KERNELBUILD=${config.boot.kernelPackages.kernel.dev}/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/build"
          ];

        postPatch = ''
          mkdir -p build
          if [ -d ${config.boot.kernelPackages.kernel.src} ]; then
            cp -r ${config.boot.kernelPackages.kernel.src}/sound/hda build/
          else
            tar -xf ${config.boot.kernelPackages.kernel.src} \
              -C build \
              --strip-components=2 \
              "linux-${config.boot.kernelPackages.kernel.modDirVersion}/sound/hda"
          fi

          chmod -R u+w build/hda

          hda_dir="build/hda"
          makefiles_dir="makefiles"
          patch_dir="patch_cirrus"

          mv "$hda_dir/Makefile" "$hda_dir/Makefile.orig"
          mv "$hda_dir/common/Makefile" "$hda_dir/common/Makefile.orig"
          mv "$hda_dir/codecs/Makefile" "$hda_dir/codecs/Makefile.orig"
          mv "$hda_dir/codecs/cirrus/Makefile" "$hda_dir/codecs/cirrus/Makefile.orig"

          cp "$makefiles_dir/Makefile" "$hda_dir"
          cp "$makefiles_dir/Makefile_common" "$hda_dir/common/Makefile"
          cp "$makefiles_dir/Makefile_codecs" "$hda_dir/codecs/Makefile"
          cp "$makefiles_dir/Makefile_cirrus" "$hda_dir/codecs/cirrus/Makefile"

          cp "$patch_dir/cirrus_apple.h" "$hda_dir/codecs/cirrus"
          cp "$patch_dir/patch_cirrus_boot84.h" "$hda_dir/codecs/cirrus"
          cp "$patch_dir/patch_cirrus_new84.h" "$hda_dir/codecs/cirrus"
          cp "$patch_dir/patch_cirrus_real84.h" "$hda_dir/codecs/cirrus"
          cp "$patch_dir/patch_cirrus_hda_generic_copy.h" "$hda_dir/codecs/cirrus"
          cp "$patch_dir/patch_cirrus_real84_i2c.h" "$hda_dir/codecs/cirrus"

          cd build/hda
          patch -b -p1 < ../../patch_cs8409.c.diff
          patch -b -p1 < ../../patch_cs8409.h.diff
          cd -

          cat > Makefile << 'EOF'
          subdir-ccflags-y += -I$(shell pwd)/common
          snd-hda-codec-cs8409-objs := codecs/cirrus/patch_cs8409.o codecs/cirrus/patch_cs8409-tables.o
          obj-$(CONFIG_SND_HDA_CODEC_CS8409) += snd-hda-codec-cs8409.o

          KBUILD_EXTRA_CFLAGS = "-DAPPLE_PINSENSE_FIXUP -DAPPLE_CODECS -DCONFIG_SND_HDA_RECONFIG=1"

          all:
          	make -C $(KERNELBUILD) CFLAGS_MODULE=$(KBUILD_EXTRA_CFLAGS) M=$(shell pwd)/build/hda modules

          clean:
          	make -C $(KERNELBUILD) M=$(shell pwd)/build/hda clean

          install:
          	make -C $(KERNELBUILD) M=$(shell pwd)/build/hda INSTALL_MOD_PATH=$(INSTALL_MOD_PATH) modules_install
          EOF
        '';

        meta = {
          platforms = lib.platforms.linux;
        };
      }
    else
      null;
in
{
  config = lib.mkIf isMacbookPro141 {
    # Force legacy HDA path and load patched CS8409 codec module for MBP 14,1 speakers.
    boot.kernelParams = [ "snd_intel_dspcfg.dsp_driver=1" ];
    boot.extraModulePackages = [ sndHdaCirrus ];
    boot.kernelModules = [ "snd_hda_codec_cs8409" ];
  };
}
