FROM base_ide:latest

USER root

ARG GO_VERSION
ARG CPU_ARCH
RUN curl -fsSL -o go.tar.gz https://golang.org/dl/go${GO_VERSION}.linux-${CPU_ARCH}.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz

ARG USER
# create directory with USER as the owner so that mounted volume will be accessible (not owned by root)
RUN mkdir -p /home/${USER}/go && chown ${USER}:${USER} /home/${USER}/go
VOLUME /home/${USER}/go

USER ${USER}

CMD ["tail", "-f", "/dev/null"]
