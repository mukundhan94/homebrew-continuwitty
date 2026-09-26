# Continuwitty Homebrew tap

Local shared memory, web workspace, and MCP server for coding agents on macOS 13+.

```sh
brew install --HEAD mukundhan94/continuwitty/continuwitty
continuwitty serve
# In another terminal:
continuwitty menubar
```

Open http://127.0.0.1:8000/app/workspace and use `continuwitty credentials` for your local login.

Upgrade the development build with `brew upgrade --fetch-HEAD continuwitty`.
Data stays in your Application Support/continuwitty directory across upgrades.

Source and setup guide: https://github.com/mukundhan94/continuwitty

This tap currently builds main from source. Versioned binary releases are planned.
