class Zootree < Formula
  desc "A multi-repo workspace management tool with worktree and terminal multiplexer integration"
  homepage "https://github.com/weineel/zootree"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.1.3/zootree-aarch64-apple-darwin.tar.xz"
      sha256 "88e6838817cc3fd88c99491fd9200592523cf60c9d74821ef5c6051bfbd234dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.1.3/zootree-x86_64-apple-darwin.tar.xz"
      sha256 "85ec96c5c35ef83eb21e68fd562efe6a15681d66488ae62156ebb7f14806c307"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.1.3/zootree-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f94f3d5b94362e763a17c536a770cda6252493dafd52e082f1e9632f78c889d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.1.3/zootree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "378a2dd33cfcb910f46c0572c45d46cae34eb7dd3a661a49266237d68b53ef53"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "zootree"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "zootree"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "zootree"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "zootree"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
