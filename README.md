## Sean Malloy's Dotfiles

### Install Instructions
```
$ wget -O ~/install.sh https://github.com/seanmalloy/dotfiles/raw/master/install.sh
$ bash ~/install.sh
```

#### Install Behind Proxy
```
$ https_proxy="proxy.example.com:3128" wget -O ~/install.sh https://github.com/seanmalloy/dotfiles/raw/master/install.sh
$ bash ~/install.sh
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
