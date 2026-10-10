class Slog < Formula
  desc "Console.app for the command-line: macOS and iOS unified logs and crash reports"
  homepage "https://github.com/bratsche/slog"
  url "https://github.com/bratsche/slog/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f256696fd8d8a91d06bddf0d0350a1d164c477da17bde63fe1acd1db08717735"
  license "MIT"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  # /usr/bin/log refuses to run in brew's test sandbox, so show/stream can't be exercised.
  test do
    assert_match "slog #{version}", shell_output("#{bin}/slog --version")
    assert_match "name: slog", shell_output("#{bin}/slog skill print")
    system bin/"slog", "skill", "install", "--user" # HOME is testpath here
    assert_path_exists testpath/".claude/skills/slog/SKILL.md"
    assert_match "level must be one of", shell_output("#{bin}/slog show --filter level:bogus 2>&1", 2)
  end
end
