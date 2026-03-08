#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────
# Axiom Installer
# Install deterministic AI development workflows into any project
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/ecomxco/axiom/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/ecomxco/axiom/main/install.sh | bash -s -- --dir ./my-project
#   curl -fsSL https://raw.githubusercontent.com/ecomxco/axiom/main/install.sh | bash -s -- --version v1.0.0
# ──────────────────────────────────────────────────────────────

REPO="ecomxco/axiom"
BRANCH="main"
VERSION=""
TARGET_DIR="."
WORKFLOWS_SUBDIR=".agent/workflows"

# ── Colors ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── Helpers ──
info()    { echo -e "${BLUE}ℹ${NC}  $1"; }
success() { echo -e "${GREEN}✓${NC}  $1"; }
warn()    { echo -e "${YELLOW}⚠${NC}  $1"; }
error()   { echo -e "${RED}✗${NC}  $1" >&2; }

# ── Parse arguments ──
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir)
      TARGET_DIR="$2"
      shift 2
      ;;
    --version)
      VERSION="$2"
      shift 2
      ;;
    --agent-dir)
      WORKFLOWS_SUBDIR="$2"
      shift 2
      ;;
    --help|-h)
      echo ""
      echo -e "${BOLD}Axiom Installer${NC}"
      echo ""
      echo "  Install 15 deterministic AI development workflows into your project."
      echo ""
      echo -e "${BOLD}Usage:${NC}"
      echo "  curl -fsSL https://raw.githubusercontent.com/$REPO/main/install.sh | bash"
      echo "  curl -fsSL ... | bash -s -- [options]"
      echo ""
      echo -e "${BOLD}Options:${NC}"
      echo "  --dir <path>        Target project directory (default: current directory)"
      echo "  --version <tag>     Install a specific version (default: latest)"
      echo "  --agent-dir <path>  Custom workflows subdirectory (default: .agent/workflows)"
      echo "  --help              Show this help"
      echo ""
      echo -e "${BOLD}Examples:${NC}"
      echo "  # Install into current project"
      echo "  curl -fsSL https://raw.githubusercontent.com/$REPO/main/install.sh | bash"
      echo ""
      echo "  # Install into a specific project"
      echo "  curl -fsSL ... | bash -s -- --dir ~/projects/my-app"
      echo ""
      echo "  # Install a specific version"
      echo "  curl -fsSL ... | bash -s -- --version v1.0.0"
      echo ""
      echo "  # Use Cursor's directory convention"
      echo "  curl -fsSL ... | bash -s -- --agent-dir .cursor/rules"
      echo ""
      exit 0
      ;;
    *)
      error "Unknown option: $1"
      echo "Run with --help for usage information."
      exit 1
      ;;
  esac
done

# ── Header ──
echo ""
echo -e "${BOLD}${CYAN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║          Axiom Workflow Installer          ║${NC}"
echo -e "${BOLD}${CYAN}╚═══════════════════════════════════════════╝${NC}"
echo ""

# ── Check dependencies ──
if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
  error "Either 'curl' or 'wget' is required. Please install one and try again."
  exit 1
fi

if ! command -v tar &> /dev/null; then
  error "'tar' is required. Please install it and try again."
  exit 1
fi

# ── Resolve target directory ──
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")"
INSTALL_DIR="$TARGET_DIR/$WORKFLOWS_SUBDIR"

info "Target: ${BOLD}$INSTALL_DIR${NC}"

# ── Check if already installed ──
if [ -d "$INSTALL_DIR" ] && [ "$(ls -A "$INSTALL_DIR"/*.md 2>/dev/null | wc -l)" -gt 0 ]; then
  EXISTING_COUNT=$(ls "$INSTALL_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
  warn "Found $EXISTING_COUNT existing workflow files in $INSTALL_DIR"
  
  # When running from pipe (non-interactive), default to overwrite
  if [ -t 0 ]; then
    echo -ne "   Overwrite? [y/N] "
    read -r REPLY
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
      info "Cancelled. No changes made."
      exit 0
    fi
  else
    info "Running non-interactively — overwriting existing files"
  fi
fi

# ── Determine download URL ──
if [ -n "$VERSION" ]; then
  DOWNLOAD_URL="https://github.com/$REPO/archive/refs/tags/$VERSION.tar.gz"
  info "Version: ${BOLD}$VERSION${NC}"
else
  DOWNLOAD_URL="https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz"
  info "Version: ${BOLD}latest ($BRANCH)${NC}"
fi

# ── Download and extract ──
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

info "Downloading Axiom workflows..."

if command -v curl &> /dev/null; then
  HTTP_CODE=$(curl -fsSL -w "%{http_code}" -o "$TMPDIR/axiom.tar.gz" "$DOWNLOAD_URL" 2>/dev/null || true)
  if [ "$HTTP_CODE" != "200" ] && [ ! -s "$TMPDIR/axiom.tar.gz" ]; then
    error "Download failed (HTTP $HTTP_CODE). Check the version tag and try again."
    exit 1
  fi
else
  wget -q -O "$TMPDIR/axiom.tar.gz" "$DOWNLOAD_URL" 2>/dev/null || {
    error "Download failed. Check the version tag and try again."
    exit 1
  }
fi

# ── Extract workflows ──
info "Extracting workflows..."
tar -xzf "$TMPDIR/axiom.tar.gz" -C "$TMPDIR" 2>/dev/null || {
  error "Failed to extract archive. The download may be corrupted."
  exit 1
}

# Find the extracted directory (tar creates axiom-main/ or axiom-v1.0.0/)
EXTRACTED_DIR=$(find "$TMPDIR" -mindepth 1 -maxdepth 1 -type d | head -1)

if [ ! -d "$EXTRACTED_DIR/workflows" ]; then
  error "Invalid archive — 'workflows/' directory not found."
  exit 1
fi

# ── Install workflows ──
mkdir -p "$INSTALL_DIR"

INSTALLED=0
for file in "$EXTRACTED_DIR/workflows/"*.md; do
  [ -f "$file" ] || continue
  cp "$file" "$INSTALL_DIR/"
  INSTALLED=$((INSTALLED + 1))
done

if [ "$INSTALLED" -eq 0 ]; then
  error "No workflow files found in the archive."
  exit 1
fi

# ── Write version marker ──
if [ -n "$VERSION" ]; then
  echo "$VERSION" > "$INSTALL_DIR/.axiom-version"
else
  echo "latest" > "$INSTALL_DIR/.axiom-version"
fi

# ── Success ──
echo ""
echo -e "${GREEN}${BOLD}✓ Installed $INSTALLED Axiom workflows${NC}"
echo -e "  ${BOLD}Location:${NC} $INSTALL_DIR"
if [ -n "$VERSION" ]; then
  echo -e "  ${BOLD}Version:${NC}  $VERSION"
fi
echo ""
echo -e "${BOLD}Next steps:${NC}"
echo ""
echo "  1. Open your AI agent and run:"
echo -e "     ${CYAN}/context${NC}          — Load project context"
echo -e "     ${CYAN}/plan-project${NC}     — Start a new project"
echo -e "     ${CYAN}/plan-phase${NC}       — Plan a phase"
echo ""
echo "  2. Customize your project context:"
echo -e "     ${CYAN}$INSTALL_DIR/context.md${NC}"
echo ""
echo -e "  ${BOLD}Docs:${NC} https://github.com/$REPO"
echo ""
