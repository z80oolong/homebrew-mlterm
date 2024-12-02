class SakuraMltermAT384 < Formula
  desc "GTK/VTE based terminal emulator"
  homepage "https://launchpad.net/sakura"
  url "https://github.com/dabisu/sakura/archive/refs/tags/SAKURA_3_8_4.tar.gz"
  sha256 "49d056195d3e469c4bc5bef020c9f00af5477a030481d4bf5e2f7ca26bd7e8c7"
  license "GPL-2.0"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pod2man" => :build
  depends_on "gettext"
  depends_on "systemd"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"

  patch :p1, Formula["z80oolong/vte/sakura@3.8.4"].diff_data

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
