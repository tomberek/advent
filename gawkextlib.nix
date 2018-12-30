{ stdenv, fetchgit
, pkgconfig, autoreconfHook
, gawk
, rapidjson
, autoconf
, automake
, gettext
, doCheck ? stdenv.isLinux
, locale ? null
}:

let
  inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = "gawkextlib-unstable";

  src = fetchgit {
    url = "git://git.code.sf.net/p/gawkextlib/code";
    rev = "9a8454c2d10cc97b529620f19cb696d48a6254fe";
    sha256 = "04sp1xdwfi2rjxzm1f1sivm0b6sg7l06wc9q9flixfy5qyc7j82q";
  };

  nativeBuildInputs = [ autoconf automake autoreconfHook pkgconfig gettext rapidjson ];
  buildInputs = [ gawk rapidjson ];

  configurePhase = "";
  postPatch = ''
    cd lib
  '';
  buildPhase = ''
    make

    cd ../json
    autoreconf -i
    ./configure
    make
    cd ..
  '';
  installPhase = ''
    mkdir -p $out/lib
    cp */.libs/* $out/lib
  '';

  inherit doCheck;

  /*
  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/gawk/;
    description = "GNU implementation of the Awk programming language";

    longDescription = ''
      Many computer users need to manipulate text files: extract and then
      operate on data from parts of certain lines while discarding the rest,
      make changes in various text files wherever certain patterns appear,
      and so on.  To write a program to do these things in a language such as
      C or Pascal is a time-consuming inconvenience that may take many lines
      of code.  The job is easy with awk, especially the GNU implementation:
      Gawk.

      The awk utility interprets a special-purpose programming language that
      makes it possible to handle many data-reformatting jobs with just a few
      lines of code.
    '';

    license = licenses.gpl3Plus;

    platforms = platforms.unix;

    maintainers = [ ];
  };
  */
}

