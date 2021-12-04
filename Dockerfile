ARG SSH_PASSWORD

FROM ubuntu:20.04
MAINTAINER Ronald Ng "https://github.com/ronalddddd"

ENV SSH_PASSWORD ${SSH_PASSWORD:-happymeal}
ENV DEBIAN_FRONTEND noninteractive

# Install OpenSSH Server, Git, etc...
RUN apt-get update -y && apt-get install -y openssh-server git curl
# SSH run dir
RUN mkdir /var/run/sshd
# Setup SSH Password
RUN echo "root:$SSH_PASSWORD" | chpasswd
RUN sed -i 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Install node.js
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y wget
RUN wget -qO- https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --yes nodejs
## Install yarn
RUN npm install -g yarn

# Vim stuff
RUN apt-get install -y vim

## Vim configurations
ADD vimrc /root/.vimrc

## Vundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim

## Color Schemes
RUN mkdir -p /root/.vim/colors
RUN git clone https://github.com/NLKNguyen/papercolor-theme.git /tmp/theme1
RUN mv /tmp/theme1/colors/* /root/.vim/colors/.

## Install the vundle plugins
RUN vim +PluginInstall +qall

## YouCompleteMe
#RUN apt-get install -y build-essential cmake python-dev python3-dev
#RUN /root/.vim/bundle/YouCompleteMe/install.py --js-completer

## Create DIR for swap files
RUN mkdir -p /root/.vim/swap
RUN mkdir -p /root/.vim/backup
RUN mkdir -p /root/.vim/undo

# Locale
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Mosh: the mobile shell - keeps the session alive if the client goes to sleep and wakes up later, or temporarily loses its Internet connection
RUN apt-get install -y mosh

# tmux - terminal session multiplexer 
RUN apt-get install -y tmux
ADD tmux.conf /root/.tmux.conf
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN /root/.tmux/plugins/tpm/scripts/install_plugins.sh

# neofetch - displays system info
RUN apt-get install -y neofetch

# zsh
RUN apt-get install -y zsh fonts-powerline
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN chsh -s $(which zsh)

# Other Linux Tools
RUN apt install -y net-tools netcat tree fzf bat

# fzf keybindings
RUN curl https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh > /tmp/key-bindings.zsh
RUN echo "source /tmp/key-bindings.zsh" >> ~/.zshrc

# DevOps Tools

## Ansible
RUN apt install -y software-properties-common
RUN add-apt-repository --yes --update ppa:ansible/ansible
RUN apt install -y ansible

## Terraform
RUN apt-get install -y gnupg software-properties-common curl
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository --yes "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update -y && apt-get install -y terraform
RUN terraform -install-autocomplete

## kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

## helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

## Kompose - convert and run docker compose files as k8s configurations
RUN curl -L https://github.com/kubernetes/kompose/releases/download/v1.17.0/kompose-linux-amd64 -o kompose
RUN chmod +x kompose
RUN mv ./kompose /usr/local/bin/kompose

## DigitalOcean CLI (doctl)
WORKDIR /root
RUN wget https://github.com/digitalocean/doctl/releases/download/v1.66.0/doctl-1.66.0-linux-amd64.tar.gz
RUN tar xf ~/doctl-1.66.0-linux-amd64.tar.gz
RUN mv ~/doctl /usr/local/bin

# Create workspace dir
RUN mkdir /root/workspace
WORKDIR /root/workspace

# Start script
ADD start.sh /root/.

EXPOSE 22 80 443
CMD ["/root/start.sh"]

