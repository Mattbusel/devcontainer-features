# every-other-token (LLM token confidence)

Installs `every-other-token` from [Every-Other-Token](https://github.com/Mattbusel/Every-Other-Token). It intercepts an OpenAI or Anthropic stream and shows how confident the model was about each token, from logprobs. The mock provider needs no API key.

```jsonc
"features": {
    "ghcr.io/mattbusel/devcontainer-features/every-other-token:1": {}
}
```

## Options

| Option | Default | Meaning |
|---|---|---|
| `version` | `latest` | Release to install, for example `4.3.0`. `latest` follows the newest GitHub release. |

## How it installs

The Feature downloads the prebuilt x86_64 Linux binary from the GitHub release, checks it against the release's `.sha256` file, puts it in `/usr/local/bin`, and installs the OpenSSL 3 runtime if the image lacks it. It needs glibc 2.34 or newer. On aarch64, Alpine or older distros it runs `cargo install every-other-token` if Rust is present; add `ghcr.io/devcontainers/features/rust:1` for that case.
