class Xfce4TerminalMlterm < Formula
  desc "Mirror repository, PRs are not watched, please use Xfce's GitLab"
  homepage "https://gitlab.xfce.org/apps/xfce4-terminal"
  license "GPL-2.0"

  stable do
    url "https://github.com/xfce-mirror/xfce4-terminal/archive/refs/tags/xfce4-terminal-1.1.3.tar.gz"
    sha256 "2c0a9a88c44554eb2bae995a68f22ce348ee5b0f3054a767b3506843d69206a0"
  end

  head do
    url "https://github.com/xfce-mirror/xfce4-terminal.git"
  end

  keg_only "it conflicts with 'z80oolong/vte/xfce4-terminal'"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "z80oolong/dep/xfce4-dev-tools@4.19.3" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "gtk-doc"
  depends_on "intltool"
  depends_on "z80oolong/dep/libxfce4ui@4.19.6"
  depends_on "z80oolong/dep/xfconf@4.19.3"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"

  def install
    ENV["LC_ALL"] = "C"
    system "./autogen.sh"

    inreplace "./configure" do |s|
      s.gsub!(%r{MAINTAINER_MODE_TRUE='#'}, %{MAINTAINER_MODE_TRUE=})
      s.gsub!(%r{MAINTAINER_MODE_FALSE=}, %{MAINTAINER_MODE_FALSE='#'})
    end

    system "./configure", "--disable-silent-rules", *std_configure_args, "--bindir=#{libexec}/bin"
    system "make"
    system "make", "install"

    script =  ""
    script << "#!/bin/sh\n"
    script << "#{Formula["z80oolong/dep/xfconf@4.19.3"].opt_lib}/xfce4/xfconf/xfconfd 2>&1 &\n"
    script << "exec #{libexec}/bin/xfce4-terminal $@\n"

    ohai "Create #{bin}/xfce4-terminal script."
    (bin/"xfce4-terminal").write(script)
    system "chmod", "0755", "#{bin}/xfce4-terminal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfce4-terminal --version")
  end
end
