class ImScimAT1418 < Formula
  desc "Smart Common Input Method platform"
  homepage "https://github.com/scim-im/scim"
  url "https://github.com/scim-im/scim/archive/refs/tags/1.4.18.tar.gz"
  sha256 "072d79dc3c7277b8e8fcb1caf1a83225c3bf113d590f314b85ae38024427a228"
  license "GPL-2.0-or-later"

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "perl" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "glibc"
  depends_on "libtool"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxcb"
  depends_on "pango"
  depends_on "pkg-config"

  def install
    ENV["LC_ALL"] = "C"

    system "./bootstrap"

    args  = std_configure_args
    args << "--disable-silent-rules"
    args << "--disable-documents"
    args << "--with-x"
    args << "--without-doxygen"
    args << "--disable-gtk2-immodule"
    args << "--disable-gtk3-immodule"
    args << "--disable-qt3-immodule"
    args << "--disable-qt4-immodule"
    args << "--disable-panel-gtk"
    args << "--disable-setup-ui"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/scim-setup", "--version"
  end
end
