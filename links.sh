sudo rm -rf /home/$USER/.config/nvim
sudo rm -rf /home/$USER/.bashrc
sudo rm -rf /home/$USER/.bash_aliases
sudo rm -rf /root/.config/nvim

sudo ln -s /home/$USER/.dotfiles/nvim /home/$USER/.config/
sudo ln -s /home/$USER/.dotfiles/nvim /root/.config/
sudo ln -s /home/$USER/.dotfiles/.bashrc /home/$USER/.bashrc
sudo ln -s /home/$USER/.dotfiles/.bash_aliases /home/$USER/.bash_aliases
