{ stdenv, autoreconfHook, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cddisasm";
  name = "${pname}-${version}";
  version = "0.1";

  src = fetchurl {
    url = "http://www.penguin.cz/~utx/ftp/${pname}/${name}.tar.gz";
    sha256 = "12x27ifpby4ikvh5xdbfid6ff7halb9yl16cnbzl03jmpni2ril5";
  };

  postInstall = ''
    install -D -m 644 README "$out"/share/doc/${pname}/README
  '';

  meta = with stdenv.lib; {
    homepage = http://www.penguin.cz/~utx/cddisasm;
    description = "A simple utility for decoding subchannel data from a CD image";
    longDescription = ''
      This is simple utility for decoding subchannel data from CD image.

      It works only with P-W RAW mode data, as specified in MMC standard.

      It does not yet understand lead-in and lead-out data.

      Usage:
      cdrdao read-cd --read-raw --read-subchan rw_raw cd.toc
      cddisasm
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ hhm ];
    platforms = platforms.unix;
  };
}
