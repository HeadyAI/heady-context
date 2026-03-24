# Troubleshooting Guide

## Common Issues

### "heady" command not found

**Windows:**

1. Restart your terminal/PowerShell after installation
2. If still not working, run: `$env:PATH += ";$PWD\sdk\bin"`
3. Or run directly: `node sdk\bin\heady.js health`

**Linux/Mac:**

1. Run: `source ~/.bashrc` (or `~/.zshrc`)
2. Or run directly: `node sdk/bin/heady.js health`

### MCP server not appearing in IDE

1. Verify the config file exists:
   - **Antigravity:** `~/.config/google/antigravity/mcp.json` (Linux) or `%APPDATA%\google\antigravity\mcp.json` (Windows)
   - **VS Code:** `~/.vscode/mcp.json`
   - **Cursor:** `~/.cursor/mcp.json`
2. Re-run the installer: `./install.sh` or `install.cmd`
3. Restart the IDE

### Connection timeout to Heady services

1. Check internet connectivity
2. Verify endpoints are reachable:

   ```bash
   curl -s https://manager.headysystems.com/health
   curl -s https://heady.headyme.com/health
   ```

3. Check your API key in `.env`

### Node.js version too old

Heady requires Node.js 18+. Check: `node -v`

**Windows:** `winget install OpenJS.NodeJS.LTS`
**Linux:** `curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs`
**Mac:** `brew install node`

### Chrome extension not loading

1. Make sure Developer mode is ON in `chrome://extensions`
2. Verify `chrome-extension/manifest.json` exists
3. Try removing and re-loading the unpacked extension

### "Permission denied" on install.sh

```bash
chmod +x install.sh
./install.sh
```

### API rate limits

Internal tier has unlimited access. If you see rate limit errors:

1. Check `.env` has the correct `HEADY_API_KEY`
2. Verify the key starts with `hdy_int_` (internal tier)
3. Contact Eric for key rotation

---

## Getting Help

- **CLI diagnostics:** `heady health`
- **Developer Hub:** [headymcp.com](https://headymcp.com)
- **Contact:** Eric @ HeadySystems LLC

---

*© 2026 HeadySystems LLC*
