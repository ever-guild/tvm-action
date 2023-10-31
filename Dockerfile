#FROM alpine:3.18.2 as build
FROM ubuntu:20.04 as build

#RUN apk add --no-cache 7zip wget
RUN apt-get update && apt-get install -y p7zip-full wget
RUN mkdir -p /target/lib /target/fift /target/bin

WORKDIR /src

RUN wget --quiet https://github.com/ton-blockchain/ton/releases/download/v2023.10/ton-linux-x86_64.zip
RUN 7z x ton-linux-x86_64.zip && rm ton-linux-x86_64.zip
RUN mv lib/* /target/fift
RUN mv smartcont /target/
RUN mv * /target/bin

RUN wget --quiet https://github.com/tonlabs/TON-Solidity-Compiler/releases/download/0.71.0/solc_0_71_0_linux.gz
RUN 7z x solc_0_71_0_linux.gz && rm solc_0_71_0_linux.gz && mv * /target/bin

RUN wget --quiet https://github.com/tonlabs/TVM-linker/releases/download/0.20.5/tvm_linker_0_20_5_linux.gz
RUN 7z x tvm_linker_0_20_5_linux.gz && rm tvm_linker_0_20_5_linux.gz && mv * /target/bin

RUN wget --quiet https://github.com/tonlabs/TON-Solidity-Compiler/releases/download/0.71.0/sold_0_71_0_linux.gz
RUN 7z x sold_0_71_0_linux.gz && rm sold_0_71_0_linux.gz && mv * /target/bin

RUN wget --quiet https://github.com/tonlabs/TON-Solidity-Compiler/releases/download/0.71.0/stdlib_sol_0_71_0.tvm.gz
RUN 7z x stdlib_sol_0_71_0.tvm.gz && rm stdlib_sol_0_71_0.tvm.gz && mv * /target/lib

RUN wget --quiet https://github.com/tonlabs/tonos-cli/releases/download/0.35.4/tonos-cli-0_35_4-linux.gz
RUN 7z x tonos-cli-0_35_4-linux.gz && rm tonos-cli-0_35_4-linux.gz && mv * /target/bin

RUN wget --quiet https://github.com/gosh-sh/gosh/releases/download/6.1.35/git-remote-gosh-linux-amd64.tar.gz
RUN 7z x git-remote-gosh-linux-amd64.tar.gz -so | 7z x -aoa -si -ttar -o"git-remote-gosh-linux-amd64" &&\
    rm git-remote-gosh-linux-amd64.tar.gz &&\
    mv git-remote-gosh-linux-amd64/* /target/bin

RUN chmod +x /target/bin/*

#FROM alpine:3.18.2
FROM python:3.10.12-slim-bullseye

LABEL "com.github.actions.name"="TVM Action"
LABEL "com.github.actions.description"="Action for TVM can be used for development on TON, Everscale, Gosh, Venom"
LABEL "com.github.actions.icon"="play-circle"
LABEL "com.github.actions.color"="gray-dark"

RUN apt-get update && apt-get install -y \
    openssl \
    git \
    make \
    && apt-get clean

COPY --from=build /target/bin/* /usr/local/bin
COPY --from=build /target/fift /usr/local/lib/fift
COPY --from=build /target/smartcont /usr/local/lib/smartcont
COPY --from=build /target/lib /usr/local/lib

RUN pip install bitstring==3.1.9 toncli
COPY etc/config.ini /root/.config/toncli/config.ini

ENV FIFTPATH=/usr/local/lib/fift
ENV TVM_LINKER_LIB_PATH=/usr/local/lib/stdlib_sol_0_71_0.tvm

CMD ["/bin/bash"]
