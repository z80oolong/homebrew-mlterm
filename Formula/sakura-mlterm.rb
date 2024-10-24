class SakuraMlterm < Formula
  desc "MLTerm/VTE based terminal emulator."
  homepage "https://launchpad.net/sakura"
  license "GPL-2.0"

  stable do
    url "https://github.com/dabisu/sakura/archive/refs/tags/SAKURA_3_8_8.tar.gz"
    sha256 "b2b05e9e389dafe7bf41fd2fd4ca38a23afdd2e207bf0734d7f3aa3bb6346d50"
    patch :p1, Formula["z80oolong/vte/sakura@3.8.8"].diff_data
  end

  head do
    url "https://github.com/dabisu/sakura.git"
    patch :p1, Formula["z80oolong/vte/sakura"].diff_data
  end

  keg_only "it conflicts with 'z80oolong/vte/sakura'"

  depends_on "gtk+3"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"
  depends_on "systemd"
  depends_on "gettext"
  depends_on "pod2man" => :build
  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/sakura", "--version"
  end
end
