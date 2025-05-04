class ImFcitxAT4298 < Formula
  desc "Flexible Input Method Framework"
  homepage "https://fcitx-im.org/"
  url "https://github.com/fcitx/fcitx/archive/refs/tags/4.2.9.8.tar.gz"
  sha256 "1b630d278d955b64b20ebcdf8ff4bb78be8af0d6b042383274993a2cb4642d21"
  license "GPL-2.0-or-later"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "glibc"
  depends_on "intltool"
  depends_on "json-c"
  depends_on "librsvg"
  depends_on "libxkbcommon"
  depends_on "libxml2"
  depends_on "pcre"
  depends_on "sqlite"

  on_macos do
    depends_on "libiconv"
  end

  def install
    args  = std_cmake_args
    args << "-DENABLE_X11=ON"
    args << "-DENABLE_GTK2_IM_MODULE=OFF"
    args << "-DENABLE_GTK3_IM_MODULE=OFF"
    args << "-DENABLE_QT=OFF"
    args << "-DENABLE_QT_IM_MODULE=OFF"
    args << "-DENABLE_QT_GUI=OFF"
    args << "-DENABLE_GIR=OFF"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Fcitx is an input method framework for Linux. In order to use it, you may need to
      install additional input methods or configure your system to use it.

      For GTK+3 users, make sure to set the following environment variables in your shell startup script:

        export XMODIFIERS=@im=fcitx
        export GTK_IM_MODULE=fcitx
        export QT_IM_MODULE=fcitx
        export DefaultIMModule=fcitx

      To configure Fcitx, run the following command:

        fcitx-config-gtk3
    EOS
  end

  test do
    system "#{bin}/fcitx", "--version"
  end
end
