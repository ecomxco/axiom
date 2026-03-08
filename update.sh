#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────
# Axiom Updater
# Update installed Axiom workflows to the latest version
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/ecomxco/axiom/main/update.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/ecomxco/axiom/main/update.sh | bash -s -- --dir ./my-project
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
      echo -e "${BOLD}Axiom Updater${NC}"
      echo ""
      echo "  Update installed Axiom workflows to the latest version."
      echo ""
      echo -e "${BOLD}Options:${NC}"
      echo "  --dir <path>        Project directory (default: current directory)"
      echo "  --version <tag>     Update to a specific version (default: latest)"
      echo "  --agent-dir <path>  Custom workflows subdirectory (default: .agent/workflows)"
      echo "  --help              Show this help"
      echo ""
      exit 0
      ;;
    *)
      error "Unknown option: $1"
      exit 1
      ;;
  esac
done

# ── Header ──
echo ""
echo -e "${BOLD}${CYAN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║          Axiom Workflow Updater            ║${NC}"
echo -e "${BOLD}${CYAN}╚═══════════════════════════════════════════╝${NC}"
echo ""

# ── Resolve target ──
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")"
INSTALL_DIR="$TARGET_DIR/$WORKFLOWS_SUBDIR"

# ── Check for existing installation ──
if [ ! -d "$INSTALL_DIR" ]; then
  error "No Axiom installation found at $INSTALL_DIR"
  echo ""
  echo "  To install Axiom for the first time, run:"
  echo -e "  ${CYAN}curl -fsSL https://raw.githubusercontent.com/$REPO/main/install.sh | bash${NC}"
  echo ""
  exit 1
fi

# ── Show current version ──
CURRENT_VERSION="unknown"
if [ -f "$INSTALL_DIR/.axiom-version" ]; then
  CURRENT_VERSION=$(cat "$INSTALL_DIR/.axiom-version")
fi
info "Current version: ${BOLD}$CURRENT_VERSION${NC}"

# ── Count existing files ──
BEFORE_COUNT=$(ls "$INSTALL_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
info "Installed workflows: ${BOLD}$BEFORE_COUNT${NC}"

# ── Download latest ──
if [ -n "$VERSION" ]; then
  DOWNLOAD_URL="https://github.com/$REPO/archive/refs/tags/$VERSION.tar.gz"
  info "Updating to: ${BOLD}$VERSION${NC}"
else
  DOWNLOAD_URL="https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz"
  info "Updating to: ${BOLD}latest ($BRANCH)${NC}"
fi

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

info "Downloading..."

if command -v curl &> /dev/null; then
  curl -fsSL -o "$TMPDIR/axiom.tar.gz" "$DOWNLOAD_URL" 2>/dev/null || {
    error "Download failed. Check your network connection and try again."
    exit 1
  }
else
  wget -q -O "$TMPDIR/axiom.tar.gz" "$DOWNLOAD_URL" 2>/dev/null || {
    error "Download failed. Check your network connection and try again."
    exit 1
  }
fi

tar -xzf "$TMPDIR/axiom.tar.gz" -C "$TMPDIR" 2>/dev/null || {
  error "Failed to extract archive."
  exit 1
}

EXTRACTED_DIR=$(find "$TMPDIR" -mindepth 1 -maxdepth 1 -type d | head -1)

if [ ! -d "$EXTRACTED_DIR/workflows" ]; then
  error "Invalid archive — 'workflows/' directory not found."
  exit 1
fi

# ── Diff and update ──
UPDATED=0
ADDED=0
UNCHANGED=0

# Preserve context.md if user has customized it
PRESERVE_CONTEXT=false
if [ -f "$INSTALL_DIR/context.md" ]; then
  # Check if user has modified context.md from the template
  REMOTE_CONTEXT="$EXTRACTED_DIR/workflows/context.md"
  if [ -f "$REMOTE_CONTEXT" ]; then
    if ! diff -q "$INSTALL_DIR/context.md" "$REMOTE_CONTEXT" &>/dev/null; then
      PRESERVE_CONTEXT=true
    fi
  fi
fi

for file in "$EXTRACTED_DIR/workflows/"*.md; do
  [ -f "$file" ] || continue
  BASENAME=$(basename "$file")
  TARGET_FILE="$INSTALL_DIR/$BASENAME"

  # Skip context.md if user has customized it
  if [ "$BASENAME" = "context.md" ] && [ "$PRESERVE_CONTEXT" = true ]; then
    warn "Skipping context.md (locally modified — preserving your customizations)"
    continue
  fi

  if [ -f "$TARGET_FILE" ]; then
    if diff -q "$file" "$TARGET_FILE" &>/dev/null; then
      UNCHANGED=$((UNCHANGED + 1))
    else
      cp "$file" "$TARGET_FILE"
      UPDATED=$((UPDATED + 1))
      success "Updated: $BASENAME"
    fi
  else
    cp "$file" "$TARGET_FILE"
    ADDED=$((ADDED + 1))
    success "Added:   $BASENAME"
  fi
done

# ── Update version marker ──
if [ -n "$VERSION" ]; then
  echo "$VERSION" > "$INSTALL_DIR/.axiom-version"
else
  echo "latest" > "$INSTALL_DIR/.axiom-version"
fi

# ── Summary ──
echo ""
if [ "$UPDATED" -eq 0 ] && [ "$ADDED" -eq 0 ]; then
  echo -e "${GREEN}${BOLD}✓ Already up to date${NC} ($UNCHANGED workflows, no changes needed)"
else
  echo -e "${GREEN}${BOLD}✓ Update complete${NC}"
  [ "$UPDATED" -gt 0 ] && echo -e "  ${BOLD}Updated:${NC}   $UPDATED workflows"
  [ "$ADDED" -gt 0 ]   && echo -e "  ${BOLD}Added:${NC}     $ADDED new workflows"
  [ "$UNCHANGED" -gt 0 ] && echo -e "  ${BOLD}Unchanged:${NC} $UNCHANGED workflows"
fi
echo ""
