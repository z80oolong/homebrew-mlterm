class RoxtermMltermAT9999Dev < Formula
  desc "Highly configurable terminal emulator based on VTE"
  homepage "https://roxterm.sourceforge.io/"

  @@current_commit = "c5a983c570323a6e8d1f7c5767de67013a2f610e"
  url "https://github.com/realh/roxterm.git",
    branch:   "master",
    revision: @@current_commit
  version "git-#{@@current_commit[0..7]}"
  revision 1
  license "LGPL-3.0"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "dbus-glib"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.4"

  resource("roxterm-ja-po") do
    url "https://gist.github.com/731fd4e4d0adb4178ce69885bf061523.git",
        branch:   "main",
        revision: "72cd4d52211814ac3a8cecd2fc197447c3914c47"
  end

  patch :p1, Formula["z80oolong/vte/roxterm@9999-dev"].diff_data

  def install
    ENV.append "CFLAGS", "-D_GNU_SOURCE"
    ENV.append "CFLAGS", "-DENABLE_NLS=1"

    inreplace "./src/config.h.in" do |s|
      s.gsub!(/^#cmakedefine ENABLE_NLS/, "#define ENABLE_NLS 1")
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

  def caveats
    <<~EOS
      #{full_name} is a Formula for installing the development version of
      `roxterm` based on the HEAD version (commit #{@@current_commit[0..7]}) from its git repository.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/roxterm --version")
  end
end
