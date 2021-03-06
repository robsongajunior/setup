# Machine SETUP

![Massacote Setup](./doc/img/setup.png)

This is my default configuration that I'm actualy using on my Linux (Fedora23+ || Ubuntu14.04+)


## CLI INSTALL
apt-get === UBUNTU
dnf     === Fedora23+

* sudo [apt-get || dnf] install vim
* sudo [apt-get || dnf] install git
* sudo [apt-get || dnf] install ssh
* sudo [apt-get || dnf] install byobu
* sudo [apt-get || dnf] install htop
* ![Spotify](https://www.spotify.com/br/download/linux/)

## Sublime Text3 install
* wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
* sudo apt-get install apt-transport-https
* echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
* sudo apt-get update && sudo apt-get install sublime-text

- package controll == https://packagecontrol.io/installation
- python3
- .editorconfig
- GIT
- DocBlockr
- CSS3
- SCSS
- ColorHighlighter
- Emmet
- JSFormat
- JavaScriptNext
- JavaScript & NodeJS Snippets
- jQuery
- AlignTab
- AllAutocomplete

## .deb install
* firefox
* google-chrome
* opera
* skype
* dropbox


## tar.bz2 install
* [Firefox developer Edtion](https://www.mozilla.org/pt-BR/firefox/developer/)
  * descompact and copy to /opt/
  * on __/home/[user]/.local/share/applications__ create file [__firefox-dev.desktop__](./firefox-dev.desktop), 

## File Config
* .bashrc
    * source ~/.nvm/nvm.sh;
* [.bash_aliases](./file-config/.bash_aliases) 
* [.vimrc](./file-config/.vimrc)
    * git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


## NodeJS
* https://github.com/creationix/nvm
* npm install -g http-server
* npm install -g harmonic
 

## VM's - mordernIE
* win7 - ie10
    * wget -i https://az412801.vo.msecnd.net/vhd/VMBuild_20131127/VirtualBox/IE10_Win7/Linux/IE10.Win7.For.LinuxVirtualBox.txt
* win7 - ie11
    * wget -i https://az412801.vo.msecnd.net/vhd/VMBuild_20131127/VirtualBox/IE11_Win7/Linux/IE11.Win7.ForLinuxVirtualBox.txt
* win8 - ie10
    * wget -i https://az412801.vo.msecnd.net/vhd/VMBuild_20131127/VirtualBox/IE10_Win8/Linux/IE10.Win8.For.LinuxVirtualBox.txt
* win8.1 - ie11
    * wget -i https://az412801.vo.msecnd.net/vhd/VMBuild_20140402/VirtualBox/IE11_Win8.1/Linux/IE11.Win8.1.For.LinuxVirtualBox.txt

