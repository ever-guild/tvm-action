# TVM Action

## Toolchain

- [fift, func, lite-client, tonlib-cli, etc](https://github.com/ton-blockchain/ton) `v2023.06`
- [solc, sold](https://github.com/tonlabs/TON-Solidity-Compiler) `v0.71.0`
- [tvm_linker](https://github.com/tonlabs/TVM-linker) `v0.20.5`
- [tonos-cli](https://github.com/tonlabs/tonos-cli) `v0.35.4`
- [git-remote-gosh](https://docs.gosh.sh/working-with-gosh/git-remote-helper/) `v5.1.0`
- GNU Make `v4.2.1`

## Example usage

### Docker

```bash
echo '4 10 * 2 + .s' | docker run --rm -i ghcr.io/ever-guild/tvm-action fift
```

### GitHub Actions

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
