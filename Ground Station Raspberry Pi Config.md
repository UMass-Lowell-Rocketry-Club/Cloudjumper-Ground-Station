# Ground Station Raspberry Pi Config

These are the steps taken to set up the Ground Station Raspberry Pi and the configuration options set on it. **This document should be updated over time as the configuration changes, including settings, essential configuration files, and .**

## System Information

Information about the Raspberry Pi system itself.

### Hardware Information

| Name    | Specification                    |
|---------|----------------------------------|
| Model   | Raspberry Pi 5                   |
| Memory  | 8 GB                             |
| Storage | 256GB SanDisk Ultra MicroSD card |

### OS Information

| Name       | Specification                 |
|------------|-------------------------------|
| OS         | Raspberry Pi OS Lite (64-bit) |
| OS Version | Debian 13 - Trixie            |
| Hostname   | `raspberryslice2`             |

## Initial Setup

These are the instructions for installing the OS on the Raspberry Pi.

### MicroSD Flashing

For a normal Linux installation, installation media is created and connected to the system and then the user interactively installs the operating system on the computer's internal storage. However, traditionally Raspberry Pi systems run off a removable MicroSD card which is imaged using [Raspberry Pi Imager](https://www.raspberrypi.com/software/). This software installs a Linux operating system on a MicroSD card such that the Raspberry Pi can boot straight from the card, no interactive installation required.

