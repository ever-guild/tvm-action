FROM ubuntu:22.04 AS base

RUN apt-get update && apt-get install -y \
    openssl \
    git \
    curl \
    make \
    && apt-get clean

FROM base AS build
SHELL ["/bin/bash", "-c"]
ENV HOME=/root
WORKDIR /src
RUN mkdir -p /target/lib /target/fift /target/bin

RUN apt-get update
RUN apt-get install -y build-essential cmake g++ gcc libboost-all-dev libclang-dev git unzip curl
RUN apt-get install -y libssl-dev pkg-config p7zip-full

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="${HOME}/.cargo/bin:${PATH}"
# export CARGO_NET_GIT_FETCH_WITH_CLI=true
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true
RUN git config --global net.git-fetch-with-cli true

ARG TON_VERSION=2024.06
RUN curl -sL -o ton-linux-x86_64.zip https://github.com/ton-blockchain/ton/releases/download/v${TON_VERSION}/ton-linux-x86_64.zip
RUN unzip ton-linux-x86_64.zip && rm ton-linux-x86_64.zip
RUN mv lib/* /target/fift
RUN mv smartcont /target/
RUN mv * /target/bin

ARG SOLD_VERSION="0.69.0 0.70.0 0.71.0 0.72.0 0.73.0 0.74.0 0.75.0 0.76.0"
ARG SOLD_REPO="https://github.com/everx-labs/TVM-Solidity-Compiler.git"
RUN for v in ${SOLD_VERSION}; do \
    cargo install --tag ${v} --git ${SOLD_REPO}; \
    cp ${HOME}/.cargo/bin/sold /target/bin/sold; \
    cp /target/bin/sold /target/bin/sold-${v}; \
done

ARG GOSH_SOLD_VERSION="gosh_0.72.0"
ARG GOSH_SOLD_REPO="https://github.com/gosh-sh/TON-Solidity-Compiler.git"
RUN cargo install --tag ${GOSH_SOLD_VERSION} --git ${GOSH_SOLD_REPO}
RUN cp ${HOME}/.cargo/bin/sold /target/bin/sold-gosh

ARG EVER_ASSEMBLER_VERSION="1.6.9"
ARG EVER_ASSEMBLER_REPO="https://github.com/everx-labs/ever-assembler.git"
RUN cargo install --tag ${EVER_ASSEMBLER_VERSION} --git ${EVER_ASSEMBLER_REPO}
RUN cp ${HOME}/.cargo/bin/asm /target/bin/ever-asm
RUN cp ${HOME}/.cargo/bin/disasm /target/bin/ever-disasm

ARG TVM_ASM_REV="211356a"
ARG TVM_ASM_REPO="https://github.com/broxus/everscale-asm.git"
RUN cargo install --rev ${TVM_ASM_REV} --git ${TVM_ASM_REPO}
RUN cp ${HOME}/.cargo/bin/tvmasm /target/bin/tvm-asm
#
#ARG EVER_CLI_VERSION="0.38.2"
#ARG EVER_CLI_REPO="https://github.com/everx-labs/ever-cli.git"
#RUN cargo install --tag ${EVER_CLI_VERSION} --git ${EVER_CLI_REPO}
#RUN cargo install --tag 0.38.2 --git https://github.com/everx-labs/ever-cli.git
#RUN cp $HOME/.cargo/bin/ever-cli /target/bin/ever-cli
#
#ARG GOSH_VERSION="6.2.36"
#ARG GOSH_REPO="https://github.com/gosh-sh/gosh"
#RUN curl -sL -o git-remote-gosh-linux-amd64.tar.gz ${GOSH_REPO}/releases/download/${GOSH_VERSION}/git-remote-gosh-linux-amd64.tar.gz
#RUN 7z x git-remote-gosh-linux-amd64.tar.gz -so | 7z x -aoa -si -ttar -o"git-remote-gosh-linux-amd64" &&\
#    rm git-remote-gosh-linux-amd64.tar.gz &&\
#    mv git-remote-gosh-linux-amd64/* /target/bin
#


#ARG TVM_CLI_VERSION="v2.0.1.an"
#ARG TVM_CLI_REPO="https://github.com/tvmlabs/tvm-sdk.git"
#RUN cargo install --target tvm_cli --bin tvm-cli --target-dir /target/bin --tag ${TVM_CLI_VERSION} --git ${TVM_CLI_REPO}

RUN chmod +x /target/bin/*

FROM base

LABEL "com.github.actions.name"="TVM Action"
LABEL "com.github.actions.description"="Action for TVM can be used for development on TON, Everscale, Gosh, Venom"
LABEL "com.github.actions.icon"="play-circle"
LABEL "com.github.actions.color"="gray-dark"

COPY --from=build /target/bin/* /usr/local/bin
COPY --from=build /target/fift /usr/local/lib/fift
COPY --from=build /target/smartcont /usr/local/lib/smartcont
COPY --from=build /target/lib /usr/local/lib

ENV FIFTPATH=/usr/local/lib/fift

ARG UID=1000
ARG GID=1000
RUN mkdir -p /src && chown -R ${UID}:${GID} /src
RUN if ! getent group ${GID}; then groupadd -g ${GID} user; fi
RUN if ! id -u ${UID}; then useradd -u ${UID} -g ${GID} -s /bin/bash -m /src; fi
WORKDIR /src
USER ${UID}
CMD ["/bin/bash"]
