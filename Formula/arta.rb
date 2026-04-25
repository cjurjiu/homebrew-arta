class Arta < Formula
  desc "Terminal workspace manager for concurrent AI coding agent sessions (tmux/zellij)"
  homepage "https://github.com/cjurjiu/arta"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cjurjiu/arta/releases/download/v0.2.1/arta-tui-aarch64-apple-darwin.tar.xz"
      sha256 "e79c002858617a7de0a0f657c8c684d67a73be7482f461c3c08436ead25e72c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cjurjiu/arta/releases/download/v0.2.1/arta-tui-x86_64-apple-darwin.tar.xz"
      sha256 "c04be40302e2a0796b80f2d5be9b09a401b8c35f0ee335f9c598365b85de66aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cjurjiu/arta/releases/download/v0.2.1/arta-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c6b40c6ed323e2c70fb9874a034ad0ec53e44fd0c73ea9136d4777f839442d45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cjurjiu/arta/releases/download/v0.2.1/arta-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bdecfb5682b55832fdc856818666ed79c2341147df803ae964fd4d25978ce894"
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
