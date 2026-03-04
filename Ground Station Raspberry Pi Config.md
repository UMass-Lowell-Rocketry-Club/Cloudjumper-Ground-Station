# Ground Station Raspberry Pi Config

These are the steps taken to set up the Ground Station Raspberry Pi.

## Initial Setup

**Raspberry Pi OS (64-bit)** was installed on the microSD card using **Raspberry Pi Imager**.

### Device Specifications

| Name    | Specification          |
| ------- | ---------------------- |
| Device  | Raspberry Pi 5 B       |
| RAM     | 8 GB                   |
| Storage | 128 GB Samsung microSD |

### OS Customization

- **General**
  - Set hostname: `rocketrypie` (connect via `[user]@rocketrypie.local`)
  - Set username and password: **Yes**
    - Username: `rocketry`
    - Password: *See Principal Software Lead for access*
  - Configure Wireless LAN: **No**
  - Set locale settings: **Yes**
    - Time zone: `America/New_York`
    - Keyboard layout: `us`
- **Services**
  - Enable SSH: **Yes**
    - Use password authentication: **Yes**
    - Allow public-key authentication only: **Yes**
      - *Note: Public-key authentication should be used for any device which will be persistantly available to the internet. The ground station should not be persistantly available.*
- **Options**
  - Play sound when finished: **No**
  - Eject media when finished: **Yes**
  - Enable telemetry: **Yes**

### Setup Instructions

1. Apply OS Customization Settings and click `Next`. Click `Yes` to confirm erasure of existing data on the microSD card. Writing may take some time.
2. One data writing is complete, take the microSD card out of the formatting computer. With the Raspberry Pi disconnected from power, insert the microSD card into the bottom of the Pi, opposite of the USB ports.
3. Connect the Pi to power. Boot up may take a few minutes.

## Settings

### Settings from GUI

*Only settings changed from the default will be logged. Pi must be connected to a display, keyboard and mouse to adjust these settings.*

- **Control Centre**
  - Desktop
    - Picture: `moon.jpg`
    - Show Documents: **Yes**

### Eduroam Configuration

1. Run `ifconfig` on the Pi. Under `lan0` or `wlan0` will be the 12-digit MAC address.
2. Go to the [My Devices Portal](https://www.uml.edu/it/services/get-connected/my-devices-portal.aspx) on a device with your UMass Lowell credentials.
3. Sign into the device portal with your credentials.
4. Click **Add New Device** at the top of the page.
5. Input the Pi's MAC address and name the Pi `rocketrypie`.
6. Click **Create Device**.
7. Click **Finish** or **Start Coverage**.
8. On the Pi, click on the WiFi icon and click `eduroam`.
9. Set **Authentication** to `Protected EAP (PEAP)`.
10. Set **CA certificate** to `(None)`.
11. Check **No CA certificate is required**.
12. Set **Inner Authentication** to `MSCHAPv2`.
13. Set **Username** and **Password** to your UMass Lowell email address and password.
    - *Note: This should be the username and password of a senior engineer*.
14. Click **Connect**.

### Settings from CLI

Type `sudo raspi-config` to enter the **Raspberry Pi Software Configuration Tool**.

- **System Options**
  - Boot: **Console Text console**
    - *Note: Use `startx` to start the desktop*
  - Auto Login: **No**
  - Splash Screen: **Yes**
  - Browser: **Firefox**
- **Advanced Options**
  - Wayland: **X11**

```bash
git config --global user.name "rocketry"
git config --global user.email "rocketry@rocketrypie.local"
```

### Config File Customization

**`~/.bashrc`:**

Uncomment or add the following lines:

```bash
GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
```

**`~/.bash_aliases`:**

*`.bashrc` includes a line to evaluate `.bash_aliases` as well and recommends placing aliases in `.bash_aliases`.*

```bash
# Alias to reload the default config file in the current terminal session
alias reload="source ~/.bashrc"

# Alias to clear the screen with the command 'c'
alias c="clear"
```

**Sudo No-Password Fix**

This causes sudo to enforce password verification. Credit to [ripat](https://forums.raspberrypi.com/viewtopic.php?t=97334#p676504) for the solution.

```bash
sudo usermod -a -G sudo rocketry # add rocketry to the sudo group
sudo visudo /etc/sudoers.d/010_pi-nopasswd
# COMMENT OUT THE FOLLOWING LINE
rocketry ALL=(ALL) NOPASSWD: ALL
sudo visudo /etc/sudoers
# MAKE SURE THE FOLLOWING LINE IS PRESENT
%sudo    ALL=(ALL:ALL) ALL
```

## Installed Software

---

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

## Remote SSH Access

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
