#/bin/bash
set username=$(whoami)
status=1
set dotfile=$PWD
set -e 
set -x 

RED='\033[0;31m'
NC='\033[0m' # No Color

newperms() {
sed -i "/#wady101/d" /etc/sudoers
echo "$* #wady101" >> /etc/sudoers ;}

tmux_install(){
 sudo apt-get install libevent1-dev >> output.log 
echo -en "${RED} TMUX ${NC} \n" 
 wget 'https://github.com/tmux/tmux/releases/download/2.9a/tmux-2.9a.tar.gz'
tar -xvzf tmux-2.9a.tar.gz
#chmod -R 777 tmux-2.9a
 cd tmux-2.9a/
 ./configure && make
 sudo make install 
 cd ..
 rm -rf tmux-2.9a/
rm tmux*.gz 
 git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/bin/install_plugins; }

fonts_install(){

 git clone https://github.com/powerline/fonts.git --depth=1
 cd fonts
 ./install.sh
 cd ..
 rm -rf fonts
 echo "Please add Font awesome on your own. No downloable avaliable :<"
unzip unzip fontawesome-free-5.6.3-desktop.zip -d ~/.fonts
 wget "https://github.com/be5invis/Iosevka/releases/download/v2.2.1/01-iosevka-2.2.1.zip" || echo "Iosevka download got screwed "
 sudo unzip "*iosevka*"  -d /usr/share/fonts/iosevka

 wget "https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip" || echo "Hack download got screwed"
 sudo unzip "*Hack*"  -d /usr/share/fonts/Hack
 fc-cache -f -v
 fc-list | grep "Iosevka" | echo "${RED} Iosevka installed ${NC} " || echo "${RED} No Iosevka installed ${NC}"
 fc-list | grep "Hack"  | echo "${RED} Hack installed ${NC} " || echo "${RED} No Hack installed ${NC}"
 rm -f 01*.zip
 rm -f Hack*.zip;} 

emacs_install(){
 rm -rf ~/.emacs.d
 git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
 cp ../.spacemacs ./orignalfiles
 cp .spacemacs ../
 timeout 5m emacs || echo "Run emacs seperately\n";} 

if grep -q "Ubuntu" /etc/os-release 
then
  ##Installation of all package
 #  newperms "%wheel ALL=(ALL) NOPASSWD: ALL" 
 # sudo add-apt-repository -y ppa:jonathonf/texlive-2018 ## Needed for texlive 2018
 # sudo add-apt-repository ppa:dawidd0811/neofetch-daily
 #  sudo apt-get -y update
  ##Below line is for our boi - emacs build
touch output.log 
printf "Begin output to logfile ${RED}output.log${NC}\n"

#  cat packages.list | xargs sudo apt-get -y install >> output.log 
   ##Font packages reqd for dumbass Iosevka 
  echo -en "Task of ${RED}installing complete${NC} Task $status"
#   mkdir orignalfiles


### Tmux 
tmux_install 
## Fonts 
fonts_install
## Emacs
emacs_install
# wget "http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh"
# cd $HOME
# tlmgr init-usertree
# tlmgr update --self --all
# For verifcation : 
# dpkg -L texlive
# kpsewhich packagename.sty
# locate texlive

#wget -c 'https://github.com/jwilm/alacritty/releases/download/v0.3.3/Alacritty-v0.3.3-ubuntu_18_04_amd64.deb' 
#dpkg -i Alacritty-v0.3.3-ubuntu_18_04_amd64.deb
## Old version of the terminal. New one (above) need latest stuff. Keep in mind
wget -c 'https://github.com/jwilm/alacritty/releases/download/binaries/Alacritty_amd64.deb'
dpkg -i Alacritty_amd64.deb 

## Copy all the files
cp  -rt  ../ .vimrc .zsh/ .zshrc .tmux.conf .config/ .wallpaper.jpg

### Vim
rm -rf ~/.vim/bundle/Vundle.vim | echo "Vundle has been copied anew" >> output.log
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim 
vim -c 'PluginInstall' -c 'qa!'

### ZSH
cd $HOME
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

#wget "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
#tar -xvzf *.tar.gz
#cd install*
#sudo ./install-t1
#cd ..
#rm -rf install* 
### OneNote support 
#sudo -u "$username" apt update
#sudo -u "$username" apt install snapd
sudo snap install p3x-onenote
chsh -s /bin/zsh

fi
if grep -q "Arch" /etc/os-release 
then
 ## Have to upload the latest version
  curl -LO larbs.xyz/larbs.sh
  sh larbs.sh
fi
