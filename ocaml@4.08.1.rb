# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Specific packages to pay attention to include:
# - camlp4
# - opam
#
# Applications that really shouldn't break on a compiler update are:
# - coq
# - coccinelle
# - unison
class OcamlAT4081 < Formula
    desc "General purpose programming language in the ML family"
    homepage "https://ocaml.org/"
    url "https://caml.inria.fr/pub/distrib/ocaml-4.08/ocaml-4.08.1.tar.xz"
    sha256 "cd4f180453ffd7cc6028bb18954b3d7c3f715af13157df2f7c68bdfa07655ea3"
    head "https://github.com/ocaml/ocaml.git", :branch => "trunk"

    pour_bottle? do
      # The ocaml compilers embed prefix information in weird ways that the default
      # brew detection doesn't find, and so needs to be explicitly blacklisted.
      reason "The bottle needs to be installed into /usr/local."
      satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
    end

    def install
      ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

      # the ./configure in this package is NOT a GNU autoconf script!
      args = %W[
        --prefix=#{HOMEBREW_PREFIX}
        --enable-debug-runtime
        --mandir=#{man}
        --disable-graph-lib
      ]
      system "./configure", *args
      system "make", "world.opt"
      system "make", "prefix=#{prefix}", "install"
    end

    test do
      output = shell_output("echo 'let x = 1 ;;' | #{bin}/ocaml 2>&1")
      assert_match "val x : int = 1", output
      assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
    end
end
