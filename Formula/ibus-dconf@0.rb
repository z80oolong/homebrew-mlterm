class IbusDconfAT0 < Formula
  desc "Configuration system for Linux desktop environments"
  homepage "https://wiki.gnome.org/Projects/dconf"
  url "https://download.gnome.org/sources/dconf/0.40/dconf-0.40.0.tar.xz"
  sha256 "cf7f22a4c9200421d8d3325c5c1b8b93a36843650c9f95d6451e20f0bcb24533"

  keg_only :versioned_formula

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "systemd"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libffi"
  depends_on "libxml2"

  def install
    mkdir "build" do
      meson_args = std_meson_args.dup
      meson_args << "-Dbash_completion=false"
      meson_args << "-Dsystemduserunitdir=#{prefix}/lib/systemd/user"
      meson_args << "-Dman=false"
      meson_args << "-Dgtk_doc=false"

      system "meson", *meson_args, ".."
      system "ninja"
      system "ninja", "install", "-v"
    end

    system "mkdir", "-p", "#{prefix}/etc/dconf/db/site.d"
    system "mkdir", "-p", "#{prefix}/etc/dconf/db/distro.d"
    system "touch", "#{prefix}/etc/dconf/db/site"
    system "touch", "#{prefix}/etc/dconf/db/distro"
    system "touch", "#{prefix}/etc/dconf/db/site.d/.empty"
    system "touch", "#{prefix}/etc/dconf/db/distro.d/.empty"
    system "#{bin}/dconf", "update"
  end

  test do
    system "#{bin}/dconf", "--version"
  end
end
