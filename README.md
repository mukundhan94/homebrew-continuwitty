# Continuwitty Homebrew tap

Local shared memory, web workspace, and MCP server for coding agents on macOS 13+.

The tap is public; the application source is private. Installation and upgrades
require a GitHub account granted access to `mukundhan94/continuwitty` and working
HTTPS Git credentials. Verify access before installing:

```sh
git ls-remote https://github.com/mukundhan94/continuwitty.git HEAD
```

Use an approved Git credential helper, such as `gh auth login` followed by
`gh auth setup-git`. Never put a token in the formula or repository URL.
If Git reports “Repository not found”, check source access and the account used
by your credential helper. Public binary releases are not available yet.

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
