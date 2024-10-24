class RoxtermMltermAT3131 < Formula
  desc "ROXTerm is a terminal emulator intended to provide similar features to gnome-terminal, based on the same VTE library, but with a smaller footprint and quicker start-up time."
  homepage "https://roxterm.sourceforge.io/"
  url "https://github.com/realh/roxterm/archive/refs/tags/3.13.1.tar.gz"
  sha256 "74844cf9a34a79498fa3153a45e96ccad2f2d9122379f43b56fe5a65d1801a7a"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libxslt" => :build
  depends_on "docbook-xsl" => :build
  depends_on "glib"
  depends_on "dbus-glib"
  depends_on "gtk+3"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"

  keg_only :versioned_formula

  patch :p1, Formula["z80oolong/vte/roxterm@3.13.1"].diff_data

  def install
    inreplace "CMakeLists.txt" do |s|
      s.gsub!(%r|http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl|, "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl-ns/manpages/docbook.xsl")
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/roxterm --version")
  end
end
