FROM base_ide:latest

USER root

ARG GO_VERSION
ARG GO_ARCH
RUN curl -fsSL -o go.tar.gz https://golang.org/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz

ARG USER
USER ${USER}

CMD ["tail", "-f", "/dev/null"]
