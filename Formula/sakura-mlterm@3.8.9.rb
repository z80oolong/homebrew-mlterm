class SakuraMltermAT389 < Formula
  desc "GTK/VTE based terminal emulator"
  homepage "https://launchpad.net/sakura"
  url "https://github.com/dabisu/sakura/archive/refs/tags/SAKURA_3_8_9.tar.gz"
  sha256 "46b792098a82ba4affc87a174ae96f32e730396e4f5ba9b699e8071253b085a2"
  license "GPL-2.0"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pod2man" => :build
  depends_on "gettext"
  depends_on "systemd"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.4"

  patch :p1, Formula["z80oolong/vte/sakura@3.8.8"].diff_data

  def install
    args  = std_cmake_args
    args << "CMAKE_BUILD_TYPE=Debug"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"sakura", "--version"
  end
end
