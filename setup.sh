function puts () {
  echo -e "\n\n---------\n-" $*
}

# https://askubuntu.com/questions/1109982/e-could-not-get-lock-var-lib-dpkg-lock-frontend-open-11-resource-temporari
sudo killall apt apt-get
sudo rm -f /var/lib/apt/lists/lock
sudo rm -f /var/cache/apt/archives/lock
sudo rm -f /var/lib/dpkg/lock*

sudo apt update && sudo apt upgrade -y
sudo apt install -y git tree curl zsh vim zip unzip zstd
sudo apt install -y build-essential libssl-dev libreadline-dev zlib1g-dev

puts "install fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
source ~/.fzf.bash

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

