require 'formula'

class ArmNoneEabiGcc < Formula
  homepage 'https://launchpad.net/gcc-arm-embedded'
  url 'http://gcc.gnu.org/svn/gcc/branches/ARM/embedded-4_7-branch/', :using => :svn, :revision => '194305'
  version '4.7-2012-q4'

  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'
#  depends_on 'ppl'
#  depends_on 'cloog'

  def install
    gmp = Formula.factory 'gmp'
    libmpc = Formula.factory 'libmpc'
    mpfr = Formula.factory 'mpfr'
#    cloog = Formula.factory 'cloog'
#    ppl = Formula.factory 'ppl'

    # brew's build environment is in our way
    ENV.delete 'CFLAGS'
    ENV.delete 'CXXFLAGS'
    ENV.delete 'AS'
    ENV.delete 'LD'
    ENV.delete 'NM'
    ENV.delete 'RANLIB'
    ENV.delete 'CPPFLAGS'
    ENV.delete 'LDFLAGS'
    #ENV.llvm
    unless HOMEBREW_PREFIX.to_s == '/usr/local'
      ENV['CPPFLAGS'] = "-I#{HOMEBREW_PREFIX}/include"
      ENV['LDFLAGS'] = "-L#{HOMEBREW_PREFIX}/lib"
    end

    ENV.prepend 'PATH', bin, ':'

    args = [
            "--target=arm-none-eabi",
            "--enable-languages=c,c++",
            "--disable-decimal-float",
            "--disable-libffi",
            "--disable-libgomp",
            "--disable-libmudflap",
            "--disable-libquadmath",
            "--disable-libssp",
            "--disable-libstdcxx-pch",
            "--disable-lto",
            "--disable-nls",
            "--disable-shared",
            "--disable-threads",
            "--disable-tls",
            "--with-newlib",
            "--enable-interwork",
            "--enable-multilib",
            "--with-python=no",
            # Sandbox everything...
            "--prefix=#{prefix}",
            "--with-gmp=#{gmp.prefix}",
            "--with-mpfr=#{mpfr.prefix}",
            "--with-mpc=#{libmpc.prefix}",
#            "--with-cloog=#{cloog.prefix}",
#           "--with-ppl=#{ppl.prefix}",
#            "--enable-cloog-backend=isl",
            # ...except the stuff in share...
            "--datarootdir=#{share}",
            # ...and the binaries...
            "--bindir=#{bin}"
           ]

    Dir.mkdir 'build'
    Dir.chdir 'build' do
      system '../configure', *args
      system 'make'

      system 'make install'

      multios = `gcc --print-multi-os-dir`.chomp

      # binutils already has a libiberty.a. We remove ours, because
      # otherwise, the symlinking of the keg fails
      File.unlink "#{prefix}/lib/#{multios}/libiberty.a"
    end
  end
end
