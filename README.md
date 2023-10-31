# TVM Action

## Toolchain

- [fift, func, lite-client, tonlib-cli, etc](https://github.com/ton-blockchain/ton) `v2023.10`
- [toncli](https://github.com/disintar/toncli/releases) `v0.0.43`
- [solc, sold](https://github.com/tonlabs/TON-Solidity-Compiler) `v0.71.0`
- [tvm_linker](https://github.com/tonlabs/TVM-linker) `v0.20.5`
- [tonos-cli](https://github.com/tonlabs/tonos-cli) `v0.35.4`
- [git-remote-gosh](https://docs.gosh.sh/working-with-gosh/git-remote-helper/) `v6.1.35`
- GNU Make `v4.3`

## Example usage

### Docker

#### TON lite-client
```bash
wget https://ton-blockchain.github.io/global.config.json
docker run -v $(pwd)/global.config.json:/ton-global.config --rm -it ghcr.io/ever-guild/tvm-action lite-client
```

#### Fift
```bash
echo '4 10 * 2 + .s' | docker run --rm -i ghcr.io/ever-guild/tvm-action fift
```

#### Gosh
```bash
docker run --rm -v$(pwd):/src -w /src -u 1000 -it ghcr.io/ever-guild/tvm-action
git clone gosh://0:b00a7a5a24740e4a7d6487d31969732f1febcaea412df5cc307400818055ad58/gosh/gosh
```

### GitHub Actions

#### Fift
```yaml
name: CI

jobs:
  test:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v3
      - uses: ever-guild/tvm-action@v1
        with:
          args: echo '4 10 * 2 + .s' | fift
```

#### Gosh
```yaml
# .github/workflows/ci.yml
name: CI

jobs:
  test:
    runs-on: ubuntu-22.04
    steps:
      - uses: ever-guild/tvm-action@v1
        with:
          args: git clone gosh://0:b00a7a5a24740e4a7d6487d31969732f1febcaea412df5cc307400818055ad58/gosh/gosh
```

## Build from source

```bash
got clone https://github.com/ever-guild/tvm-action.git
cd tvm-action
docker build -t tvm-action .
docker run --rm -it tvm-action bash
```
