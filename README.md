# pc-setup
The day is April 12, 2025. I've just received two 4TB drives with which to back up my dilapidated PopOS! installation, and I'm starting my journey into the world of Fedora. This is my story.

# First steps
I formatted my drives with btrfs and set them up as RAID 1. I backed up the entire contents of my home folder (400GB!), my factorio saves, and my bootleg copy of Aseprite.

I set up a LiveUSB with Fedora 42 + Sway and let it rip. Hostname `crowley` and username `daniel`, as is tradition. My laptop is now running Fedora, for better or worse.

# Fundamentals
Odds and ends I needed to `dnf install`:
* git
* htop

Things I handily did not need to install:
* tmux
* rg

# Niri
One of the motivations for switching to Fedora was to have sufficiently cutting edge packages to install [Niri](https://github.com/YaLTeR/niri), a funky window manager. i3 is nice and all and I'm told Sway is interchangable, but I wanted to try something fun.
```
sudo dnf copr enable yalter/niri
sudo dnf install niri
```

Niri comes bundled with alacritty, so I don't even need to explicitly install it. Nice.

Niri conveniently allows `xkb` configurations, so I turned Caps Lock into a second Escape for easier vimming and swapped my LAlt and Win keys for easier windowing. I also disabled natural scrolling.

Configuration changes TBD

# nvim
```
sudo dnf install nvim
```
The cooler vim. I have an existing `init.lua` in my old [configurations](https://github.com/dchiquito/configurations/blob/main/home/.config/nvim/init.lua) repo which I copied into this repo and plopped into `~/.config/nvim/init.lua`. Launching `nvim` installed a bunch of plugins automatically, `lazy` worked flawlessly. All my Mason LSPs were manually installed, so I need to think about if I want to just install them willy nilly again or maintain an authoritative list.

TODO why isn't telescope starting in the proper directory

I also like using neovide for IDE work for the smooth scrolling and to keep my terminal window separate from my code editing window, so I installed that too. Unfortunately it's not in dnf, so I had to copy the [binary](https://github.com/neovide/neovide/releases) into `/usr/bin/neovide`. The scroll speed seemed kind of sedate so I adjusted it to be snappier. I also did a `touch ~/.config/neovide` to prevent an obnoxious log message about a missing config every time neovide launched.

## Fonts
Launching neovide revealed several errors caused by the Cousine font being missing. I copied the files from `configurations` into this repo and thence into `/usr/local/share/fonts/`, following the [official instructions](https://docs.fedoraproject.org/en-US/quick-docs/fonts/). This solved the `Cousine` problem, but I had the fallback font set to `Fira Mono`, which is apparently shipped in Ubuntu but not Fedora. Removing `Fira Mono:h8` from the `guifont` option in `init.lua` fixed it. The system fallback mono font will be fine.

# Keymap
My keyboard is rather suboptimal. To the left of my space bar are the various mod keys: `Ctrl`, `Fn` `Mod/Window`, and `Alt`. The sensible default for window managers to switch workspaces is `Mod+1-9`, which involves hitting `Mod` with my thumb. Reaching past `Alt` to do this is annoying, so previously I was using `xmodmap` to swap those keys. I also mapped `Caps Lock` to `Esc` for easier vimming. Sadly, `xmodmap` is kinda hacky, so this time I'm going to set up a custom [keymap](https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration#Keymaps) for this specific keyboard.

Psych! Niri is actually really great and has an extremely convenient `xkb` setting that allows specifying common modifications. It was as easy as setting `options "caps:escape,altwin:swap_alt_win"`. I added that to the niri config.

# Sick wallpaper
Another motivation for reinstalling was for Wayland so I could do some sick animated wallpapers.

First step is to install OBS and capture some video. This required installing some non-free codecs and setting up the RPMFusion repository to get `libavcodec-freeworld`.

Next I built and installed https://github.com/GhostNaN/mpvpaper to play the videos. Some magic words are required to invoke it:
```
mpvpaper -o "no-audio --loop-playlist" eDP-1 ~/Videos/Wallpaper/
```

Put some transparency on alacritty and neovide, set up a systemd user service to start it on login, and we're all set!


