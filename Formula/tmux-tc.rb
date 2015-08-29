class TmuxTc < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    patch do
      url "https://gist.githubusercontent.com/zchee/9f6f2ca17acf49e04088/raw/0c9bf0d84e69cb49b5e59950dd6dde6ca265f9a1/tmux-truecolor.diff"
      sha256 "17572f1d40917a3900216b095b719c401451c93a1c61288c675a980d8031f275"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"

    system "make", "install"

    bash_completion.install "examples/bash_completion_tmux.sh" => "tmux"
    pkgshare.install "examples"
  end

  def caveats; <<-EOS.undent
    Example configurations have been installed to:
      #{pkgshare}/examples
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
