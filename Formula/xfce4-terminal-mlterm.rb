class Xfce4TerminalMlterm < Formula
  desc "Mirror repository, PRs are not watched, please use Xfce's GitLab"
  homepage "https://gitlab.xfce.org/apps/xfce4-terminal"
  url "https://github.com/xfce-mirror/xfce4-terminal/archive/refs/tags/xfce4-terminal-1.1.5.tar.gz"
  sha256 "cd916c31a31f1f07c062e70c8f0f5f00de0863f0a21594640668b648cc7db98e"
  license "GPL-2.0"
  head "https://github.com/xfce-mirror/xfce4-terminal.git"

  keg_only "this formula conflicts with 'z80oolong/vte/xfce4-terminal'"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "gtk-doc"
  depends_on "intltool"
  depends_on "z80oolong/dep/xfce4-desktop@4.19.6"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.4"

  def install
    ENV["LC_ALL"] = "C"
    system "./autogen.sh"

    inreplace "./configure" do |s|
      s.gsub!("MAINTAINER_MODE_TRUE='#'", "MAINTAINER_MODE_TRUE=")
      s.gsub!("MAINTAINER_MODE_FALSE=", "MAINTAINER_MODE_FALSE='#'")
    end

    system "./configure", "--disable-silent-rules", "--bindir=#{libexec}/bin", *std_configure_args
    system "make"
    system "make", "install"

    ohai "Create #{bin}/xfce4-terminal script."
    (bin/"xfce4-terminal").write(wrapper_script)
    (bin/"xfce4-terminal").chmod(0755)
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
  end

  def gschema_dirs
    dirs = [share/"glib-2.0/schemas"]
    dirs << (HOMEBREW_PREFIX/"share/glib-2.0/schemas")
    dirs << "${GSETTINGS_SCHEMA_DIR}"
    dirs
  end
  private :gschema_dirs

  def xdg_data_dirs
    dirs = [share]
    dirs << (HOMEBREW_PREFIX/"share")
    dirs << "/usr/local/share"
    dirs << "/usr/share"
    dirs << "${XDG_DATA_DIRS}"
    dirs
  end
  private :xdg_data_dirs

  def wrapper_script
    <<~EOS
      #!/bin/sh
      export GSETTINGS_SCHEMA_DIR="#{gschema_dirs.join(":")}"
      export XDG_DATA_DIRS="#{xdg_data_dirs.join(":")}"
      #{Formula["z80oolong/dep/xfce4-desktop@4.19.6"].opt_lib}/xfce4/xfconf/xfconfd 2>&1 &
      exec #{libexec}/bin/xfce4-terminal $@
    EOS
  end
  private :wrapper_script

  test do
    assert_match version.to_s, shell_output("#{bin}/xfce4-terminal --version")
  end
end
