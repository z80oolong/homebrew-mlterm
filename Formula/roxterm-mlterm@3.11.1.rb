class RoxtermMltermAT3111 < Formula
  desc "ROXTerm is a terminal emulator intended to provide similar features to gnome-terminal, based on the same VTE library, but with a smaller footprint and quicker start-up time."
  homepage "https://roxterm.sourceforge.io/"
  url "https://github.com/realh/roxterm/archive/refs/tags/3.11.1.tar.gz"
  sha256 "a362d4b6ca89091d277c710c6a4dcec67a9429d519086b911941b66af1e8e3e3"

  resource("roxterm-ja-po") do
    url "https://gist.github.com/731fd4e4d0adb4178ce69885bf061523.git",
        :branch => "main",
        :revision => "72cd4d52211814ac3a8cecd2fc197447c3914c47"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libxslt" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "glib"
  depends_on "dbus-glib"
  depends_on "gtk+3"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"

  keg_only :versioned_formula

  patch :p1, Formula["z80oolong/vte/roxterm@3.11.1"].diff_data

  def install
    ENV.append "CFLAGS", "-D_GNU_SOURCE"
    ENV.append "CFLAGS", "-DENABLE_NLS=1"

    inreplace "CMakeLists.txt" do |s|
      s.gsub!(%r|http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl|, "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl-ns/manpages/docbook.xsl")
    end

    inreplace "./src/config.h.in" do |s|
      s.gsub!(%r|^#undef ENABLE_NLS|, "#define ENABLE_NLS 1")
    end


    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    resource("roxterm-ja-po").stage do
      (share/"locale/ja/LC_MESSAGES").mkpath
      (share/"locale/en_US/LC_MESSAGES").mkpath

      system "#{Formula["gettext"].opt_bin}/msgfmt", "-o", "#{share}/locale/ja/LC_MESSAGES/roxterm.mo", "./ja.po"
      system "#{Formula["gettext"].opt_bin}/msgfmt", "-o", "#{share}/locale/en_US/LC_MESSAGES/roxterm.mo", "./en_US.po"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/roxterm --version")
  end
end
