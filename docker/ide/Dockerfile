FROM alpine:latest

RUN apk add -U --no-cache \
    shadow curl less mandoc man-pages \
    openssh-client bash \
    neovim git fish tmux ncurses

ARG user=mojito
RUN useradd --create-home --shell /usr/bin/fish ${user}
USER ${user}

WORKDIR /home/${user}

# TODO set up fish

# RUN mkdir -p .vim/bundle \
#     && git clone git@github.com:Toraja/toybox.git \
#     && ln -s ~/toybox/vim/after ~/.vim/after \
#     && ln -s ~/toybox/vim/autoload ~/.vim/autoload \
#     && ln -s ~/toybox/vim/ftdetect ~/.vim/ftdetect \
#     && ln -s ~/toybox/vim/ftplugin ~/.vim/ftplugin \
#     && ln -s ~/toybox/vim/UltiSnips ~/.vim/UltiSnips \
#     && git clone https://github.com/junegunn/vim-plug.git .vim/bundle/vim-plug
