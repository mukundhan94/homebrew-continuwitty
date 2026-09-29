class ContinuwittyClient < Formula
  desc "Connect coding agents to a remote Continuwitty MCP server"
  homepage "https://github.com/mukundhan94/homebrew-continuwitty"
  version "0.1.0"

  if Hardware::CPU.arm?
    url "https://github.com/mukundhan94/homebrew-continuwitty/releases/download/client-v0.1.0/continuwitty-client-darwin-arm64.tar.gz"
    sha256 "a7f9a4d01cc30416f6ed0f3a22d1a4e77bc6a71528023cfc1d11b08aad66c1a4"
  else
    url "https://github.com/mukundhan94/homebrew-continuwitty/releases/download/client-v0.1.0/continuwitty-client-darwin-amd64.tar.gz"
    sha256 "4007568d11e416377fba39cd645d8de1a7c155ab2ff4cf8df55b2c31968ffacf"
  end

  depends_on macos: :ventura

  def install
    bin.install "continuwitty" => "continuwitty-client"
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      Connect to an existing server; no local database or server is installed.
      Get a personal token from your server's /app/tokens page, then:
        pbpaste | continuwitty-client token import --output ~/.config/continuwitty/team.token
        continuwitty-client integrate verify --url https://YOUR-SERVER --token-file ~/.config/continuwitty/team.token
        continuwitty-client integrate claude --url https://YOUR-SERVER --token-file ~/.config/continuwitty/team.token

      Clear the clipboard after importing the token. Remote endpoints require HTTPS.
      Targets: claude, claude-desktop, codex, copilot, vscode.
      This command can coexist with the full continuwitty host installation.
      Help: continuwitty-client --help
    EOS
  end

  test do
    command = bin/"continuwitty-client"
    assert_match "client-#{version}", shell_output("#{command} version")
    assert_match "Client-only", shell_output("#{command} --help")
    assert_match "client-only", shell_output("#{command} serve 2>&1", 1)
    token = "engram_mcp_00000000000040008000000000000001_test_secret_for_formula_checks"
    token_path = testpath/"client.token"
    imported = pipe_output("#{command} token import --output #{token_path}", token, 0)
    refute_match token, imported
    assert_equal 0600, token_path.stat.mode & 0777
    refute JSON.parse(imported)["server_verified"]
    args = "integrate claude --url https://example.com --token-file #{token_path} --dry-run"
    preview = JSON.parse(shell_output("#{command} #{args}"))
    bridge = JSON.parse(preview.fetch("args").last)
    assert_equal "#{HOMEBREW_PREFIX}/bin/continuwitty-client", bridge.fetch("command")
    refute_match token, preview.to_json
  end
end
