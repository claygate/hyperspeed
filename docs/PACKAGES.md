# Complete Package List

## Core Development Tools

### Version Control & GitHub
- **git** - Distributed version control system
- **gh** - GitHub CLI for pull requests, issues, etc.
- **lazygit** - Terminal UI for git commands
- **git-delta** - Syntax-highlighting pager for git
- **tig** - Text-mode interface for git
- **jj** - Jujutsu VCS (experimental alternative to git)

### Security & Encryption
- **gnupg** - GNU Privacy Guard for encryption
- **openssh** - Secure shell and related tools

## Shell & Terminal

### Shell Enhancement
- **zsh** - Z shell (default shell)
- **starship** - Fast, customizable shell prompt
- **zoxide** - Smarter cd command that learns your habits
- **atuin** - Magical shell history with sync

### Terminal Multiplexers
- **tmux** - Terminal multiplexer
- **reattach-to-user-namespace** - macOS pasteboard access for tmux
- **zellij** - Modern terminal workspace

### Search & Navigation
- **fzf** - Fuzzy finder for files and commands
- **ripgrep** (rg) - Fast recursive grep
- **fd** - Fast and user-friendly alternative to find

### File Viewing & Management
- **eza** - Modern replacement for ls
- **bat** - Cat clone with syntax highlighting
- **duf** - Disk usage utility
- **procs** - Modern replacement for ps

## Data Processing & Formats

### JSON/YAML Processing
- **jq** - Command-line JSON processor
- **yq** - YAML processor (like jq for YAML)

### Other Data Tools
- **gawk** - GNU awk for text processing
- **hyperfine** - Command-line benchmarking tool

## System Utilities

### GNU Core Utilities
- **coreutils** - GNU core utilities (replaces macOS versions)
- **findutils** - GNU find, locate, updatedb, xargs
- **gnu-sed** - GNU sed (stream editor)
- **gnu-tar** - GNU tar archiver
- **watch** - Execute program periodically, showing output

## Development Utilities

### Shell Completion & Hooks
- **carapace** - Multi-shell completion generator
- **direnv** - Load environment variables based on directory

### Build Tools
- **just** - Command runner (Makefile alternative)

### HTTP Clients
- **xh** - Fast HTTP client (httpie-like)
- **httpie** - Human-friendly HTTP client

## Programming Languages & Runtimes

### Runtime Management
- **mise** - Polyglot runtime manager (replaces asdf)
  - Installs: Node.js, Python, Rust, Bun, etc.

### Python Tools
- **uv** - Fast Python package installer
- **pipx** - Install Python applications in isolated environments
  - **llm** - CLI for Large Language Models
  - **pre-commit** - Git pre-commit hook framework

## Editors

### Terminal Editors
- **neovim** - Hyperextensible Vim-based text editor
  - Configured with **AstroNvim** distribution
  - Theme: Catppuccin Mocha

### GUI Editors
- **Visual Studio Code** - Microsoft's extensible code editor
  - Extensions: Catppuccin, Vim, Python, Rust, Go, Docker, Terraform, etc.

## Databases

### Relational Databases
- **postgresql@16** - PostgreSQL 16 database
- **pgcli** - PostgreSQL CLI with auto-completion
- **sqlite** - SQLite database
- **litecli** - SQLite CLI with auto-completion

### NoSQL/In-Memory
- **redis** - In-memory data structure store

## Containers & Orchestration

### Container Runtimes
- **colima** - Container runtime for macOS
- **docker** - Docker CLI
- **docker-compose** - Multi-container Docker applications
- **lima** - Linux virtual machines for macOS

### Kubernetes Tools
- **kubernetes-cli** (kubectl) - Kubernetes command-line tool
- **helm** - Kubernetes package manager
- **k9s** - Terminal UI for Kubernetes
- **kind** - Kubernetes in Docker
- **minikube** - Local Kubernetes cluster
- **tilt** - Development environment for microservices

## Media & Document Processing

### Image Processing
- **imagemagick** - Image manipulation tools
- **pngpaste** - Paste PNG from clipboard
- **tesseract** - OCR engine

### Document & Media
- **poppler** - PDF rendering library
- **ffmpeg** - Video and audio processing
- **pandoc** - Universal document converter

## Desktop Environment

### Window Management
- **AeroSpace** - Tiling window manager for macOS
  - Vim-like keybindings
  - Workspace management
  - Hot keys: Alt+hjkl for navigation

### Keyboard Customization
- **Karabiner-Elements** - Keyboard customizer
  - Caps Lock → Hyper key (⌘⌃⌥⇧) / tap for Escape
  - Hyper+1-9 → Workspace switching

### Status Bar & Visual
- **Sketchybar** - Customizable status bar
- **Borders** - Window border highlighter
- **JetBrains Mono Nerd Font** - Programming font with icons

### Productivity Apps
- **Raycast** - Spotlight replacement with extensions
- **Maccy** - Clipboard manager
- **Obsidian** - Knowledge base and note-taking
- **Tailscale** - Zero-config VPN

## Terminal Emulators
- **Ghostty** - Modern terminal emulator
- **WezTerm** - GPU-accelerated terminal emulator

## AI & ML
- **Ollama** - Run large language models locally

## System Tools
- **qemu** - Generic machine emulator and virtualizer

## Development Environments
- **devbox** - Portable development environments

## Theme
All tools are configured with **Catppuccin Mocha** theme where applicable:
- Starship prompt
- Tmux
- Neovim (AstroNvim)
- VSCode
- Ghostty
- Git Delta
- Bat

## Services (Auto-started)
- PostgreSQL 16 (port 5432)
- Redis (port 6379)
- Sketchybar
- Borders
- Ollama (LaunchAgent)
