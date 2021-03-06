{ stdenv, fetchFromGitHub, cmake, pkgconfig, python
, zlib, libssh2, openssl, http-parser, curl
, libiconv, Security
}:

stdenv.mkDerivation rec {
  pname = "libgit2";
  version = "0.27.7";
  # keep the version in sync with pythonPackages.pygit2 and libgit2-glib

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    sha256 = "1q3mp7xjpbmdsnk4sdzf2askbb4pgbxcmr1h7y7zk2738dndwkha";
  };

  cmakeFlags = [ "-DTHREADSAFE=ON" ];

  nativeBuildInputs = [ cmake python pkgconfig ];

  buildInputs = [ zlib libssh2 openssl http-parser curl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  propagatedBuildInputs = stdenv.lib.optional (!stdenv.isLinux) libiconv;

  enableParallelBuilding = true;

  doCheck = false; # hangs. or very expensive?

  meta = with stdenv.lib; {
    description = "The Git linkable library";
    homepage = https://libgit2.github.com/;
    license = licenses.gpl2;
    platforms = with platforms; all;
  };
}
