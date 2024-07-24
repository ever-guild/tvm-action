# TVM Action

## Toolchain

- [fift, func, lite-client, tonlib-cli, etc](https://github.com/ton-blockchain/ton/releases/tag/v2024.06) `v2024.06`
- [`sold`](https://github.com/tonlabs/TON-Solidity-Compiler) `v0.69.0` `v0.70.0` ... `v0.76.0`
- [`ever-asm`, `ever-disasm`](https://github.com/everx-labs/ever-assembler) `v1.6.9`
- [tvm-asm](https://github.com/broxus/everscale-asm) `r211356a`
- [ever-cli](https://github.com/everx-labs/ever-cli) `v0.38.2`
- [git-remote-gosh](https://docs.gosh.sh/working-with-gosh/git-remote-helper/) `v6.2.36`
- [sold-gosh](https://github.com/gosh-sh/TON-Solidity-Compiler) `v0.72.0`
- [tvm-cli](https://github.com/tvmlabs/tvm-sdk/tree/main/tvm_cli) `v2.0.1.an`
- GNU Make `v4.4.1`
- git `v2.45.2`

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
```

#### Build image
```bash
docker build -t tvm-action .
docker run --rm -it tvm-action bash
```

#### Build develop image
```bash
docker build -t tvm-action-build --target build .
docker run --rm -it tvm-action-build bash
```
