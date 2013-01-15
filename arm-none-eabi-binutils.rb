require 'formula'

class ArmNoneEabiBinutils < Formula
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.23.1.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  sha1 '587fca86f6c85949576f4536a90a3c76ffc1a3e1'

  def install

    ENV['CPPFLAGS'] = "-I#{include}"

    args = ["--prefix=#{prefix}",
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--disable-nls"]

    ENV.delete 'CFLAGS'
    ENV.delete 'CXXFLAGS'
    ENV.delete 'LD'
    ENV.delete 'CC'
    ENV.delete 'CXX'

    if MacOS.version == :lion
      ENV['CC'] = ENV.cc
    end

    system "./configure", "--target=arm-none-eabi", *args
    system "make"
    system "make install"

    multios = `gcc --print-multi-os-dir`.chomp

    # binutils already has a libiberty.a. We remove ours, because
    # otherwise, the symlinking of the keg fails
    File.unlink "#{prefix}/lib/#{multios}/libiberty.a"

  end

end
