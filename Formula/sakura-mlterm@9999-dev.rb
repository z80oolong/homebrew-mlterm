def ENV.replace_rpath(**replace_list)
  replace_list = replace_list.each_with_object({}) do |(old, new), result|
    old_f = Formula[old]
    new_f = Formula[new]
    result[old_f.opt_lib.to_s] = new_f.opt_lib.to_s
    result[old_f.lib.to_s] = new_f.lib.to_s
  end

  if (rpaths = fetch("HOMEBREW_RPATH_PATHS", false))
    self["HOMEBREW_RPATH_PATHS"] = (rpaths.split(":").map do |rpath|
      replace_list.fetch(rpath, rpath)
    end).join(":")
  end
end

class SakuraMltermAT9999Dev < Formula
  desc "GTK/VTE based terminal emulator"
  homepage "https://launchpad.net/sakura"
  license "GPL-2.0"

  @@current_commit = "46f4582a7b9b2e4eb892909b3e29e5067fcbb2f7"
  url "https://github.com/dabisu/sakura.git",
    branch:   "master",
    revision: @@current_commit
  version "git-#{@@current_commit[0..7]}"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pod2man" => :build
  depends_on "gettext"
  depends_on "systemd"
  depends_on "z80oolong/vte/gtk+3@3.24.43"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.4"

  patch :p1, Formula["z80oolong/vte/sakura@9999-dev"].diff_data

  def install
    ENV.replace_rpath "gtk+3" => "z80oolong/vte/gtk+3@3.24.43"

    args  = std_cmake_args
    args << "CMAKE_BUILD_TYPE=Debug"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      #{full_name} is a Formula for installing the development version of
      `sakura` based on the HEAD version (commit #{@@current_commit[0..7]}) from its Github repository.
    EOS
  end

  test do
    system bin/"sakura", "--version"
  end
end
