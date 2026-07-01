class Zootree < Formula
  desc "A multi-repo workspace management tool with worktree, zellij, and lazygit integration"
  homepage "https://github.com/weineel/zootree"
  version "0.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.4/zootree-aarch64-apple-darwin.tar.xz"
      sha256 "76f22edbf16292c3d9068d3996e92dc027a0fe780e8baed4598ad8fa2bff2f8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.4/zootree-x86_64-apple-darwin.tar.xz"
      sha256 "f2ed0cc584029596ab263606ff027b3fd78b2ba5d2d743bb1487712451415cf3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.4/zootree-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "961a2d3f7b65f83e4ab4fd39328f5857a2c2c25e62542b83f339adda7846237b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.4/zootree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "66bfb0bf5129d029f89f789ba21098e3ec27a69cc92333f78e2358a9ee82e56a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "zootree" if OS.mac? && Hardware::CPU.arm?
    bin.install "zootree" if OS.mac? && Hardware::CPU.intel?
    bin.install "zootree" if OS.linux? && Hardware::CPU.arm?
    bin.install "zootree" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
