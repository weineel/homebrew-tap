class Zootree < Formula
  desc "A multi-repo workspace management tool with worktree and terminal multiplexer integration"
  homepage "https://github.com/weineel/zootree"
  version "0.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.6/zootree-aarch64-apple-darwin.tar.xz"
      sha256 "0f123a22b7ce01816d93d5e2c24c22b706c55fa0647f4cea1ee057b3c4ac8abd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.6/zootree-x86_64-apple-darwin.tar.xz"
      sha256 "2a1cb038a743ee4de0f66cf040e930d8ed1f9cb570a76f10067c88dc74a9fc4e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.6/zootree-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bed22cecc10eb964324aa85ede6ceea9005f67f32018e00ea738ff6930ffbe6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.6/zootree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5ca9a9284556098a5df0e3842f8aab0b86a028ee90b3fcb17ac539edfafee4ca"
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
