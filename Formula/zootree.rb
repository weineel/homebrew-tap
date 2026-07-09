class Zootree < Formula
  desc "A multi-repo workspace management tool with worktree and terminal multiplexer integration"
  homepage "https://github.com/weineel/zootree"
  version "0.0.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.7/zootree-aarch64-apple-darwin.tar.xz"
      sha256 "f4078759def37a033e6f6be3eb85f23640beb146c2fb5143c8e61beb2e572a97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.7/zootree-x86_64-apple-darwin.tar.xz"
      sha256 "aefd74531c88e4c43dd9c66bb9f115692dc3fcb876bf46ce6fac553d4635774b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.7/zootree-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b6cb416604fb768467fd4195253bb544743c8094d3e8725e38c0c56f644d8c93"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.7/zootree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa1888a1069647faebf8f21d184bf23115912c0349120b63c093030751c6c201"
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
