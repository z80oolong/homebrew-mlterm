class FcitxGconfAT3 < Formula
  desc "GNOME configuration database system"
  homepage "https://projects.gnome.org/gconf/"
  url "https://download.gnome.org/sources/GConf/3.2/GConf-3.2.6.tar.xz"
  sha256 "1912b91803ab09a5eed34d364bf09fe3a2a9c96751fde03a4e0cfa51a04d784c"

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtk+3"
  depends_on "dbus"
  depends_on "dbus-glib"
  depends_on "gettext"
  depends_on "glib"
  depends_on "intltool"
  depends_on "pcre"

  def install
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{prefix}/etc",
                          "--enable-gtk",
                          "--disable-orbit",
                          "--disable-documentation",
                          "--disable-gtk-doc",
                          "--disable-gtk-doc-html",
                          "--disable-gtk-doc-pdf"
    system "make", "install"
  end

  test do
    assert_equal "#{share}/gconf/schemas", shell_output("#{bin}/gconftool-2 --get-default-source-path").chomp
  end
end
