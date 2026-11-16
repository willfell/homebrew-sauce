class Sauce < Formula
  desc "Obsidian vault platform — mechanisms + blueprints for personal knowledge management"
  homepage "https://github.com/wacwini/sauce"
  url "https://github.com/wacwini/sauce/archive/refs/tags/v0.330.0.tar.gz"
  sha256 "cb2982e587143d9dfe8295776da3f4ba8434e585a4ea81df9b9057c11e1f4b34"
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
