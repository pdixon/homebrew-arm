require 'formula'

class ArmNoneEabiGcc < Formula
  homepage 'http://gcc.gnu.org'
  url 'http://ftp.gnu.org/gnu/gcc/gcc-4.7.2/gcc-4.7.2.tar.bz2'
  md5 'cc308a0891e778cfda7a151ab8a6e762'

  depends_on 'arm-none-eabi-binutils'
  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'

  def install
    gmp = Formula.factory 'gmp'
    libmpc = Formula.factory 'libmpc'
    mpfr = Formula.factory 'mpfr'

    ENV.llvm

    args = [
            "--target=arm-none-eabi",
            "--enable-languages=c",
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
      man7.rmtree
    end
  end
end
