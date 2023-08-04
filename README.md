# TVM Action

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
      - uses: ever-guild/tvm-action@v1.0.0
        with:
          args: echo '4 10 * 2 + .s' | fift
```
