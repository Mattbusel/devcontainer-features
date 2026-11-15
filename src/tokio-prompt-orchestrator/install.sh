#!/bin/sh
# tokio-prompt-orchestrator Dev Container Feature.
# Installs the prebuilt release binary from https://github.com/Mattbusel/tokio-prompt-orchestrator/releases,
# checks its SHA-256, and falls back to `cargo install` when no prebuilt binary
# fits this container (musl, old glibc, or no asset for the CPU).
set -e

REPO="Mattbusel/tokio-prompt-orchestrator"
ASSET_PREFIX="orchestrator"
BINS="orchestrator"
CRATE="tokio-prompt-orchestrator"
CARGO_BIN_ARGS="--bin orchestrator"
SUMS_MODE="file"
NEEDS_OPENSSL3="false"
VERSION="${VERSION:-latest}"
INSTALL_DIR="/usr/local/bin"

log() { echo "[${CRATE}] $*"; }
die() { echo "[${CRATE}] ERROR: $*" >&2; exit 1; }

if [ "$(id -u)" -ne 0 ]; then
    die "this script must run as root (Dev Container Features run as root by default)."
fi

APT_UPDATED=0
pkg_install() {
    if command -v apt-get >/dev/null 2>&1; then
        if [ "$APT_UPDATED" = "0" ]; then
            DEBIAN_FRONTEND=noninteractive apt-get update -y >/dev/null
            APT_UPDATED=1
        fi
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "$@" >/dev/null
    elif command -v apk >/dev/null 2>&1; then
        apk add --no-cache "$@" >/dev/null
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y "$@" >/dev/null
    elif command -v microdnf >/dev/null 2>&1; then
        microdnf install -y "$@" >/dev/null
    elif command -v yum >/dev/null 2>&1; then
        yum install -y "$@" >/dev/null
    else
        return 1
    fi
}

ensure_tools() {
    missing=""
    command -v curl >/dev/null 2>&1 || missing="$missing curl"
    command -v tar >/dev/null 2>&1 || missing="$missing tar"
    command -v gzip >/dev/null 2>&1 || missing="$missing gzip"
    if [ ! -e /etc/ssl/certs/ca-certificates.crt ] && [ ! -e /etc/pki/tls/certs/ca-bundle.crt ]; then
        missing="$missing ca-certificates"
    fi
    if [ -n "$missing" ]; then
        log "installing:$missing"
        # shellcheck disable=SC2086
        pkg_install $missing || die "could not install:$missing"
    fi
}

glibc_ok() {
    # Release binaries are built on Ubuntu and need glibc 2.34 or newer.
    command -v getconf >/dev/null 2>&1 || return 1
    v="$(getconf GNU_LIBC_VERSION 2>/dev/null | awk '{print $2}')"
    [ -n "$v" ] || return 1
    major="${v%%.*}"
    minor="${v#*.}"
    minor="${minor%%.*}"
    [ "$major" -gt 2 ] || { [ "$major" -eq 2 ] && [ "$minor" -ge 34 ]; }
}

ensure_openssl3() {
    [ "$NEEDS_OPENSSL3" = "true" ] || return 0
    if command -v ldconfig >/dev/null 2>&1 && ldconfig -p 2>/dev/null | grep -q 'libssl.so.3'; then
        return 0
    fi
    log "installing OpenSSL 3 runtime"
    pkg_install libssl3 2>/dev/null || pkg_install libssl3t64 2>/dev/null || pkg_install openssl-libs 2>/dev/null \
        || die "this binary needs libssl.so.3 (OpenSSL 3); install it in the base image."
}

resolve_tag() {
    if [ "$VERSION" = "latest" ] || [ -z "$VERSION" ]; then
        url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/${REPO}/releases/latest")" \
            || die "could not reach github.com to find the latest release."
        tag="${url##*/}"
        case "$tag" in
            v[0-9]*) ;;
            *) die "could not read the latest release tag from $url" ;;
        esac
    else
        tag="v${VERSION#v}"
    fi
    echo "$tag"
}

