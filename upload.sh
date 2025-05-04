#!/bin/bash
# upload.sh — Secure GitHub uploader with account switch + repo overwrite
# Use: ./upload.sh

# === INPUT ===
# Prompt for GitHub Owner, Repo Name, and Branch
read -p "GitHub Owner (e.g. basezsh or B453ZSH): " OWNER
read -p "Repo Name (e.g. basezsh.github.io): " REPO
read -p "Branch [default: main]: " BRANCH
BRANCH=${BRANCH:-main}

echo "[+] Choose account to use:"
select ACCOUNT in "basezsh" "B453ZSH"; do
  case $ACCOUNT in
    basezsh)
      read -s -p "Enter basezsh Token: " TOKEN
      echo
      break
      ;;
    B453ZSH)
      read -s -p "Enter B453ZSH Token: " TOKEN
      echo
      break
      ;;
    *)
      echo "[!] Invalid choice. Try again."
      ;;
  esac
done
# === USAGE ===
# ./upload.sh
# Follow the prompts: Enter GitHub username, repo name, and branch. 
# Choose which token to use and enter it securely.

# === VARS ===
REMOTE="https://$TOKEN@github.com/$OWNER/$REPO.git"
DIR="$(pwd)"
LOG="upload-$(date +%s).log"

# === GIT SAFE SETUP ===
# Ensures Git can operate safely on the device
git config --global init.defaultBranch "$BRANCH"
git config --global --add safe.directory "$DIR" 2>/dev/null
# === USAGE ===
# Git is configured with the proper default branch and safe directory setting
# This step ensures Git won't warn about the directory ownership.

# === GIT CLEAN RESET ===
# Clears previous Git setup, reinitializes, commits, and pushes changes
{
echo "[*] Cleaning local Git setup..."
rm -rf .git
git init -q
git checkout -b "$BRANCH"
git remote add origin "$REMOTE"

echo "[*] Staging & Committing..."
git add .
git commit -m "Auto overwrite: $(date +%F_%H-%M)"

echo "[*] Force pushing to $OWNER/$REPO ($BRANCH)..."
git push -f origin "$BRANCH"

echo "[+] Upload complete: https://github.com/$OWNER/$REPO"
} &> "$LOG"
# === USAGE ===
# This section clears any old Git data, initializes a new repo, and force-pushes content to the specified GitHub repo.
# If the repo exists, it overwrites the content.

# === RESULT ===
# Checks if the upload was successful, prints the log or error
if grep -q "Upload complete" "$LOG"; then
  echo "[✓] Success — log saved: $LOG"
else
  echo "[x] Upload failed — check log: $LOG"
  tail -n 10 "$LOG"
fi
# === USAGE ===
# After running the script, if the upload is successful, a success message will show, and the log is saved.
# If there’s an issue, it will show the last few lines of the log for troubleshooting.