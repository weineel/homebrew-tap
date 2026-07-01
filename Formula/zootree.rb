class Zootree < Formula
  desc "A multi-repo workspace management tool with worktree, zellij, and lazygit integration"
  homepage "https://github.com/weineel/zootree"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.3/zootree-aarch64-apple-darwin.tar.xz"
      sha256 "135fcf2a5ed92ea1800aaf1d35b468eba02e9f552937a6f7c2854fd4ff6e85ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.3/zootree-x86_64-apple-darwin.tar.xz"
      sha256 "6d78fee7b04e0cb320f3035fdc3b712a6e2ddf45106127d6f35b150ebabf088f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.3/zootree-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bb3dc6132d34ed27174c3276506bfe0567b632a2d6210c9e258772b67ba85464"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.3/zootree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ed3bf8b9da1923765c81d268bee46da674b679e291510d2f14111a2ed714e1d3"
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
