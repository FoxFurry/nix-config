# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

let
  openrgb-rules = builtins.fetchurl {
    url = "https://gitlab.com/CalcProgrammer1/OpenRGB/-/raw/ca3c2ad54188c604c7626136ceda574e9fde3bc0/60-openrgb.rules";
    sha256 = "0s0cdjdc5yndzwl0l2lccbqv08r0js7laln0slncb7h1lj6k5imf";
  };
in {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "i2c-dev" "i2c-piix4" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/67c9c85e-5cdd-451f-9ac9-081c3829e631";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/00DB-4957";
      fsType = "vfat";
    };

  swapDevices = [ ];
  services.udev.extraRules = builtins.readFile openrgb-rules;
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp12s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp14s0u4u1i5.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp13s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
