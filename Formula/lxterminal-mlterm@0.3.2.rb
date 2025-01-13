class LxterminalMltermAT032 < Formula
  desc "Desktop-independent VTE-based terminal emulator"
  homepage "https://wiki.lxde.org/en/LXTerminal"
  url "https://github.com/lxde/lxterminal/archive/refs/tags/0.3.2.tar.gz"
  sha256 "03c6bdc0fcf7a2e2760e780d2499b618471b0960625d73f9b77654cd58c54ec5"

  keg_only :versioned_formula

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

  patch :p1, Formula["z80oolong/vte/lxterminal@0.3.2"].diff_data

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
