class ImFcitxAT5112 < Formula
  desc "New version of Flexible Input Method Framework"
  homepage "https://github.com/fcitx/fcitx5"
  url "https://github.com/fcitx/fcitx5/archive/refs/tags/5.1.12.tar.gz"
  sha256 "04fabc12cb8702f06aeb1399f30d41dd9c17a997ccac9a53352ba21a8aef16e7"
  license "GPL-2.0-or-later"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "fmt" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "glibc"
  depends_on "gobject-introspection"
  depends_on "intltool"
  depends_on "json-c"
  depends_on "librsvg"
  depends_on "libxkbcommon"
  depends_on "libxml2"
  depends_on "pcre"
  depends_on "sqlite"

  resource("xcb-imdkit") do
    url "https://github.com/fcitx/xcb-imdkit/archive/refs/tags/1.0.9.tar.gz"
    sha256 "c2f0bbad8a335a64cdc7c19ac7b6ea1f0887dd6300ca9a4fa2e2fec6b9d3f695"
  end

  resource("fcitx5-gclient") do
    url "https://github.com/fcitx/fcitx5-gtk/archive/refs/tags/5.1.4.tar.gz"
    sha256 "73f63d10078c62e5b6d82e6b16fcb03d2038cc204fc00052a34ab7962b0b7815"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"

    resource("xcb-imdkit").stage do
      args  = std_cmake_args.dup
      args << "-DBUILD_SHARED_LIBS=ON"
      args << "-DUSE_SYSTEM_UTHASH=OFF"

      system "cmake", "-S", ".", "-B", "build", *args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    args  = std_cmake_args.dup
    args << "-DENABLE_X11=ON"
    args << "-DENABLE_WAYLAND=OFF"
    args << "-DENABLE_SERVER=OFF"
    args << "-DUSE_SYSTEMD=OFF"
    args << "-DENABLE_LIBUUID=OFF"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("fcitx5-gclient").stage do
      args  = std_cmake_args
      args << "-DENABLE_GIR=ON"
      args << "-DENABLE_GTK2_IM_MODULE=OFF"
      args << "-DENABLE_GTK3_IM_MODULE=OFF"
      args << "-DENABLE_GTK4_IM_MODULE=OFF"
      args << "-DENABLE_SNOOPER=OFF"

      system "cmake", "-S", ".", "-B", "build", *args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    system "#{bin}/fcitx5", "--version"
  end
end
