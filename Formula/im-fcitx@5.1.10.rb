class ImFcitxAT5110 < Formula
  desc "New version of Flexible Input Method Framework"
  homepage "https://github.com/fcitx/fcitx5"
  url "https://github.com/fcitx/fcitx5/archive/refs/tags/5.1.10.tar.gz"
  sha256 "a33f71e60a840b37fed7b04d2dcc7544a89bda78e4f4b2df7946ff358032a903"
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
    url "https://github.com/fcitx/fcitx5-gtk/archive/refs/tags/5.1.3.tar.gz"
    sha256 "1892fcaeed0e710cb992a87982a8af78f9a9922805a84da13f7e3d416e2a28d1"
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
