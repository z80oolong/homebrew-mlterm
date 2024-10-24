class RoxtermMltermAT3132 < Formula
  desc "ROXTerm is a terminal emulator intended to provide similar features to gnome-terminal, based on the same VTE library, but with a smaller footprint and quicker start-up time."
  homepage "https://roxterm.sourceforge.io/"
  url "https://github.com/realh/roxterm/archive/refs/tags/3.13.2.tar.gz"
  sha256 "3d3bea60178e30740c52594b59d5b1758f26ef0ae5a9fa8a41359c4c36c22d4a"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libxslt" => :build
  depends_on "docbook-xsl" => :build
  depends_on "glib"
  depends_on "dbus-glib"
  depends_on "gtk+3"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"

  keg_only :versioned_formula

  patch :p1, Formula["z80oolong/vte/roxterm@3.13.2"].diff_data

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
