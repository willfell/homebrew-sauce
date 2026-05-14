class Sauce < Formula
  desc "Obsidian vault platform — mechanisms + blueprints for personal knowledge management"
  homepage "https://github.com/willfell/sauce"
  url "https://github.com/willfell/sauce/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "205ba8fbb551ece9750ee6caccfac13f7070149a105df77bccf73f3f5770a565"
  license "MIT"

  depends_on "node"

  def install
    libexec.install Dir["*"]
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
