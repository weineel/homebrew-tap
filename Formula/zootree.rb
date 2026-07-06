class Zootree < Formula
  desc "A multi-repo workspace management tool with worktree, zellij, and lazygit integration"
  homepage "https://github.com/weineel/zootree"
  version "0.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.5/zootree-aarch64-apple-darwin.tar.xz"
      sha256 "0b041a1a755a0b0231fd78c26c1b42e3017df07c34653e57d42f2cc8cbc3ba4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.5/zootree-x86_64-apple-darwin.tar.xz"
      sha256 "cf287e368caecfbe08ea1a3e2b41717d6e5a9cadc946a3889d22a006cb1e8a59"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.5/zootree-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ff102be110369157432d3e3122f81fa41059e66a6d89c6333b31d69e169b2c1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.5/zootree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c5310f89c0e8521efb18db740b6272ce067581e2a551ebe97d2e70c96362a095"
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
