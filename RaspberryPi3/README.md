# RaspberryPi3

Overview

This folder contains Raspberry Pi 3 setup instructions, scripts, wiring diagrams, and any special OS images used for the demos.

Quickstart

1. Download Raspberry Pi OS Lite (or Desktop if GUI needed) and flash to an SD card with BalenaEtcher or Raspberry Pi Imager.
2. Before first boot, enable SSH by creating an empty file named `ssh` in the boot partition and add `wpa_supplicant.conf` for Wi-Fi if needed.
3. Boot the Pi and log in (default: `pi` / `raspberry`) and update:

   sudo apt update; sudo apt upgrade -y

4. Install project dependencies (examples):

   sudo apt install -y python3-pip git
   python3 -m pip install --user -r requirements.txt

Common tasks

- Set hostname (optional):

   sudo raspi-config

- Enable interfaces (e.g., I2C, SPI) via `raspi-config` if sensors or motor controllers require them.

Headless setup example (Windows PowerShell):

# After flashing image and mounting the SD boot partition
New-Item -Path $env:USERPROFILE\Desktop\sdcard\ssh -ItemType File
# Create wpa_supplicant.conf with proper contents for your Wi-Fi network

How it works

- The Pi runs scripts that either stream sensor data to the main demo station or accept control commands (via MQTT, REST, or sockets).
- Keep system services in `systemd` unit files for reliable autostart.

Files and structure

- `setup/` — Scripts to provision the SD card and basic OS configuration.
- `src/` — Project-specific code and scripts.
- `images/` — Any custom disk images (do not commit large binary images to git; reference them instead).

Security notes

- Change the default password and use SSH keys for access.
- If connected to campus network, ensure firewall rules and only necessary ports open.

Troubleshooting

- If a service won't start, inspect `journalctl -u <service>` and `dmesg` for hardware errors.

