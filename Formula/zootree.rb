class Zootree < Formula
  desc "A multi-repo workspace management tool with worktree and terminal multiplexer integration"
  homepage "https://github.com/weineel/zootree"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.1.0/zootree-aarch64-apple-darwin.tar.xz"
      sha256 "43ea2cd2e00fe1be3f5f13122b3d6463da6aa2bee596913887d775ad11cdfc0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.1.0/zootree-x86_64-apple-darwin.tar.xz"
      sha256 "71f260be02546643fccd520368c11e45ef3d2707ba3fb4f0b94bd324399c7e7a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.1.0/zootree-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2febe34f116506e87d7690478e3b181b21808a953d5cd7885fd673d3fe3082ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.1.0/zootree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c4145fa25818f7d04ff8c7be2294b12e7e6ac075711e5630360036f01480b8a5"
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
