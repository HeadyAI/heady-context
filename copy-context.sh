#!/bin/bash
set -e

SRC="/home/headyme/Heady"
DST="/home/headyme/heady-context"

echo "Copying all meaningful .md files from Heady repo..."

# Copy docs/ (main documentation)
rsync -av --include='*/' --include='*.md' --include='*.json' --exclude='*' \
  --exclude='node_modules' "$SRC/docs/" "$DST/docs/" 2>/dev/null

# Copy root-level .md files
for f in "$SRC"/*.md; do
  [ -f "$f" ] && cp "$f" "$DST/" 2>/dev/null
done

# Copy architecture
rsync -av --include='*/' --include='*.md' --exclude='*' \
  --exclude='node_modules' "$SRC/src/architecture/" "$DST/src-architecture/" 2>/dev/null || true

# Copy configs (prompts, agent profiles, etc)
rsync -av --include='*/' --include='*.md' --include='*.json' --exclude='*' \
  --exclude='node_modules' "$SRC/configs/" "$DST/configs/" 2>/dev/null || true

# Copy research
rsync -av --include='*/' --include='*.md' --exclude='*' \
  "$SRC/research/" "$DST/research/" 2>/dev/null || true

# Copy audit reports
rsync -av --include='*/' --include='*.md' --exclude='*' \
  --exclude='node_modules' "$SRC/audit/" "$DST/audit/" 2>/dev/null || true

# Copy patent docs  
rsync -av --include='*/' --include='*.md' --exclude='*' \
  "$SRC/docs/patents/" "$DST/patents/" 2>/dev/null || true

# Copy notebooks
rsync -av --include='*/' --include='*.md' --exclude='*' \
  "$SRC/notebooks/" "$DST/notebooks/" 2>/dev/null || true

# Copy heady-implementation docs
rsync -av --include='*/' --include='*.md' --exclude='*' \
  --exclude='node_modules' "$SRC/heady-implementation/" "$DST/heady-implementation/" 2>/dev/null || true

# Copy heady-skills SKILL.md files
rsync -av --include='*/' --include='SKILL.md' --include='*.md' --exclude='*' \
  --exclude='node_modules' "$SRC/heady-skills/" "$DST/heady-skills/" 2>/dev/null || true

# Copy context folder
rsync -av --include='*/' --include='*.md' --exclude='*' \
  "$SRC/context/" "$DST/context/" 2>/dev/null || true

# Copy services docs
for svc in "$SRC"/services/*/; do
  svcname=$(basename "$svc")
  for f in "$svc"*.md "$svc"docs/*.md; do
    [ -f "$f" ] && mkdir -p "$DST/services/$svcname" && cp "$f" "$DST/services/$svcname/" 2>/dev/null
  done
done

# Copy headybuddy
rsync -av --include='*/' --include='*.md' --exclude='*' \
  --exclude='node_modules' "$SRC/headybuddy/" "$DST/headybuddy/" 2>/dev/null || true

# Copy dropzone (AI prompts, reports)
rsync -av --include='*/' --include='*.md' --exclude='*' \
  "$SRC/dropzone/" "$DST/dropzone/" 2>/dev/null || true

# Copy key JSON configs
cp "$SRC/configs/hcfullpipeline-tasks.json" "$DST/configs/" 2>/dev/null || true
cp "$SRC/configs/swarm-definitions.json" "$DST/configs/" 2>/dev/null || true
cp "$SRC/site-registry.json" "$DST/" 2>/dev/null || true
cp "$SRC/package.json" "$DST/" 2>/dev/null || true

# Copy BUDDY_KERNEL
cp "$SRC/BUDDY_KERNEL.md" "$DST/" 2>/dev/null || true

# Remove any empty directories
find "$DST" -type d -empty -delete 2>/dev/null || true

echo "=== File counts ==="
find "$DST" -name "*.md" | wc -l
echo "md files copied"
find "$DST" -name "*.json" | wc -l
echo "json files copied"
du -sh "$DST"
