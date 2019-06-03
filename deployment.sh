#/bin/bash
set username=$(whoami)
status=1
set dotfile=$(PWD)

newperms() {
sed -i "/#wady101/d" /etc/sudoers
echo "$* #wady101" >> /etc/sudoers ;}


if grep -q "Ubuntu" /etc/os-release 
then
  ##Installation of all package
  newperms "%wheel ALL=(ALL) NOPASSWD: ALL" 
  sudo add-apt-repository -y ppa:jonathonf/texlive-2018 ## Needed for texlive 2018
  sudo apt-get -y update
  sudo apt-get install -y vim vim-gtk tmux zsh fonts-powerline i3 alacritty git xclip feh neofetch npm 
 sudo apt-get install -y gcc make g++ deluge okular ack blueman compton blueman-applet nm-applet gsimplecal emacs texlive 
  sudo apt-get install -y autoconf automake g++ gcc libpng-dev libpoppler-dev libpoppler-glib-dev libpoppler-private-dev libz-dev xzdec perl-doc 
  sudo apt-get install -y nodejs ttfautohint otfcc ##Font packages reqd for dumbass Iosevka 
  echo -en "Task of installing complete Task $status"
  ((status++))
  mkdir orignalfiles

## Fonts 

git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
echo "Please add Font awesome on your own. No downloable avaliable :<"
#unzip unzip fontawesome-free-5.6.3-desktop.zip -d ~/.fonts
wget "https://github.com/be5invis/Iosevka/releases/download/v2.2.1/01-iosevka-2.2.1.zip" || echo "Iosevka download got screwed "
sudo -u "$username" unzip "*iosevka*"  -d /usr/share/fonts/iosevka

wget "https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip" || echo "Hack download got screwed"
sudo -u "$username" unzip "*Hack*"  -d /usr/share/fonts/Hack
fc-cache -f -v
fc-list | grep "Iosevka" || echo "No Iosevka installed"
fc-list | grep "Hack" || echo "No Hack installed"

## Emacs
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cp ../spacemacs ./orignalfiles
cp .spacemacs ../
timeout 5m emacs || timeout 5m emacs 
wget "http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh"
cd $HOME
tlmgr init-usertree
tlmgr update --self --all
# For verifcation : 
# dpkg -L texlive
# kpsewhich packagename.sty
# locate texlive

## Copy all the files
cp  -r ./{.vimrc,.zsh/,.zshrc,.tmux.conf,.wallpaper.jpg,.config/} ../

### Vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c 'PluginInstall' -c 'qa!'

### ZSH
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

wget "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
tar -xvzf *.tar.gz
cd install*
sudo ./install-t1
cd ..
rm -rf install* 
chsh -s /bin/zsh

fi
if grep -q "Arch" /etc/os-release 
then
  ## Have to upload the latest version
  curl -LO larbs.xyz/larbs.sh
  sh larbs.sh
fi
