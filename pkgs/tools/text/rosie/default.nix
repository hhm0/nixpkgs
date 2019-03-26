{ stdenv, lib, fetchgit, readline, libbsd }:

stdenv.mkDerivation rec {
  pname = "rosie";
  version = "v1.1.0";

  src = fetchgit {
    url = "https://gitlab.com/rosie-pattern-language/rosie";
    rev = "e2013782ef158a1ce345ce244d9350ff2d90d651";
    sha256 = "00hn41jkxymcii9lgn28lm7vh6p4psqz7ana02rdnh49218akksv";
    fetchSubmodules = true;
  };

  buildInputs = [ readline ] ++ lib.optionals stdenv.isLinux [ libbsd ];

  patches = [ ./rosie_makefile.patch ];

  postPatch = "patchShebangs .";

  outputs = [ "out" "doc" ];

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    mkdir -v -p "$out/share"
    mkdir -v -p "$out/share/emacs"
    mv -v "$out/lib/rosie/extra/extra/vim" "$out/share/vim-plugins"
    mv -v "$out/lib/rosie/extra/extra/emacs" "$out/share/emacs/site-lisp"
    mkdir -p "$doc/share/rosie"
    mv -v "$out/lib/rosie/"{CHANGELOG,CONTRIBUTORS,README} "$doc/share/rosie/"
    mv -v "$out/lib/rosie/doc/doc" "$doc/share/rosie/doc"
    rmdir -v "$out/lib/rosie/doc"
    mv -v "$out/lib/rosie/extra/extra/examples" "$doc/share/rosie/examples"
    mv -v "$out/include" "$doc/share/rosie/librosie.h"
    rm -v "$out/lib/rosie/"{build.log,LICENSE,VERSION}
    rm -vr "$out/lib/rosie/extra/extra/" # NOTE: new useful things may be added here, so check occasionally
    rmdir -v "$out/lib/rosie/extra"
  '';

  meta = with stdenv.lib; {
    description = "Rosie Pattern Language (RPL)";
    homepage = "https://rosie-lang.org/";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.hhm ];
  };
}
