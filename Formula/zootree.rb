class Zootree < Formula
  desc "A multi-repo workspace management tool with worktree and terminal multiplexer integration"
  homepage "https://github.com/weineel/zootree"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.1.2/zootree-aarch64-apple-darwin.tar.xz"
      sha256 "7926ba647a1389afb680c5eaae6c5e58a18cd2335bbd7c6286113313de5eaae3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.1.2/zootree-x86_64-apple-darwin.tar.xz"
      sha256 "90f32849aad41763643e9b92aba170e0c8daf30eca6eb6e2e7b8d03de5afa897"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weineel/zootree/releases/download/v0.1.2/zootree-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "25b569f1fdf183ec50f173b14cb8ad8dce3155e8c8e2b3103c7fe1e31d096810"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weineel/zootree/releases/download/v0.1.2/zootree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "026509492f41f22c6bc46f25aeaecf56365266fbba9553d0d753926ae71fa2e5"
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
