#!/usr/bin/fish

# Copy stuff from the file system back into the repo.


function stagehome -a file
  echo "$file"
  cp -r ~/$file home/$file
end

stagehome ".config/alacritty.toml"

stagehome ".config/niri/config.kdl"

stagehome ".config/nvim/init.lua"

stagehome ".config/systemd/"
