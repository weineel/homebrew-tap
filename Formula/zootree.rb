class Zootree < Formula
  desc "A multi-repo workspace management tool with worktree, zellij, and lazygit integration"
  homepage "https://github.com/weineel/zootree"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.2/zootree-aarch64-apple-darwin.tar.xz"
      sha256 "6da1df112fb8f5cb4f89c9fb5c4a1819371420c6b2d643204801e6c4c8a101ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.2/zootree-x86_64-apple-darwin.tar.xz"
      sha256 "fd16ee5331e8c5dea175bd02bda7e64f2bd429903d71f6e897574b493aaaab2d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.2/zootree-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5b35cfffb5422ca81273778107fe5cdd8e4102e8df5ff5c154d760f40a3f6e6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.2/zootree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "60a3939c6f8b4238b3a53669c5b45c62cd149719fc48d68ff1ff003856535f81"
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
