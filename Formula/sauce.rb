class Sauce < Formula
  desc "Obsidian vault platform — mechanisms + blueprints for personal knowledge management"
  homepage "https://github.com/wacwini/sauce"
  url "https://github.com/wacwini/sauce/archive/refs/tags/v0.318.0.tar.gz"
  sha256 "d76d2aab891c3f4901718845fd0c39579b9e719b65dd1f37c6fb6f0e0c2229b0"
  license "MIT"

  depends_on "node"

  def install
    # Dir["*"] skips dotfiles; .agents ships the shared skill rails (card-intake
    # script) that the loop plugin resolves beside the coordinator.
    libexec.install Dir["*"] + Dir[".agents"]
    system "npm", "install", "--omit=dev", "--prefix", libexec
    (bin/"sauce").write <<~SHIM
      #!/bin/bash
      ACTIVE="${HOME}/.sauce/active-pantry"
      if [ -L "$ACTIVE" ] && [ -d "$ACTIVE" ]; then
        SAUCE_DIR="$ACTIVE"
      else
        SAUCE_DIR="#{libexec}"
      fi
      exec node "$SAUCE_DIR/platform/cli/sauce-cli.js" "$@"
    SHIM
    chmod 0755, bin/"sauce"
  end

  test do
    assert_match "sauce", shell_output("#{bin}/sauce help")
  end
end
