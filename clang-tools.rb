require 'formula'

CLANG_TOOLS_VERSION = '3.4.20140401'
class ClangTools < Formula
  homepage 'http://llvm.org/'
  url 'https://github.com/val00274/llvm/archive/v3.4.20140401.tar.gz'
  sha1 '1b43cc7827b9fa4e017614f2eb17bc35998d461c'
  version CLANG_TOOLS_VERSION

  depends_on 'cmake' => :build

  resource 'clang' do
    url 'https://github.com/val00274/clang/archive/v3.4.20140401.tar.gz'
    sha1 'cb20417c247aed8f2a4636928074cc5b8e14e3da'
  end

  resource 'libcxx' do
    url 'https://github.com/val00274/libcxx/archive/v3.4.20140401.tar.gz'
    sha1 '6ee8cdcd5c08cdf7585ecb8dbe9cd139d423a9ad'
  end

  resource 'clang-tools-extra' do
    url 'https://github.com/val00274/clang-tools-extra/archive/v3.4.20140401.tar.gz'
    sha1 '904a8a75b943ed92a91f7a16af7d247ad2bf19ec'
  end

  skip_clean 'Release'

  def install
    resource('clang').stage do
      (buildpath/'tools/clang').install Dir['*']
    end
    resource('clang-tools-extra').stage do
      (buildpath/'tools/clang/tools/clang-tools-extra').install Dir['*']
    end
    resource('libcxx').stage do
      (buildpath/'projects/libcxx').install Dir['*']
    end

    system "./configure", "--prefix=#{prefix}",
      "--enable-optimized", "--enable-assertions=no", "--enable-targets=host-only"
    system "make install"

    (prefix/'Release').install "Release"

    bin.install prefix/"Release/bin/clang-check",
      prefix/"Release/bin/clang-format",
      prefix/"Release/bin/clang-modernize"
    include.install prefix/"include/c++",
      prefix/"include/llvm",
      prefix/"tools/clang/install/clang-c"
  end
end

