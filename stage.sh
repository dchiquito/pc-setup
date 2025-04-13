#!/usr/bin/fish

# Copy stuff from the file system back into the repo.


function stagehome -a file
  echo "$file"
  set parent $(dirname $file)
  mkdir -p home/$parent
  cp -r ~/$file home/$file
end

stagehome ".config/alacritty.toml"

stagehome ".config/neovide"

stagehome ".config/niri/config.kdl"

stagehome ".config/nvim/init.lua"

stagehome ".config/systemd/user/mpvpaper.service"
stagehome ".config/systemd/user/niri.service.wants/mpvpaper.service"

stagehome ".tmux.conf"
