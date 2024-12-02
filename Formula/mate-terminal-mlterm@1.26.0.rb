class MateTerminalMltermAT1260 < Formula
  desc "Terminal emulator for the MATE desktop environment"
  homepage "https://github.com/mate-desktop/mate-terminal"
  url "https://github.com/mate-desktop/mate-terminal/releases/download/v1.26.0/mate-terminal-1.26.0.tar.xz"
  sha256 "7727e714c191c3c55e535e30931974e229ca5128e052b62ce74dcc18f7eaaf22"

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "itstool" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "pkg-config" => :build
  depends_on "yelp-tools" => :build
  depends_on "z80oolong/dep/autoconf-archive@2023" => :build
  depends_on "z80oolong/dep/mate-common@1.24.0" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "z80oolong/dep/dconf@0"
  depends_on "z80oolong/dep/mate-desktop"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"

  patch :p1, Formula["z80oolong/vte/mate-terminal@1.26.0"].diff_data

  def install
    aclocal_flags =  ""
    aclocal_flags << "-I #{Formula["z80oolong/dep/autoconf-archive@2023"].opt_share}/aclocal "
    aclocal_flags << "-I #{Formula["z80oolong/dep/mate-common@1.24.0"].opt_share}/aclocal"
    ENV["ACLOCAL_FLAGS"] = aclocal_flags

    system "sh", "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def post_install
    Dir.chdir(HOMEBREW_PREFIX/"share/glib-2.0/schemas") do
      system Formula["glib"].opt_bin/"glib-compile-schemas", "--targetdir=.", "."
    end
  end

  def caveats
    <<~EOS
      When starting mate-terminal installed with this Formula, the environment variables should be set as follows.

        export GSETTINGS_SCHEMA_DIR="#{HOMEBREW_PREFIX}/share/glib-2.0/schemas:${GSETTINGS_SCHEMA_DIR}"
        export XDG_DATA_DIRS="#{HOMEBREW_PREFIX}/share:${XDG_DATA_DIRS}"
    EOS
  end

  test do
    system bin/"mate-terminal", "--version"
  end
end
