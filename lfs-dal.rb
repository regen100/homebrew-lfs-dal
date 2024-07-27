class LfsDal < Formula
  desc "Custom transfer agent for Git LFS powered by OpenDAL"
  homepage "https://github.com/regen100/lfs-dal"
  url "https://github.com/regen100/lfs-dal/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "0039f12a6d246cc7c805a322bde50dcebdae40debb66a23a5275171246a8b865"
  license "MIT"
  head "https://github.com/regen100/lfs-dal.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "remote"
    chdir "remote" do
      system "git", "init", "--bare"
    end
    mkdir "local"
    cp test_fixtures("test.pdf"), "local"
    chdir "local" do
      system "git", "init", "-b", "main"
      system "git", "lfs", "install", "--local"
      system "git", "lfs", "track", "test.pdf"
      system "git", "config", "lfs.standalonetransferagent", "lfs-dal"
      system "git", "config", "lfs.customtransfer.lfs-dal.path", bin / "lfs-dal"
      system "git", "config", "-f", ".lfsconfig", "lfs.url", "lfs-dal"
      system "git", "config", "-f", ".lfsdalconfig", "lfs-dal.scheme", "memory"
      system "git", "add", "."
      system "git", "-c", "user.name=foobar", "-c", "user.email=foobar@example.com", "commit", "-m", "Initial commit"
      system "git", "remote", "add", "origin", testpath / "remote"
      system "git", "push", "origin", "main"
    end
  end
end
