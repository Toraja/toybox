FROM alpine:latest

# `--update-cache` option is equivalent of running `apk update` beforehand
# The line starting with `docker...` is required by docker-compose
RUN apk add --update-cache --no-cache \
    shadow curl less mandoc man-pages \
    openssh-client bash fish \
    docker py-pip python3-dev libffi-dev openssl-dev gcc libc-dev rust cargo make \
    neovim git tmux ncurses firefox keychain

# NOTE installing docker-compose using pip takes too long time
# RUN pip install docker-compose
ARG COMPOSE_VERSION
RUN curl -L "https://github.com/docker/compose/releases/download/"${COMPOSE_VERSION}"/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

ARG USER
RUN useradd --create-home --shell /usr/bin/fish ${USER}
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
ARG GIT_HUB_SSH_KEY
COPY --chown=${USER}:${USER} ./config.fish .config/fish/
RUN echo "eval (keychain --quiet --agents ssh --eval ${GIT_HUB_SSH_KEY})" >> .config/fish/config.fish

# vim
# TODO alias vim to nvim
# RUN mkdir -p .config/nvim .vim/swap .vim/bundle \
#     && ln -s ~/toybox/nvim/init.vim ~/.config/nvim/ \
#     && ln -s ~/toybox/nvim/ginit.vim ~/.config/nvim/ \
#     && ln -s ~/toybox/vim/after ~/.vim/after \
#     && ln -s ~/toybox/vim/autoload ~/.vim/autoload \
#     && ln -s ~/toybox/vim/ftdetect ~/.vim/ftdetect \
#     && ln -s ~/toybox/vim/ftplugin ~/.vim/ftplugin \
#     && ln -s ~/toybox/vim/UltiSnips ~/.vim/UltiSnips \
#     && git clone https://github.com/junegunn/vim-plug.git .vim/bundle/vim-plug

# tmux
# TODO
# RUN ln -s ~/toybox/tmux/.tmux.conf ~/.tmux.conf \
#     && .tmux/plugins/tpm/bin/install_plugins

CMD ["tail", "-f", "/dev/null"]
