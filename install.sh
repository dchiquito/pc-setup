#!/usr/bin/fish

# Copy stuff from the repo to the file system.
# This is a semi-automated do-nothing script. Anything I don't feel like getting perfect gets a checkbox for you to do manually.

echo "Install list:"
echo "sudo dnf copr enable yalter/niri"
echo "sudo dnf install git htop niri nvim"
echo "Install neovide from https://github.com/neovide/neovide/releases"

echo "Copy fonts to /usr/local/share/fonts/"
echo "Set permissions as per https://docs.fedoraproject.org/en-US/quick-docs/fonts/"

function installhome -a file
  set parent "$(dirname "$file")"
  echo ~/$file
  mkdir -p ~/$parent
  cp -r "home/$file" ~/$file
end

installhome ".config/alacritty.toml"

installhome ".config/neovide"

installhome ".config/niri/config.kdl"

installhome ".config/nvim/init.lua"

installhome ".config/systemd/user/mpvpaper.service"
installhome ".config/systemd/user/niri.service.wants/mpvpaper.service"
echo "start waybar on login (service already exists)"
ln -s /usr/lib/systemd/user/waybar.service ~/.config/systemd/user/niri.service.wants/

echo "wallpaper"
cp -r wallpaper ~/Videos/

echo "TODO factorio desktop entries"

echo "TODO tmux"

echo "TODO sudo nvim"

echo "TODO https://discussion.fedoraproject.org/t/how-to-install-use-polkit-on-sway/148247"
