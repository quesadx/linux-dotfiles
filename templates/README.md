# Development Environment Flake Library

This folder is a small library of focused `flake.nix` templates.
Pick the template closest to your project context and copy it as your project `flake.nix`.

## Design Rules

- Keep templates minimal and explicit.
- Use `shellHook` only when required for environment variables.
- Avoid aliases, banners, and noisy shell output.
- Prefer one clear use case per template.

## Template Catalog

### C++

- `cpp/flake.nix`: general native development (GCC + CMake + debugging).
- `cpp/cmake-ninja/flake.nix`: modern CMake with Ninja and ccache.
- `cpp/clang-llvm/flake.nix`: Clang/LLVM toolchain with LLDB and clang-tools.

### Java

- `java/flake.nix`: Maven + JDK 21 with JavaFX support.
- `java/gradle/flake.nix`: Gradle + JDK 21.
- `java/spring/flake.nix`: Spring service baseline (JDK 21 + Gradle + Maven + curl/jq).

### Python

- `python/flake.nix`: general Python app/dev tooling.
- `python/fastapi/flake.nix`: FastAPI backend development.
- `python/data-science/flake.nix`: notebooks and common data-science stack.

### Web

- `web/flake.nix`: Node + pnpm + TypeScript baseline.
- `web/react-vite/flake.nix`: React and Vite workflow.
- `web/nextjs/flake.nix`: Next.js baseline.
- `web/api-prisma/flake.nix`: Node API with Prisma/OpenSSL native deps.
- `web/gestion-del-fin/flake.nix`: existing project-specific API stack template.

### LaTeX

- `latex/flake.nix`: medium TeX Live distribution.
- `latex/full/flake.nix`: full TeX Live + `latexmk` + `biber`.

## Usage

### 1) Create and enter project

```bash
mkdir ~/my-project
cd ~/my-project
```

### 2) Copy template

```bash
cp ~/linux-dotfiles/templates/python/fastapi/flake.nix ./flake.nix
```

### 3) Optional direnv activation

```bash
echo "use flake" > .envrc
direnv allow
```

### 4) Manual activation

```bash
nix develop
```

## Recommended Conventions

- Commit `flake.nix` and `flake.lock`.
- Ignore `.direnv/`.
- Start from the closest template, then add only project-required packages.
