#!/usr/bin/env bash
echo "[+] Copying themes to /usr/share/plymouth/themes"

sudo cp -rv cerealkiller /usr/share/plymouth/themes
sudo cp -rv lordnikon /usr/share/plymouth/themes
sudo cp -rv acidburn /usr/share/plymouth/themes
sudo cp -rv crashoverride /usr/share/plymouth/themes

echo "[+] Installing themes in Plymouth"

sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/cerealkiller/cerealkiller.plymouth 107
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/lordnikon/lordnikon.plymouth 108
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/acidburn/acidburn.plymouth 109
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/crashoverride/crashoverride.plymouth 106
echo "[+] Select your theme"
sudo update-alternatives --config default.plymouth 
sudo update-initramfs -u
