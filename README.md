# CryptOS: Live OS for cryptocurrencies

- Live operating system (run from DVD or USB stick).

- Relevant tools for cryptocurrencies available.

- Use on an offline computer.

- Inspired by BitKey.

- Based on the amazing NixOS.

- Runs KDE by default.

## Instructions

These are just a preliminary sketch and there are also other ways to use:

1. Use public keys on an online computer to create the transactions.

2. Open an offline computer running CryptOS with the private keys or the wallet
   encrypted on a USB stick.

3. Sign the transactions on CryptOS.

4. Copy the signed transaction to some online device by using a USB stick or by
   scanning the QR code.

5. Check the transaction data (so you don't need to trust CryptOS) and broadcast
   it.

NOTE: The private keys can be stored encrypted on the online computer and
multiple places for backup, but never decrypt them on an online computer. Only
decrypt on the offline computer.


## Description

Available cryptocurrency applications:

- Bitcoin Electrum
- Bitcoin Cash Electron
- Litecoin Electrum
- Monero command-line wallet
- more to come...

## Building

It is recommended to build the ISO image yourself. You can easily even modify
`iso.nix` to suit your needs. But if you want, you can download a pre-built ISO
image from Releases section.

Requirement: nix installed.

Clone this repo and inside the directory, run:

```
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
```

The ISO image can be found in `result/iso/`. Unmount the device you want to
flash the image into. Flash the image to a USB stick:

```
sudo dd bs=4M if=result/iso/<ISO-FILE-NAME> of=/dev/<USB-DEVICE-ID>
```

TODO: How to force building all packages from sources? Would it improve
security in some way?


You can test the built ISO file in a virtual machine. For instance:

```
nix-shell -p qemu_kvm
qemu-img create -f qcow2 foo.img 20G
qemu-kvm -m 1024 -drive file=foo.img -drive file=result/iso/<ISO-FILE-NAME>,format=raw,media=cdrom
```


## TODO

- Disable internet interfaces.

- Add relevant packages. If something is missing from nixpkgs, contribute to upstream.

Contributions are most welcome! Just open issues or make pull requests.
