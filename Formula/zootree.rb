class Zootree < Formula
  desc "A multi-repo workspace management tool with worktree and terminal multiplexer integration"
  homepage "https://github.com/weineel/zootree"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.1.1/zootree-aarch64-apple-darwin.tar.xz"
      sha256 "2d7dfb6709f5054b4fc6cd40572c3e06a22046675143cc0533cdf4c3f5dd1e0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.1.1/zootree-x86_64-apple-darwin.tar.xz"
      sha256 "57383c8995505bf24e55770464d77dec3ae35edc082e1c8822d78e38ee77d8fc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.1.1/zootree-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9b0fd80d3f8c5cc6537b637dc5ba4854d2dce179c3fb353a13b87910b8949703"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.1.1/zootree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "81683f635738825dd126f25a339567be833fcee3526fdec830e33552608acf33"
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
