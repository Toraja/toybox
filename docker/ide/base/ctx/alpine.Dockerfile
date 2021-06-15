FROM alpine:latest

# `--update-cache` option is equivalent of running `apk update` beforehand
# packages after `docker` is required by docker-compose
RUN apk add --update-cache --no-cache \
    sudo shadow curl less mandoc man-pages \
    openssh-client bash fish \
    docker py-pip python3-dev libffi-dev openssl-dev gcc libc-dev rust cargo make \
    neovim neovim-doc git tmux ncurses keychain fzf

# NOTE installing docker-compose using pip takes too long time, so download binary instead
ARG COMPOSE_VERSION
RUN curl -L "https://github.com/docker/compose/releases/download/"${COMPOSE_VERSION}"/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

ARG USER
# XXX The user is added to `docker` group but permission error still occurs.
# (Running with `sudo` works fine)
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
    decors/fish-colored-man \
    gazorby/fish-abbreviation-tips \
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
# XXX `pynvim` required by deoplote.nvim but installation fails as `musl` C library is used instead of glibc.
# It is possible to build from scratch, but takes long time.
# Reference: https://pythonspeed.com/articles/alpine-docker-python/
# RUN python3 -m pip install --user --upgrade pynvim
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
