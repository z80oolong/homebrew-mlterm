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

class LxterminalMltermAT9999Dev < Formula
  desc "Desktop-independent VTE-based terminal emulator"
  homepage "https://wiki.lxde.org/en/LXTerminal"

  @@current_commit = "ac5e36f496b2bf95eae790181e65c9eb54bb9c13"
  url "https://github.com/lxde/lxterminal.git",
    branch:   "master",
    revision: @@current_commit
  version "git-#{@@current_commit[0..7]}"

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "intltool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "perl-xml-parser" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "z80oolong/vte/gtk+3@3.24.43"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.4"

  patch :p1, Formula["z80oolong/vte/lxterminal@9999-dev"].diff_data

  def install
    ENV.replace_rpath "gtk+3" => "z80oolong/vte/gtk+3@3.24.43"
    ENV.prepend_path "PERL5LIB", "#{Formula["perl-xml-parser"].opt_libexec}/lib/perl5"
    ENV["LC_ALL"] = "C"

    inreplace "man/Makefile.am" do |s|
      s.gsub! %r{http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl},
        "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl-ns/manpages/docbook.xsl"
    end

    args  = std_configure_args
    args << "--enable-gtk3"
    args << "--enable-man"

    system "sh", "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      #{full_name} is a Formula for installing the development version of
      `lxterminal` based on the HEAD version (commit #{@@current_commit[0..7]}) from its Github repository.
    EOS
  end

  test do
    system bin/"lxterminal", "--version"
  end
end
