class Zootree < Formula
  desc "A multi-repo workspace management tool with worktree, zellij, and lazygit integration"
  homepage "https://github.com/weineel/zootree"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.1/zootree-aarch64-apple-darwin.tar.xz"
      sha256 "c36288f12f45867c0e6dcb1351825ee48ed946d770d7fa57059a20c95aa06a3a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.1/zootree-x86_64-apple-darwin.tar.xz"
      sha256 "dab122a55344b9061a852a3418791113ea701f1e681177036eae111b00a5bd41"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.0.1/zootree-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a79620786a849eae45d023dacd4c8cc3602e3dd26f166b872fde96b8008fb628"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.0.1/zootree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f5e9ae10dcbe02b73efcca90f484ecfab3cf20342d4afdeaccada1829c7b9d43"
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
