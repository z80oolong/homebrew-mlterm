class MltermIbusAT15 < Formula
  include Language::Python::Virtualenv

  desc "Ibus Kana-Kanji conversion engine"
  homepage "https://github.com/ibus/ibus"
  url "https://github.com/ibus/ibus/releases/download/1.5.28/ibus-1.5.28.tar.gz"
  sha256 "6c9ff3a7576c3d61264f386030f47ee467eb7298c8104367002986e008765667"
  license ""

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtk+3"
  depends_on "gtk-doc"
  depends_on "z80oolong/mlterm/ibus-dconf@0"
  depends_on "libnotify"
  depends_on "z80oolong/mlterm/ibus-unicode-data@15"
  depends_on "gettext"
  depends_on "glib"
  depends_on "intltool"
  depends_on "libxml2"
  depends_on "python@3.11"

  def install
    venv = virtualenv_create(libexec, "python3")
    unicode_share = Formula["z80oolong/mlterm/ibus-unicode-data@15"].opt_share
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-python=python3",
                          "--with-python_prefix=#{libexec}",
                          "--with-unicode-emoji-dir=#{unicode_share}/unicode/emoji",
                          "--with-emoji-annotation-dir=#{unicode_share}/unicode/cldr/common/annotations",
                          "--with-ucd-dir=#{unicode_share}/unicode-data"
    system "make", "install"
  end

  test do
    system "ibus-daemon", "--check"
  end
end
