function puts () {
  echo -e "\n\n---------\n-" $*
}

# https://askubuntu.com/questions/1109982/e-could-not-get-lock-var-lib-dpkg-lock-frontend-open-11-resource-temporari
sudo killall apt apt-get
sudo rm -f /var/lib/apt/lists/lock
sudo rm -f /var/cache/apt/archives/lock
sudo rm -f /var/lib/dpkg/lock*

sudo apt update && sudo apt upgrade -y
sudo apt install -y git tree curl zsh vim zip unzip
sudo apt install -y build-essential libssl-dev libreadline-dev zlib1g-dev

puts "install fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
source ~/.fzf.bash

puts "install anyenv"
git clone https://github.com/anyenv/anyenv ~/.anyenv
echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.profile
echo 'eval "$(anyenv init -)"' >> ~/.profile
source ~/.profile
anyenv install --init
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

puts "install rbenv"
while true; do
  echo -n "Do you want to install rbenv and ruby?  ([y]/n) "
  read -n1 ans
  if [[ $ans =~ ^(y|Y|)$ ]]; then
    anyenv install rbenv
    source ~/.profile
    anyenv install --init
    tag_ver=$(rbenv install -l | fzf)
    if [[ -n $tag_ver ]]; then
      rbenv install $tag_ver
      rbenv global $tag_ver
    fi
    break
  elif [ $ans == "n" ]; then
    break
  fi
done

puts "change shell"
chsh -s $(which zsh)

puts "set DOTFILES"
HERE=$(cd `dirname $0` && pwd)
DOTFILES=( .fzf.zsh .gemrc .pryrc .selected_editor .vimrc .zshenv .zshrc )
for f in ${DOTFILES[@]}; do
  mv -fv $HERE/$f $HOME
  # ln -sfv $HERE/$f $HOME
done

while true; do
  echo -en "\nDo you want to reboot?  ([y]/n) "
  read -n1 ans
  if [[ $ans =~ ^(y|Y|)$ ]]; then
    sudo reboot
  elif [ $ans == "n" ]; then
    break
  fi
done

