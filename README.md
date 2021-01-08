# CryptOS: Live offline OS for cryptocurrencies

- Run directly from a DVD or USB stick securely without internet
  connection.

- Includes relevant tools for cryptocurrencies.

- Inspired by [BitKey](https://bitkey.io/).

- Based on the amazing [NixOS](https://nixos.org/). CryptOS is just NixOS with a
  specific configuration.

- Runs [XFCE](https://xfce.org/) by default.


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
nix-build
```

By default, a pinned version of nixpkgs is used. If you don't want to use the
pinned version of NixOS and nixpkgs, modify `nixpkgs` in `default.nix`. For
instance, if you want to use the nixpkgs of your own system, set:

```
nixpkgs ? <nixpkgs>
```

Also, it is possible to to just provide path to your locally checked out
nixpkgs:

```
nixpkgs ? "/path/to/nixpkgs"
```

To build 32-bit ISO image, modify `system` to `i686-linux`.

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

- Add relevant packages. If something is missing from nixpkgs, contribute to
  upstream.

- How to force building all packages from sources? Would it improve security in
  some way?


## Disclaimer

No guarantees about the security of the software is given. Use it at your own
risk.


## Contributing

Contributions are most welcome! Just open issues or make pull requests.


## Usage

**NOTE:** On old computers, one may need to use 32-bit version and also enter
`forcepae` kernel option during boot time. If you need to add `forcepae` option,
press Tab when distro options are listed after boot and then append ` forcepae`
to the string.

In general, keep view keys in an online computer and spend keys (encrypted) in
some USB stick so the offline live CryptOS can read the spend keys and sign
transactions.


### Bitcoin (Electrum)

#### Create a wallet (offline live CryptOS)

TODO

#### Set up a view-only wallet (online computer)

TODO

#### Create a transaction (online computer)

1. Start Electrum.

2. Create the transaction in "Send" tab and press "Pay". Note that Electrum uses
   mBTC (milli-bitcoin) units.

3. Fee dialog opens, choose the transaction fee and click "Send".

4. A window showing the transaction pops up. Choose "Export" -> "Export to
   file". Choose ".txn" file type, not ".psbt", and save the file to the USB
   stick (or save elsewhere and then copy to a USB stick). Safely remove the USB
   stick.

#### Sign the transaction (offline live CryptOS)

1. Start Electrum ("Applications" -> "Internet" -> "Electrum Bitcoin Wallet").
   For the start-up wizard choose auto-connecting to a server and browse your
   spend wallet file from a USB stick (this might be a different USB stick than
   the one with the transaction file).

2. Load the transaction by selecting "Tools" -> "Load transaction" -> "From
   file" from menu and choosing the unsigned transaction file from the USB stick
   (or copy the file from the USB stick elsewhere and load that file).

3. Check that the transaction is correct and then sign it by pressing "Sign" and
   entering the wallet password.

4. Save the signed transaction to the USB stick by choosing "Save" and remove
   the USB stick.

#### Broadcast the transaction (online computer)

1. Load the signed transaction by choosing "Tools" -> "Load transaction" ->
   "From file" from Electrum menu and choosing the signed transaction file from
   the USB stick (or, again, first copy the file from the USB elsewhere and then
   load that file).

2. Check that the signed transaction file is still correct.

3. Broadcast the transaction by choosing "Broadcast".


### Monero

#### Create a spend wallet (offline live CryptOS)

TODO

#### Set up a view-only wallet (online computer)

TODO

#### Create a transaction (online computer)

1. Start `monero-wallet-cli --daemon-address node.moneroworld.com:18089` from
   the command line.

2. Enter file path to the view wallet, for instance, `path/to/view-wallet`.

3. Create a transaction, for instance, `transfer ADDRESS_HERE AMOUNT_HERE
   PAYMENT_ID`. To move all funds, use `sweep_all ADDRESS_HERE PAYMENT_ID`.
   Note that the payment ID might not be required if, for instance, sending
   funds to yourself.

4. The transaction is saved in `unsigned_monero_tx` file under the directory
   you are running the Monero wallet.

5. Copy the unsigned transaction file to a USB stick.

#### Sign the transaction (offline live CryptOS)

1. Copy the unsigned transaction file from the USB stick.

2. Copy the spend wallet files from a USB stick (can be the same or a different
   stick). Copy the two files `spend-wallet` and `spend-wallet.keys`, where
   `spend-wallet` is replaced with the name of your wallet.

3. Start `monero-wallet-cli` from the command line in the same directory as the
   wallet and transaction files are located.

4. Enter the name of the spend wallet file, for instance, `spend-wallet`.

5. Sign the transaction with `sign_transfer`.

6. Copy the signed transaction file `signed_monero_tx` to the USB stick.

7. Exit Monero wallet with `q` and shut down CryptOS. (Or shut down CryptOS only
   after successfull broadcasting in case you need to make some fixes on
   CryptOS.)

#### Broadcast the transaction (online computer)

1. Copy the signed transaction file from the USB stick to the same directory
   you are running the Monero wallet.

2. Broadcast the transaction with `submit_transfer`.

3. Exit Monero wallet with `q`. Optionally, delete the signed and unsigned
   transaction files from your computer and the USB stick.
