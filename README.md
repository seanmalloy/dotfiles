# Sean Malloy's Dotfiles

## Install Instructions
### Linux (Fedora 33)
#### Run Install
```
$ mkdir -p ~/tech/usr/local/bin
$ wget -O ~/rpm-packages.txt https://github.com/seanmalloy/dotfiles/raw/master/rpm-packages.txt
$ sudo dnf install $(cat ~/rpm-packages.txt)
$ gem install --user-install --bindir ~/tech/usr/local/bin/ tmuxinator
$ wget -O ~/install.sh https://github.com/seanmalloy/dotfiles/raw/master/install.sh
$ bash ~/install.sh
```

#### Install Neovim Plugins and LSP Servers For Neovim
Run `:PlugInstall` command in nvim.
```
go install golang.org/x/tools/gopls@latest
pip install 'python-lsp-server[all]'
rustup component add rls rust-analysis rust-src
```

#### Setup Docker
```
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -aG docker $user
sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
```

#### Pyenv
```
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
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
$ brew install $(cat ~/brew-packages.txt)
$ brew tap discoteq/discoteq
$ brew tap instrumenta/instrumenta
$ $HOME/brew/opt/fzf/install # for shell completions
```
#### Install additional binaries ~/tech/usr/local/bin
* kubens

```
xattr -r -d com.apple.quarantine ~/tech/usr/local/bin/
```

#### Install Powerline Fonts
* Download https://github.com/powerline/fonts
* Run `install.sh`
* In iTerm2 change font(Preferences > Profiles > Text)

#### Run Install
```
$ wget -O ~/install.sh https://github.com/seanmalloy/dotfiles/raw/master/install.sh
$ bash ~/install.sh
```

#### Install Neovim Plugins and LSP Servers For Neovim
Run `:PlugInstall` command in nvim.
```
go install golang.org/x/tools/gopls@latest
pip install 'python-lsp-server[all]'
rustup component add rls rust-analysis rust-src
```

### PuTTY Configuration
When using PuTTY the "remote character set" option must be set to UTF-8. This makes the tmux window separator appear as a line instead of a bunch of random characters. 
![My image](http://seanmalloy.github.io/dotfiles/putty_config.png)

###
Install Rust.
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | RUSTUP_HOME=~/tech/rust/.rustup CARGO_HOME=~/tech/rust/.cargo sh
```

### Other Useful Tools Not Included
* ack
* cpustat
* govc
* govendor
* lnav
* memo
* rg
