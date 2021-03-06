require 'formula'

class Ghc <Formula
  url 'http://haskell.org/ghc/dist/6.10.4/maeder/ghc-6.10.4-i386-apple-darwin.tar.bz2'
  version '6.10.4'
  homepage 'http://haskell.org'
  md5 '1541f55e000f97076b2509a5445b915f'

  skip_clean "lib"
  skip_clean "bin"
  
  def install
    system "./configure --prefix=#{prefix}"
    system "make install"

    # need to update ghc-6.10.4 because on 10.5 gcc defaults to x64
    system "perl -pi.bak -e 's/wrapped/wrapped -optc-m32 -opta-m32 -optl-m32/g' #{bin}/ghc-6.10.4"
    system "perl -pi.bak -e 's/\hsc2hs $tflag/hsc2hs --cflag=\"-m32\" --lflag=\"-m32\" \$tflag/g' #{bin}/hsc2hs"
  end 
end