cargo_fallback() {
    reason="$1"
    if [ -z "$CARGO_BIN" ]; then
        for c in cargo /usr/local/cargo/bin/cargo "${CARGO_HOME:-/nonexistent}/bin/cargo"; do
            if command -v "$c" >/dev/null 2>&1; then CARGO_BIN="$c"; break; fi
        done
    fi
    if [ -z "$CARGO_BIN" ]; then
        die "$reason No Rust toolchain found to build from source. Add \"ghcr.io/devcontainers/features/rust:1\" to your features (it installs before this one) and rebuild."
    fi
    log "$reason Building from crates.io with cargo instead."
    if [ "$NEEDS_OPENSSL3" = "true" ]; then
        pkg_install pkg-config libssl-dev 2>/dev/null || pkg_install pkgconf openssl-dev 2>/dev/null             || pkg_install pkgconf-pkg-config openssl-devel 2>/dev/null || true
    fi
    if [ "$VERSION" = "latest" ] || [ -z "$VERSION" ]; then
        # shellcheck disable=SC2086
        "$CARGO_BIN" install --locked --root /usr/local $CARGO_BIN_ARGS "$CRATE"
    else
        # shellcheck disable=SC2086
        "$CARGO_BIN" install --locked --root /usr/local $CARGO_BIN_ARGS --version "${VERSION#v}" "$CRATE"
    fi
    exit 0
}

CARGO_BIN=""
ensure_tools

case "$(uname -m)" in
    x86_64 | amd64) TRIPLE="x86_64-unknown-linux-gnu" ;;
    aarch64 | arm64) TRIPLE="aarch64-unknown-linux-gnu" ;;
    *) cargo_fallback "No prebuilt binary for CPU $(uname -m)." ;;
esac

if ! glibc_ok; then
    cargo_fallback "Prebuilt binaries need glibc 2.34+ (Debian 12, Ubuntu 22.04 or newer); this image has none or an older one."
fi

TAG="$(resolve_tag)"
ASSET="${ASSET_PREFIX}-${TAG}-${TRIPLE}.tar.gz"
BASE_URL="https://github.com/${REPO}/releases/download/${TAG}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

log "downloading ${ASSET}"
if ! curl -fsSL -o "${WORK}/${ASSET}" "${BASE_URL}/${ASSET}"; then
    cargo_fallback "Release ${TAG} has no ${TRIPLE} binary."
fi

if [ "$SUMS_MODE" = "file" ]; then
    curl -fsSL -o "${WORK}/sums.txt" "${BASE_URL}/SHA256SUMS.txt" || die "could not download SHA256SUMS.txt for ${TAG}"
    expected="$(awk -v a="$ASSET" '$2 == a || $2 == "*" a {print $1; exit}' "${WORK}/sums.txt")"
else
    curl -fsSL -o "${WORK}/sums.txt" "${BASE_URL}/${ASSET}.sha256" || die "could not download ${ASSET}.sha256"
    expected="$(awk '{print $1}' "${WORK}/sums.txt" | head -n 1)"
fi
[ -n "$expected" ] || die "no checksum listed for ${ASSET}"
actual="$(sha256sum "${WORK}/${ASSET}" | awk '{print $1}')"
[ "$expected" = "$actual" ] || die "checksum mismatch for ${ASSET}: expected ${expected}, got ${actual}"
log "checksum ok"

tar -xzf "${WORK}/${ASSET}" -C "$WORK"
for b in $BINS; do
    src="$(find "$WORK" -type f -name "$b" | head -n 1)"
    [ -n "$src" ] || die "archive has no '$b' binary"
    install -m 0755 "$src" "${INSTALL_DIR}/${b}"
    log "installed ${INSTALL_DIR}/${b}"
done

ensure_openssl3

if command -v apt-get >/dev/null 2>&1 && [ "$APT_UPDATED" = "1" ]; then
    rm -rf /var/lib/apt/lists/*
fi

for b in $BINS; do
    "${INSTALL_DIR}/${b}" --version || die "'$b --version' failed after install"
done
log "done (${TAG})"
