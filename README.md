# Sean Malloy's Dotfiles

## Install Instructions
### Linux (Fedora 33)
#### Run Install
```
$ mkdir -p ~/tech/usr/local/bin
$ wget -O ~/rpm-packages.txt https://github.com/seanmalloy/dotfiles/raw/master/rpm-packages.txt
$ sudo dnf install $(cat ~/pm-packages.txt)
$ gem install --user-install --bindir ~/tech/usr/local/bin/ tmuxinator
$ wget -O ~/install.sh https://github.com/seanmalloy/dotfiles/raw/master/install.sh
$ bash ~/install.sh
```

#### Install Neovim Plugins
Run `:PlugInstall` command in nvim.

#### Setup Docker
```
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -aG docker $user
sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
```

### Mac OSX
#### Setup brew in $HOME
```
$ mkdir ~/tech && cd ~/tech
$ git clone https://github.com/Homebrew/brew.git
$ cd brew
$ git checkout 1.6.9
$ brew update
```

#### Install Packages
```
$ brew install bat the_silver_searcher tmux tmuxinator shellcheck shfmt gh jq yq kind helm wget powerline-go neovim fzf kubectx exa
$ brew install coreutils findutils gnu-tar gnu-sed gawk gnu-indent gnu-getopt grep bash bash-completion@2
$ brew tap discoteq/discoteq
$ brew install flock
$ brew tap instrumenta/instrumenta
$ brew install kubeval
```
#### Install additional binaries ~/tech/usr/local/bin
* kubens

#### Install Powerline Fonts
* Download https://github.com/powerline/fonts
* Run `install.sh`
* In iTerm2 change font(Preferences > Profiles > Text)

#### Run Install
```
$ wget -O ~/install.sh https://github.com/seanmalloy/dotfiles/raw/master/install.sh
$ bash ~/install.sh
```

#### Install Neovim Plugins
Run `:PlugInstall` command in nvim.

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
