# Continuwitty Homebrew tap

## Remote client — public binaries

Connect agents to an existing server on macOS 13+:

```sh
brew install mukundhan94/continuwitty/continuwitty-client
continuwitty-client --help
```

Apple Silicon and Intel binaries are downloaded from this public repository.
No private-repository access, Go, Node, or Postgres is required. The client
coexists with the full host using the separate `continuwitty-client` command.

Create a personal token in the hosted app's **Access tokens** page, copy it, then:

```sh
pbpaste | continuwitty-client token import --output ~/.config/continuwitty/team.token
continuwitty-client integrate verify --url https://YOUR-SERVER --token-file ~/.config/continuwitty/team.token
continuwitty-client integrate claude --url https://YOUR-SERVER --token-file ~/.config/continuwitty/team.token
```

Clear the clipboard after importing. Remote servers require HTTPS. Other setup
targets are `claude-desktop`, `codex`, `copilot`, and `vscode`; use `--dry-run` to
preview. Verification checks the endpoint/token, not a persistent agent connection.
Browser login and Keychain profiles are not available yet.

Upgrade with `brew upgrade continuwitty-client`. Releases include SHA256 checksums
and source commit metadata. Binaries are not Developer ID signed or notarized.

## Full host — private source access

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
by your credential helper. The full host still builds from private source.

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

The full host builds main from source. The separate remote client uses public versioned binaries.
