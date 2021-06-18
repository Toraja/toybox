FROM base_ide:latest

USER root

ARG JDK_VERSION
RUN apt-get update && apt-get install --no-install-recommends --yes \
    openjdk-${JDK_VERSION}-jdk \
    && rm -rf /var/lib/apt/lists/*

ARG USER
USER ${USER}

# FIXME installing jdt language server fails...
# TODO clone to more suitable place
# Maybe it's better to do this manually in a bind mounted directory after image
# is built because it takes very long time to complete.
# RUN git clone https://github.com/eclipse/eclipse.jdt.ls.git \
#     && cd eclipse.jdt.ls \
#     && ./mvnw clean verify

CMD ["tail", "-f", "/dev/null"]
