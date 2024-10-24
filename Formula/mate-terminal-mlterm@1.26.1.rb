class MateTerminalMltermAT1261 < Formula
  desc "Terminal emulator for the MATE desktop environment"
  homepage "https://github.com/mate-desktop/mate-terminal"
  url "https://github.com/mate-desktop/mate-terminal/releases/download/v1.26.1/mate-terminal-1.26.1.tar.xz"
  sha256 "7c130206f0b47887e8c9274e73f8c19fae511134572869a7c23111b789e1e1d0"

  patch :p1, Formula["z80oolong/vte/mate-terminal@1.26.1"].diff_data

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "yelp-tools" => :build
  depends_on "itstool" => :build
  depends_on "z80oolong/dep/autoconf-archive@2023" => :build
  depends_on "z80oolong/dep/mate-common@1.24.0" => :build
  depends_on "intltool"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "gdk-pixbuf"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"
  depends_on "z80oolong/dep/dconf@0"
  depends_on "z80oolong/dep/mate-desktop"

  keg_only :versioned_formula

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
    Dir.chdir("#{HOMEBREW_PREFIX}/share/glib-2.0/schemas") do
      system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "--targetdir=.", "."
    end
  end

  def caveats; <<~EOS
    When starting #{name} installed with this Formula, the environment variables should be set as follows.
    
      export GSETTINGS_SCHEMA_DIR="#{opt_share}/glib-2.0/schemas:#{HOMEBREW_PREFIX}/share/glib-2.0/schemas:${GSETTINGS_SCHEMA_DIR}"
      export XDG_DATA_DIRS="#{opt_share}:#{HOMEBREW_PREFIX}/share:${XDG_DATA_DIRS}"
    EOS
  end

  test do
    system "false"
  end
end
