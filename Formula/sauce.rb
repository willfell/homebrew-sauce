class Sauce < Formula
  desc "Obsidian vault platform — mechanisms + blueprints for personal knowledge management"
  homepage "https://github.com/wacwini/sauce"
  url "https://github.com/wacwini/sauce/archive/refs/tags/v0.304.1.tar.gz"
  sha256 "e41635dcd7284a78e643271e1468d7dc78f7e245a14fe13c4cc3436152065d90"
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
