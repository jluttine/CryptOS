# CryptOS: Secure live offline OS for cryptocurrencies

- Run directly from a DVD or USB stick securely without internet
  connection.

- Includes relevant tools for cryptocurrencies.

- Inspired by [BitKey](https://bitkey.io/).

- Based on the amazing [NixOS](https://nixos.org/). CryptOS is just NixOS with a
  specific configuration.

- Runs [KDE](https://www.kde.org/) by default.


## Instructions

The following sketched steps explain one way to use CryptOS:

1. Use public keys on an online computer to create the transactions. Store them
   on a USB stick with encrypted private keys.

2. Open an offline computer running CryptOS from another USB stick.

3. Read and sign the transactions on CryptOS.

4. Copy the signed transaction to some online device by using the USB stick or by
   scanning the QR code.

5. Check the transaction data (so you don't need to trust CryptOS) and broadcast
   it.

NOTE: The private keys can be stored encrypted on the online computer and
multiple places for backup, but never decrypt them on an online computer. Only
decrypt on the offline computer.


## Description

Available cryptocurrency applications:

- [Bitcoin Electrum](https://electrum.org/)
- [Bitcoin Cash Electron](https://electroncash.org/)
- [Litecoin Electrum](https://electrum-ltc.org/)
- [Monero command-line wallet](https://getmonero.org/)
- more to come...


## Building

It is recommended to build the ISO image yourself. You can easily even modify
`iso.nix` to suit your needs. But if you want, you can download a pre-built ISO
image from Releases section.

Requirement: nix installed.

Clone this repo:

```
git clone https://github.com/jluttine/CryptOS.git
cd CryptOS
```

Build the ISO image:

```
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
```

The ISO image can be found in `result/iso/`. You can test the built ISO file in
a virtual machine. For instance:

```
nix-shell -p qemu_kvm
qemu-img create -f qcow2 foo.img 20G
qemu-kvm -m 1024 -drive file=foo.img -drive file=result/iso/<ISO-FILE-NAME>,format=raw,media=cdrom
```

Unmount the device you want to flash the image into. Flash the image to a USB
stick:

```
sudo dd bs=4M if=result/iso/<ISO-FILE-NAME> of=/dev/<USB-DEVICE-ID>
```


## TODO

- Add relevant packages. If something is missing from nixpkgs, contribute to upstream.

- How to force building all packages from sources? Would it improve security in
  some way?


## Contributing

Contributions are most welcome! Just open issues or make pull requests.
