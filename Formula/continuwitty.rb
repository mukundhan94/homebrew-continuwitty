class Continuwitty < Formula
  desc "Local shared memory and MCP server for coding agents"
  homepage "https://github.com/mukundhan94/continuwitty"
  head "https://github.com/mukundhan94/continuwitty.git", branch: "main"

  depends_on macos: :ventura
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "postgresql@17"
  depends_on "pgvector"

  def install
    cd "web" do
      system "npm", "ci"
      system "npm", "run", "build"
    end
    ldflags = "-s -w -X main.version=#{version} " \
              "-X engram/internal/localdb.DefaultBin=#{Formula["postgresql@17"].opt_bin}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "embedweb", "./cmd/continuwitty"
    ENV["CONTINUWITTY_HOMEBREW_BUILD"] = "1"
    system "./scripts/build-menubar.sh", "#{libexec}/Continuwitty.app"
  end

  service do
    run [opt_bin/"continuwitty", "serve"]
    keep_alive true
    log_path var/"log/continuwitty.log"
    error_log_path var/"log/continuwitty.log"
  end

  def caveats
    <<~EOS
      Start the database, web UI, and MCP API together:
        continuwitty serve
      Open the native menu bar companion:
        continuwitty menubar
      Open http://127.0.0.1:8000/app/workspace
      Show your generated local login:
        continuwitty credentials

      Postgres runs privately under Continuwitty. Do not start a separate
      postgresql@17 service for this app. Data is retained in your user
      Application Support/continuwitty directory when the app is stopped
      or uninstalled. Set DATABASE_URL to use an external database instead.

      See: continuwitty token --help
           continuwitty integrate --help
    EOS
  end

  test do
    assert_predicate libexec/"Continuwitty.app/Contents/MacOS/ContinuwittyMenu", :executable?
    assert_match "menu bar", shell_output("#{bin}/continuwitty menubar --help")
    assert_match "Usage: continuwitty", shell_output("#{bin}/continuwitty --help")
    assert_match "-scope", shell_output("#{bin}/continuwitty token create --help 2>&1")
    assert_match "--token-file", shell_output("#{bin}/continuwitty integrate codex --help 2>&1")
  end
end