1. Install [Raspberry Pi Imager](https://www.raspberrypi.com/software/) on your computer. On macOS I did this with `brew install --cask raspberry-pi-imager`.
2. Connect the MicroSD card to your computer.
3. Open **Raspberry Pi Imager** and set the following configuration options:
    1. Device: **Raspberry Pi 5**
    2. OS: **Raspberry Pi OS (other) > Raspberry Pi OS Lite (64-bit)**
    3. Storage: *The label for the MicroSD card*
    4. Customization:
        1. Hostname: `raspberryslice2` (connect via [user]@raspberryslice2.local)
        2. Localization:
            1. Capital city: **Washington, D.C. (United States)**
            2. Time zone: **America/New_York**
            3. Keyboard layout: **us**
        3. User:
            1. Username: `rocketry`
            2. Password: *See Principal Software Lead for access*
        4. Wi-Fi:
            1. Select **Open Network**
            2. SSID: `UMassLowell`
        5. Remote access:
            1. Enable SSH: **Yes**
            2. Authentication mechanism: **Use password authentication**
        6. Enable Raspberry Pi Connect: **No**
4. Once all configuration options have been entered, verify the changes and write to the MicroSD card.
5. **Raspberry Pi Imager** may eject the MicroSD card automatically once done imaging, but you should make sure it's ejected before removing it from your computer.

### WiFi Setup

UMass Lowell's main WiFi network is [Eduroam](https://www.uml.edu/it/services/get-connected/wifi-eduroam.aspx), which requires significant configuration on any connected devices. On a Linux device, this requires entering your UMass Lowell credentials on whatever device you connect to, which are then stored on the device. This is a big security risk for the person who enters their credentials, since the device is used by many people. To fix this, UMass Lowell offers a way to register devices by their MAC address for the `UMassLowell` network, which is how the Rocketry Club Pi should be configured. This still ties the Pi to one engineer's UMass Lowell account, but means no credentials are stored on the device.

Plug the MicroSD card into the Pi (there's a slot for it opposite the USB ports), boot it up, and follow [UMass Lowell's Wired Network Instructions](https://uml.service-now.com/esc?id=kb_article&sysparm_article=KB0010254), which apply to the `UMassLowell` network as well. You will need a display and keyboard to connect to the Pi to get its MAC address.

## Essential Configuration

After following the steps in the [Initial Setup](#initial-setup), set the following configuration options **before shutting down the Pi for the first time**. It shouldn't break if they're not set immediately, but they're an essential part of the configuration for security and for problem solving.

### Sudo Password Enforcement

By default, Raspberry Pi OS does not enforce password verification for sudo-user actions. This can be reasonable if the Pi is being used solely as a tinkering device in a secure home network, but in a semi-public location like UMass Lowell this is a security risk. Credit to [ripat](https://forums.raspberrypi.com/viewtopic.php?t=97334#p676504) for this solution to re-enable sudo password enforcement.

1. Edit the `/etc/sudoers.d/010_pi-nopasswd` file to enforce password verification. There should only be one line, which you can comment out.

    ```bash
    # visudo validates sudo file syntax before saving, which makes sure
    # you're not locked out of sudo usage if you mess up
    sudo visudo /etc/sudoers.d/010_pi-nopasswd
    ```

    ```bash
    # /etc/sudoers.d/010_pi-nopasswd
    #rocktry ALL=(ALL) NOPASSWD: ALL
    ```

2. There may also be a `/etc/sudoers.d/90-cloud-init-users` file which prevents password verification. Comment out any relevant rules in this file.

    ```bash
    # Created by cloud-init v. 25.2 on Thu, 04 Dec 2025 14:47:17 +0000

    # User rules for rocketry
    #rocketry ALL=(ALL) NOPASSWD:ALL
    ```

3. Ensure `/etc/sudoers` has the following line somewhere in the file.

    ```bash
    # /etc/sudoers
    ...
    %sudo    ALL=(ALL:ALL) ALL
    ...
    ```

### Hostname Mutability

Raspberry Pi OS Lite (trixie) has a [bug](https://raspberrytips.com/set-new-hostname-raspberry-pi/) that causes `cloud-init` to reset the hostname on every system restart. To make the hostname mutable again, add the following line to `/boot/firmware/user-data`:

```bash
# /boot/firmware/user-data
preserve_hostname: true
```

### SSH Daemon Config

The main **sshd** config file is `/etc/ssh/sshd_config`. This could be edited directly, but it includes a line at the top, `Include /etc/ssh/sshd_config.d/*.conf`, which means any file in `/etc/ssh/sshd_config.d/` with the extension `.conf` will be evaluated first. As such, all sshd config options are stored in **`/etc/ssh/sshd_config.d/sshd_custom_config.conf`:**

```bash
# This file is fully written for the rocketry club pi with help from the following sources:
# - https://www.ssh.com/academy/ssh/sshd_config
# - https://www.raspberrypi.com/documentation/computers/remote-access.html
# - https://www.howtogeek.com/devops/what-is-ssh-agent-forwarding-and-how-do-you-use-it/

# Disable X11 Forwarding, which is a way of running graphical interfaces over
# ssh. After testing it myself, it seems to work some of the time and not other
# times, and is mostly depreciated.
X11Forwarding no

# Enable ssh agent forwarding, which allows ssh keys stored through the user's
# ssh agent to be securely used on the server, when the user chooses to do so
AllowAgentForwarding yes

# Prohibit ssh login as root
PermitRootLogin no
```

## General Configuration

These are the general configuration options set in the Raspberry Pi.

### Settings from CLI

```bash
git config --global user.name "rocketry"
git config --global user.email "rocketry@rocketrypie.local"
```

### Config File Customization

**`~/.bash_aliases`:**

*`.bashrc` includes a line to evaluate `.bash_aliases` as well and recommends placing aliases in `.bash_aliases`.*

```bash
# Alias to reload the default config file in the current terminal session
alias reload="source ~/.bashrc"

# Alias to clear the screen with the command 'c'
alias c="clear"
```

## Installed Software

```bash
# aptitude (apt package search tool)
sudo apt install aptitude

# cmake (multiplatform build tool)
sudo apt install cmake

# GitHub CLI (CLI for managing repositories on GitHub)
sudo apt install gh

# fastfetch (tool to display system logo and info)
sudo apt install fastfetch
```
