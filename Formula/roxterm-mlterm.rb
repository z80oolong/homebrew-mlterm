class RoxtermMlterm < Formula
  desc "ROXTerm is a terminal emulator intended to provide similar features to gnome-terminal, based on the same VTE library, but with a smaller footprint and quicker start-up time."
  homepage "https://roxterm.sourceforge.io/"

  stable do
    url "https://github.com/realh/roxterm/archive/refs/tags/3.14.3.tar.gz"
    sha256 "4f801371113ff33d6a53dfa77aef6c3d09d29620fcf27e844c755904f9776e5b"
    patch :p1, Formula["z80oolong/vte/roxterm@3.14.3"].diff_data
  end

  head do
    url "https://github.com/realh/roxterm.git"
    patch :p1, Formula["z80oolong/vte/roxterm"].diff_data
    patch :p1, :DATA
  end

  keg_only "it conflicts with 'z80oolong/vte/roxterm'"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libxslt" => :build
  depends_on "docbook-xsl" => :build
  depends_on "glib"
  depends_on "dbus-glib"
  depends_on "gtk+3"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"

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
