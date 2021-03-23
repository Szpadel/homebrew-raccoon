class UnisonAT2513 < Formula
    desc "File synchronization tool for OSX"
    homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
    license "GPL-3.0-or-later"
    revision 1
    head "https://github.com/bcpierce00/unison.git", branch: "master"

    stable do
      url "https://github.com/bcpierce00/unison/archive/v2.51.3.tar.gz"
      sha256 "0c287d17f52729440b2bdc28edf4d19b2d5ea5869983d78e780d501c5866914b"

    end

    # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
    # release candidates), so we check the Git tags instead.
    livecheck do
      url :stable
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end

    depends_on "ocaml@4.08.1" => :build

    def install
      ENV.deparallelize
      ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
      ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
      system "make", "UISTYLE=text"
      bin.install "src/unison"
      prefix.install_metafiles "src"
    end

    test do
      assert_match version.to_s, shell_output("#{bin}/unison -version")
    end
  end
