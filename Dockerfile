# ubuntu
FROM ubuntu:16.04
EXPOSE 3000

# Better terminal support
ENV TERM screen-256color
ENV DEBIAN_FRONTEND noninteractive

# Locales
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8

RUN apt-get update && apt-get upgrade -y

# Common packages
RUN apt-get update && apt-get install -y \
      bash \
      build-essential \
      ctags \
      curl \
      git  \
      htop \
      iputils-ping \
      jq \
      libssl-dev \
      libevent-dev \
      libncurses5-dev \
      net-tools \
      netcat-openbsd \
      npm \
      python-software-properties \
      ranger \
      ruby-dev \
      rubygems \
      shellcheck \
      socat \
      software-properties-common \
      tzdata \
      wget \
      vim \
      xclip \
      zsh

# Change shell to zsh
RUN chsh -s /usr/bin/zsh

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs

# Add custom repos
RUN add-apt-repository ppa:neovim-ppa/stable

# Install custom packages
RUN apt-get update && apt-get install -y \
      neovim

# Install Python
RUN apt-get update && apt-get install -y \
      python-dev \
      python-pip \
      python2.7-dev \
      python-pip \
      python3-dev \
      python3-pip

RUN pip install --upgrade pip
RUN pip install neovim

RUN pip2 install --upgrade pip
RUN pip2 install neovim

RUN pip3 install --upgrade pip
RUN pip3 install neovim

# copy configs over from local
ADD dotfiles/vim.symlink /root/.config/nvim
ADD dotfiles/vim/vimrc.symlink /root/.config/nvim/init.vim
ADD dotfiles/zsh/zshrc.symlink /root/.zshrc
ADD dotfiles/bin /usr/local/bin
ADD .wakatime.cfg /root/.wakatime.cfg

# install ruby gems
RUN gem install python
RUN gem install neovim

# npm installs
RUN npm install -g neovim
RUN npm install -g gulp

# Install vim-plug
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install neovim plugins
RUN nvim -i NONE -c PlugInstall -c quitall > /dev/null 2>&1
RUN nvim -i NONE -c UpdateRemotePlugins -c quitall > /dev/null 2>&1

RUN node -v && nodejs -v && npm -v && gulp -v

# Command for the image
WORKDIR /src
CMD ["/bin/bash"]
