echo "Updating and installing essential tools."
sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove
sudo apt install -y build-essential libssl-dev libffi-dev python3-dev python3-pip xclip

echo "Installing oh my zsh."
sudo rm -r ~/.oh-my-zsh
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sudo rm ~/.zshrc
sudo cp .zshrc ~
chsh -s $(which zsh)

echo "Installing tmux."
sudo apt install -y tmux
sudo mv ~/.tmux.conf ~/.tmux.conf.backup
sudo cp .tmux.conf ~

while getopts t: flag
do
    case "${flag}" in
        t) rasp=${OPTARG};;
    esac
done

if [ $rasp ]
then
  echo "Installing nvim on Raspberry."
  sudo apt install -y snapd
  sudo snap install --classic nvim
  sudo cp /snap/bin/nvim /usr/local/bin/nvim
else
  echo "Installing nvim on PC."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  sudo mv nvim.appimage /usr/local/bin/nvim
  chmod +x /usr/local/bin/nvim
fi

echo "Installing other dependencies."
sudo apt install -y silversearcher-ag
sudo snap install --classic ccls
python3 -m pip install pynvim

cp coc-settings.json ~/.config/nvim/coc-settings.json

echo "Done."
