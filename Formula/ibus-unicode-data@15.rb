class IbusUnicodeDataAT15 < Formula
  desc "Unicode data for Ibus/MLTerm"
  homepage "https://www.unicode.org/Public/UNIDATA/"
  url "https://gitlab.gnome.org/ebassi/unicode-data.git",
      :revision => "b4519a4f690b5c57e4a902438c8a990a2f222cf9"
  version "15.0"
  license "MIT"

  resource("unicode-emoji") do
    url "https://github.com/samhocevar/unicode-emoji.git",
    :revision => "963e436f8ab08184c36c25032aec22a8eb85e05a"
  end

  resource("emoji-annotation") do
    url "https://github.com/fujiwarat/cldr-emoji-annotation/releases/download/38-alpha1.0_13.0_0_1/cldr-emoji-annotation-38-alpha1.0_13.0_0_1.tar.gz"
    sha256 "c1310d7e3232202007ae43c41695b27ff21ed60d5cf3c3a7293408da6f02c3cf"
  end

  keg_only :versioned_formula

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    resource("unicode-emoji").stage do    
      (share/"unicode/emoji").install "emoji-data.txt"
      (share/"unicode/emoji").install "emoji-sequences.txt"
      (share/"unicode/emoji").install "emoji-test.txt"
      (share/"unicode/emoji").install "emoji-variation-sequences.txt"
      (share/"unicode/emoji").install "emoji-zwj-sequences.txt"
    end

    resource("emoji-annotation").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--sysconfdir=#{etc}"
      system "make"
      system "make", "install"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "false"
  end
end
