{ stdenv, fetchurl, pkgconfig, gtk, gettext, ncurses, libiconv, libintlOrEmpty
, withBuildColors ? true
}:

assert withBuildColors -> ncurses != null;

stdenv.mkDerivation rec {
  name = "girara-${version}";
  version = "0.2.8";

  src = fetchurl {
    url    = "http://pwmt.org/projects/girara/download/${name}.tar.gz";
    sha256 = "18wss3sak3djip090v2vdbvq1mvkwcspfswc87zbvv3magihan98";
  };

  preConfigure = ''
    substituteInPlace colors.mk \
      --replace 'ifdef TPUT_AVAILABLE' 'ifneq ($(TPUT_AVAILABLE), 0)'
  '';

  buildInputs = [ pkgconfig gtk gettext libintlOrEmpty ]
    ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  makeFlags = [
    "PREFIX=$(out)"
    (if withBuildColors
      then "TPUT=${ncurses.out}/bin/tput"
      else "TPUT_AVAILABLE=0")
  ];

  meta = with stdenv.lib; {
    homepage = https://pwmt.org/projects/girara/;
    description = "User interface library";
    longDescription = ''
      girara is a library that implements a GTK+ based VIM-like user interface
      that focuses on simplicity and minimalism.
    '';
    license = licenses.zlib;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.garbas ];
  };
}
