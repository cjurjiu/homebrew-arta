class Arta < Formula
  desc "Terminal workspace manager for concurrent AI coding agent sessions (tmux/zellij)"
  homepage "https://github.com/cjurjiu/arta"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cjurjiu/arta/releases/download/v0.4.0/arta-tui-aarch64-apple-darwin.tar.xz"
      sha256 "4d35b9dbc5e9589998d992b51f936767fbab3e2884a864d589ef262878f85141"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cjurjiu/arta/releases/download/v0.4.0/arta-tui-x86_64-apple-darwin.tar.xz"
      sha256 "878332e155b71af352b36afbf28c04eab07f59b36fb27f5233814d0760a37111"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cjurjiu/arta/releases/download/v0.4.0/arta-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ba284f9c8ef5e804283672d20c12561b6f45bc720309c56e5e6ac7aeed2de9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cjurjiu/arta/releases/download/v0.4.0/arta-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7a39e4d3ab769f018d08b1b77e8a459c1afeb478a988e5495ab9fe846116c7c6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "arta" if OS.mac? && Hardware::CPU.arm?
    bin.install "arta" if OS.mac? && Hardware::CPU.intel?
    bin.install "arta" if OS.linux? && Hardware::CPU.arm?
    bin.install "arta" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
