#!/usr/bin/fish

# Copy stuff from the repo to the file system.
# This is a semi-automated do-nothing script. Anything I don't feel like getting perfect gets a checkbox for you to do manually.

echo "Install list:"
echo "sudo dnf copr enable yalter/niri"
echo "sudo dnf install git htop niri nvim uv"
echo "Install neovide from https://github.com/neovide/neovide/releases"
echo "Set fish as default shell: chsh -s /usr/bin/fish"

echo "Copy fonts to /usr/local/share/fonts/"
echo "Set permissions as per https://docs.fedoraproject.org/en-US/quick-docs/fonts/"

function installhome -a file
  set parent "$(dirname "$file")"
  echo ~/$file
  mkdir -p ~/$parent
  cp -r "home/$file" ~/$file
end

function installroot -a file
  set parent "$(dirname "$file")"
  echo /$file
  sudo mkdir -p /$parent
  sudo cp -r $file /$file
end

installhome ".config/alacritty.toml"

installhome ".config/neovide"

installhome ".config/niri/config.kdl"

installhome ".config/nvim/init.lua"

installhome ".config/systemd/user/wallpaper.service"
echo "start waybar on login (service already exists)"
ln -s ~/.config/systemd/user/wallpaper.service ~/.config/systemd/user/niri.service.wants/
ln -s /usr/lib/systemd/user/waybar.service ~/.config/systemd/user/niri.service.wants/

installhome ".tmux.conf"

installroot "usr/local/bin/wallpaper.py"

echo "wallpaper"
cp -r wallpaper ~/Videos/

echo "TODO factorio desktop entries"

echo "TODO sudo nvim"

echo "TODO https://discussion.fedoraproject.org/t/how-to-install-use-polkit-on-sway/148247"

echo "TODO second monitor"
