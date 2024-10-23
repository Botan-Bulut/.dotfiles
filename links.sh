sudo rm -rf /home/$USER/.config/nvim
sudo rm -rf /home/$USER/.bashrc
sudo rm -rf /home/$USER/.bash_aliases
sudo rm -rf /root/.config/nvim
sudo mkdir /home/$USER/.jupyter/
sudo mkdir /home/$USER/.jupyter/labconfig/
sudo mkdir /home/$USER/.jupyter/lab/
sudo mkdir /home/$USER/.jupyter/lab/user-settings/

sudo ln -s /home/$USER/.dotfiles/nvim /home/$USER/.config/
sudo ln -s /home/$USER/.dotfiles/nvim /root/.config/
sudo ln -s /home/$USER/.dotfiles/.bashrc /home/$USER/.bashrc
sudo ln -s /home/$USER/.dotfiles/.bash_aliases /home/$USER/.bash_aliases
sudo cp /home/$USER/.dotfiles/jupyter_lab_config.py /home/$USER/.jupyter/
sudo cp -r /home/$USER/.dotfiles/@jupyterlab/ /home/$USER/.jupyter/lab/user-settings/
sudo cp -r /home/$USER/.dotfiles/@jupyter-lsp /home/$USER/.jupyter/lab/user-settings/
sudo cp -r /home/$USER/.dotfiles/page_config.json /home/$USER/.jupyter/labconfig/
