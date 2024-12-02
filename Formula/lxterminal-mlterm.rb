class LxterminalMlterm < Formula
  desc "Desktop-independent VTE-based terminal emulator"
  homepage "https://wiki.lxde.org/en/LXTerminal"

  stable do
    url "https://github.com/lxde/lxterminal/archive/refs/tags/0.4.0.tar.gz"
    sha256 "1a179138ebca932ece6d70c033bc10f8125550183eb675675ee9b487c4a5a5cf"

    patch :p1, Formula["z80oolong/vte/lxterminal@0.4.0"].diff_data
  end

  head do
    url "https://github.com/lxde/lxterminal.git"

    patch :p1, Formula["z80oolong/vte/lxterminal"].diff_data
  end

  keg_only "this formula conflicts with 'z80oolong/vte/lxterminal'"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "intltool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "perl-xml-parser" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"

  def install
    ENV.prepend_path "PERL5LIB", "#{Formula["perl-xml-parser"].opt_libexec}/lib/perl5"

    inreplace "man/Makefile.am" do |s|
      s.gsub! %r{http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl},
        "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl-ns/manpages/docbook.xsl"
    end

    system "sh", "./autogen.sh"

    args  = std_configure_args
    args << "--enable-gtk3"
    args << "--enable-man"
    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    system bin/"lxterminal", "--version"
  end
end
