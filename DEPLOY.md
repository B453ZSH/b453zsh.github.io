# web github pages theme V10 Deployment Guide

## GitHub Pages
1. Create repository: /
2. Push this project:
   ```bash
   git init
   git add .
   git commit -m "web github pages theme V10 Initial Commit"
   git remote add origin https://github.com/username//.git
   git push -u origin main
   ```
3. Enable GitHub Pages in repo settings

## Local Testing
```bash
python -m http.server 8000
```
