class << ENV
  def replace_rpath(**replace_list)
    replace_list = replace_list.each_with_object({}) do |(old, new), result|
      result[Formula[old].opt_lib.to_s] = Formula[new].opt_lib.to_s
      result[Formula[old].lib.to_s] = Formula[new].lib.to_s
    end
    rpaths = self["HOMEBREW_RPATH_PATHS"].split(":")
    rpaths = rpaths.each_with_object([]) {|rpath, result| result << (replace_list.key?(rpath) ? replace_list[rpath] : rpath) }
    self["HOMEBREW_RPATH_PATHS"] = rpaths.join(":")
  end
end

class RoxtermMltermAT3166 < Formula
  desc "Highly configurable terminal emulator based on VTE"
  homepage "https://roxterm.sourceforge.io/"
  url "https://github.com/realh/roxterm/archive/refs/tags/3.16.6.tar.gz"
  sha256 "153fbb0746c3afa45bede7e3f6aa0e0ab0ce698d3bfe4ac1962f9da0a1a44145"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "libxslt" => :build
  depends_on "pkg-config" => :build
  depends_on "dbus-glib"
  depends_on "glib"
  depends_on "z80oolong/vte/gtk+3@3.24.43" => :optional
  unless build.with? "z80oolong/vte/gtk+3@3.24.43"
    depends_on "gtk+3"
  end
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.4"

  resource("roxterm-ja-po") do
    url "https://gist.github.com/731fd4e4d0adb4178ce69885bf061523.git",
        branch:   "main",
        revision: "72cd4d52211814ac3a8cecd2fc197447c3914c47"
  end

  patch :p1, Formula["z80oolong/vte/roxterm@3.16.6"].diff_data

  def install
    if build.with? "z80oolong/vte/gtk+3@3.24.43"
      ENV.replace_rpath "gtk+3" => "z80oolong/vte/gtk+3@3.24.43"
    end
    ENV.append "CFLAGS", "-D_GNU_SOURCE"
    ENV.append "CFLAGS", "-DENABLE_NLS=1"

    inreplace "CMakeLists.txt" do |s|
      s.gsub! %r{http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl},
        "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl-ns/manpages/docbook.xsl"
    end

    inreplace "./src/config.h.in" do |s|
      s.gsub!(/^#undef ENABLE_NLS/, "#define ENABLE_NLS 1")
    end

    args  = std_cmake_args
    args << "CMAKE_BUILD_TYPE=Debug"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("roxterm-ja-po").stage do
      (share/"locale/ja/LC_MESSAGES").mkpath
      (share/"locale/en_US/LC_MESSAGES").mkpath

      system Formula["gettext"].opt_bin/"msgfmt", "-o", share/"locale/ja/LC_MESSAGES/roxterm.mo", "./ja.po"
      system Formula["gettext"].opt_bin/"msgfmt", "-o", share/"locale/en_US/LC_MESSAGES/roxterm.mo", "./en_US.po"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/roxterm --version")
  end
end
