## Sean Malloy's Dotfiles

### Install Instructions
```
$ brew install wget # only for Mac OSX
$ wget -O ~/install.sh https://github.com/seanmalloy/dotfiles/raw/master/install.sh
$ bash ~/install.sh
```

#### Install Behind Proxy
```
$ https_proxy="proxy.example.com:3128" wget -O ~/install.sh https://github.com/seanmalloy/dotfiles/raw/master/install.sh
$ bash ~/install.sh
```

#### Tmuxinator Install
```
$ gem install --user-install --bindir ~/tech/usr/local/bin/ tmuxinator
```

#### Install bat
```
# dnf install bat
```

#### Install Power Line Fonts
For Fedora.
```
# dnf install powerline-fonts
```

For Mac OSX.
1. Download https://github.com/powerline/fonts
2. Run `install.sh`
3. In iTerm2 change font(Preferences > Profiles > Text)

#### Install Neovim Plugins
Run `:PlugInstall` command in nvim.

#### Mac OSX Install
Setup brew in $HOME.
```
$ cd ~/tech
$ git clone https://github.com/Homebrew/brew.git
$ cd brew
$ git checkout 1.6.9
$ brew update
```

Install packages.
```
$ brew install bat the_silver_searcher tmux tmuxinator shellcheck gh
$ brew install coreutils findutils gnu-tar gnu-sed gawk gnu-indent gnu-getopt grep
$ brew tap discoteq/discoteq
$ brew install flock
```

Install Neovim.
```
$ rm -rf ~/tech/nvim-osx64
$ tar xzf nvim-macos.tar.gz -C ~/tech
```

### PuTTY Configuration
When using PuTTY the "remote character set" option must be set to UTF-8. This makes the tmux window separator appear as a line instead of a bunch of random characters. 
![My image](http://seanmalloy.github.io/dotfiles/putty_config.png)

### Other Useful Tools Not Included
* ack
* cpustat
* govc
* govendor
* lnav
* memo
* rg
