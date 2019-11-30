FROM ubuntu:bionic-20191029
MAINTAINER Ronald Ng "https://github.com/ronalddddd"

ARG SSH_PASSWORD
ENV SSH_PASSWORD ${SSH_PASSWORD:-happymeal}

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
## Install TypeScript
RUN npm install -g typescript
## Install yarn
RUN npm install -g yarn
## Eslint
RUN npm install -g eslint

# Project directory
RUN mkdir /projects

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
RUN apt-get install -y build-essential cmake python-dev python3-dev
RUN /root/.vim/bundle/YouCompleteMe/install.py --js-completer 

## Create DIR for swap files
RUN mkdir -p /root/.vim/backup

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

# kubectl - https://kubernetes.io/docs/tasks/tools/install-kubectl/
RUN apt-get install -y apt-transport-https
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

# Kompose - convert and run docker compose files as k8s configurations
RUN curl -L https://github.com/kubernetes/kompose/releases/download/v1.17.0/kompose-linux-amd64 -o kompose
RUN chmod +x kompose
RUN mv ./kompose /usr/local/bin/kompose

# doctl - DigitalOcean command line tool
RUN curl -sL https://github.com/digitalocean/doctl/releases/download/v1.34.0/doctl-1.34.0-linux-amd64.tar.gz | tar -xzv
RUN mv ./doctl /usr/local/bin

# fluxctl
RUN curl -sL https://github.com/fluxcd/flux/releases/download/1.16.0/fluxctl_linux_amd64 > /usr/local/bin/fluxctl
RUN chmod u+x /usr/local/bin/fluxctl

# Start script
ADD start.sh /root/.

EXPOSE 22 80 443
CMD ["/root/start.sh"]

