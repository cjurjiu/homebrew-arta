class Arta < Formula
  desc "Terminal workspace manager for concurrent AI coding agent sessions (tmux/zellij)"
  homepage "https://github.com/cjurjiu/arta"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cjurjiu/arta/releases/download/v0.3.0/arta-tui-aarch64-apple-darwin.tar.xz"
      sha256 "1070b431d6ee57536a2e9e11dc3b9d2e26b3b39de8d0736683989a1484464661"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cjurjiu/arta/releases/download/v0.3.0/arta-tui-x86_64-apple-darwin.tar.xz"
      sha256 "972abf9dcb58e62f16292f39883064944305604598fcf68629647d0803ce2b37"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cjurjiu/arta/releases/download/v0.3.0/arta-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c656c2eebb3f24f5822ad39ecdd2590a33622c817658264a714fe2bee105d047"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cjurjiu/arta/releases/download/v0.3.0/arta-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "67759074ae552b8675688141391c7a16ec1da37c85d5f368a4a28a6b4b74abbc"
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
