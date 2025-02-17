# My arch linxu development environment

```

                          $$\   $$\ $$$$$$$$\ $$\   $$$$$$$$\  $$$$$$\                          
                          $$ |  $$ |$$  _____|$$ |  \__$$  __|$$  __$$\                         
                          $$ |  $$ |$$ |      $$ |     $$ |   $$ /  $$ |                        
                          $$$$$$$$ |$$$$$\    $$ |     $$ |   $$ |  $$ |                        
                          $$  __$$ |$$  __|   $$ |     $$ |   $$ |  $$ |                        
                          $$ |  $$ |$$ |      $$ |     $$ |   $$ |  $$ |                        
                          $$ |  $$ |$$$$$$$$\ $$$$$$$$\$$ |    $$$$$$  |                        
                          \__|  \__|\________|\________\__|    \______/                         
 $$$$$$\                      $$\             $$\                      $$\              $$\ $$\ 
$$  __$$\                     $$ |            \__|                     $$ |             $$ |$$ |
$$ /  $$ | $$$$$$\   $$$$$$$\ $$$$$$$\        $$\ $$$$$$$\   $$$$$$$\$$$$$$\   $$$$$$\  $$ |$$ |
$$$$$$$$ |$$  __$$\ $$  _____|$$  __$$\       $$ |$$  __$$\ $$  _____\_$$  _|  \____$$\ $$ |$$ |
$$  __$$ |$$ |  \__|$$ /      $$ |  $$ |      $$ |$$ |  $$ |\$$$$$$\   $$ |    $$$$$$$ |$$ |$$ |
$$ |  $$ |$$ |      $$ |      $$ |  $$ |      $$ |$$ |  $$ | \____$$\  $$ |$$\$$  __$$ |$$ |$$ |
$$ |  $$ |$$ |      \$$$$$$$\ $$ |  $$ |      $$ |$$ |  $$ |$$$$$$$  | \$$$$  \$$$$$$$ |$$ |$$ |
\__|  \__|\__|       \_______|\__|  \__|      \__|\__|  \__|\_______/   \____/ \_______|\__|\__|

```

This is my arch linux development and dotfile repository

## Install

### Installation script selections

- Boot loader: grub
- Profile: Minial install
- Sound device: pipewire
- Network: Network manager
- Language: English with Swedish keyboard
- Extra packages: git, vim, wget

### Run the install script

```bash

wget  https://raw.githubusercontent.com/helto4real/arch_dotfiles/refs/heads/main/setup.sh 
sudo chmod +x ./setup.sh
./setup.sh

```

### Manual post installation steps

#### set ip address

```bash
nmcli con mod "Wired connection 1" ipv4.addresses "[ip]/24"
nmcli con mod "Wired connection 1" ipv4.gateway "[ip]"
nmcli con mod "Wired connection 1" ipv4.dns "[ip]"
nmcli con mod "Wired connection 1" ipv4.method "manual"
nmcli con up "Wired connection 1"
```

#### Decrypt and add fstab file from this repo
- Decrypt and add the pasword files in ~/
- Run sudo mount -a to mount the drives

#### Import gpg public key to make signing with yubikey possible
```bash
gpg --armor --import /mnt/win-d/key.pub
```

#### Fix time to use local time so we have the correct time in windows
```bash
sudo timedatectl set-timezone Europe/Stockholm
sudo timedatectl set-local-rtc 1 --adjust-system-clock
```

#### For some apps you need to force them to use wayland, like electron apps
```bash
mkdir -p ~/.local/share/applications
# Fix discord to use wayland
cp /usr/share/applications/discord.desktop ~/.local/share/applications/
```

nvim intom the discord.desktop file and change the following line
`Exec=/usr/bin/discord --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland`

### Important, Nvidia drivers
This script installs nvidia drivers for moderna cards, you need to do post installation steps before first reboot, see `nvidia.md` for details!!


### Wireguard setup

1. Install wireguard tools
´´´bash
yay -S wireguard-tools
´´´
2. Download the config from the VPN provider
3. Start wireguard with
´´´bash
wg-quick up /path/to/config
´´´
4. Stop it with 
´´´bash
wg-quick down
´´´
