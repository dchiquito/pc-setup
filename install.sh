#!/usr/bin/fish

# Copy stuff from the repo to the file system.
# This is a semi-automated do-nothing script. Anything I don't feel like getting perfect gets a checkbox for you to do manually.

echo "Install list:"
echo "sudo dnf copr enable yalter/niri"
echo "sudo dnf install git htop niri nvim"
echo "Install neovide from https://github.com/neovide/neovide/releases"

echo "Copy fonts to /usr/local/share/fonts/"
echo "Set permissions as per https://docs.fedoraproject.org/en-US/quick-docs/fonts/"

function install -a parent file
  echo "$parent/$file"
end

install ".config/niri" "config.kdl"
# mkdir -p ~/.config/niri && cp home/.config/niri/config.kdl ~/.config/niri/config.kdl

echo ".config/nvim/init.lua"
# mkdir -p ~/.config/nvim && cp home/.config/nvim/init.lua ~/.config/nvim/init.lua

echo "systemd startup services"
mkdir -p ~/.config/systemd/user/niri.service.wants/
ln -s /usr/lib/systemd/user/waybar.service ~/.config/systemd/user/niri.service.wants/

echo "TODO mpvpaper -o \"no-audio --loop-playlist\" eDP-1 ~/Videos/Wallpaper/"
