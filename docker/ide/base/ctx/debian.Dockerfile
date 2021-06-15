FROM golang:buster

# Official Debian and Ubuntu images automatically run apt-get clean, so explicit invocation is not required.
# Set up to install docker and fish
RUN apt-get update && apt-get install --no-install-recommends --yes \
    apt-transport-https ca-certificates curl gnupg lsb-release \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' | tee /etc/apt/sources.list.d/shells:fish:release:3.list \
    && curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null

# Install docker and other packages
# line starting with `libevent-dev ...` is required to compile tmux
RUN apt-get update && apt-get install --no-install-recommends --yes \
    sudo less man locales openssh-client fish \
    libevent-dev ncurses-dev build-essential bison pkg-config \
    docker-ce docker-ce-cli containerd.io python3-pip \
    git keychain fzf \
    && rm -rf /var/lib/apt/lists/*

# Without this, `man` complains that $LC_* is not set
ENV LANG=en_US.UTF-8
RUN sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=$LANG

RUN python3 -m pip install --upgrade pip setuptools \
    && pip3 install docker-compose

# Install latest version of nvim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
    && chmod u+x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && find squashfs-root/ -type d -exec chmod 755 {} \; \
    && mv squashfs-root / \
    && ln -s /squashfs-root/usr/bin/nvim /usr/bin/nvim \
    && rm ./nvim.appimage

# Install latest version of tmux
ARG TMUX_VERSION
RUN curl -LO https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz \
    && tar xf tmux-${TMUX_VERSION}.tar.gz \
    && cd tmux-${TMUX_VERSION} \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && cd .. \
    && rm -rf tmux-${TMUX_VERSION}.tar.gz tmux-${TMUX_VERSION}

ARG USER
RUN useradd --create-home --groups docker --shell /usr/bin/fish ${USER} \
    && echo "%"${USER}" ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER}
USER ${USER}

WORKDIR /home/${USER}

# git
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
COPY ./gitconfig .gitconfig
RUN git config --global user.name ${GIT_USER_NAME} \
    && git config --global user.email ${GIT_USER_EMAIL}
RUN git clone https://github.com/Toraja/toybox.git \
    && git -C toybox remote set-url origin git@github.com:Toraja/toybox.git

# fish
RUN fish -c 'curl -sL https://git.io/fisher | source && fisher install \
    jorgebucaran/fisher \
    gazorby/fish-abbreviation-tips \
    decors/fish-colored-man \
    laughedelic/fish_logo \
    laughedelic/pisces \
    markcial/upto \
    oh-my-fish/plugin-pj'
COPY --chown=${USER}:${USER} ./config.fish .config/fish/
RUN ln -s ~/toybox/fish/functions ~/.config/fish/myfuncs

# tmux
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
    && ln -s ~/toybox/tmux/.tmux.conf ~/.tmux.conf \
    && ~/.tmux/plugins/tpm/bin/install_plugins

# vim
# required by deoplote.nvim
RUN python3 -m pip install --user --upgrade pynvim
RUN mkdir -p .config/nvim .vim/swap .vim/bundle \
    && ln -s ~/toybox/nvim/init.vim ~/.config/nvim/ \
    && ln -s ~/toybox/nvim/ginit.vim ~/.config/nvim/ \
    && ln -s ~/toybox/vim/after ~/.vim/after \
    && ln -s ~/toybox/vim/autoload ~/.vim/autoload \
    && ln -s ~/toybox/vim/ftdetect ~/.vim/ftdetect \
    && ln -s ~/toybox/vim/ftplugin ~/.vim/ftplugin \
    && ln -s ~/toybox/vim/UltiSnips ~/.vim/UltiSnips \
    && git clone https://github.com/junegunn/vim-plug.git .vim/bundle/vim-plug

CMD ["tail", "-f", "/dev/null"]
