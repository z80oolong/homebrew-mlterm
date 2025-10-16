class LxterminalMltermAT040 < Formula
  desc "Desktop-independent VTE-based terminal emulator"
  homepage "https://wiki.lxde.org/en/LXTerminal"
  url "https://github.com/lxde/lxterminal/archive/refs/tags/0.4.0.tar.gz"
  sha256 "1a179138ebca932ece6d70c033bc10f8125550183eb675675ee9b487c4a5a5cf"
  revision 1

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "intltool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "perl-xml-parser" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.4"

  patch :p1, Formula["z80oolong/vte/lxterminal@0.4.0"].diff_data

  def install
    ENV.prepend_path "PERL5LIB", "#{Formula["perl-xml-parser"].opt_libexec}/lib/perl5"
    ENV["LC_ALL"] = "C"

    inreplace "man/Makefile.am" do |s|
      s.gsub! %r{http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl},
        "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl-ns/manpages/docbook.xsl"
    end

    args  = std_configure_args
    args << "--enable-gtk3"
    args << "--enable-man"

    system "sh", "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"lxterminal", "--version"
  end
end
