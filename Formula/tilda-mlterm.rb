class TildaMlterm < Formula
  desc "Gtk-based drop down terminal for Linux and Unix"
  homepage "https://github.com/lanoxx/tilda"
  license "GPL-2.0"

  stable do
    url "https://github.com/lanoxx/tilda/archive/refs/tags/tilda-2.0.0.tar.gz"
    sha256 "ff9364244c58507cd4073ac22e580a4cded048d416c682496c1b1788ee8a30df"

    patch :p1, Formula["z80oolong/vte/tilda@2.0.0"].diff_data
  end

  head do
    url "https://github.com/lanoxx/tilda.git"

    patch :p1, Formula["z80oolong/vte/tilda"].diff_data
  end

  keg_only "this formula conflicts with 'z80oolong/vte/tilda'"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "perl" => :build
  depends_on "z80oolong/dep/libconfuse@3.3" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"

  def install
    ENV["LC_ALL"] = "C"
    system "./autogen.sh"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"tilda", "--version"
  end
end
