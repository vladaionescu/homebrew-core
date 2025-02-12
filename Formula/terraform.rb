class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.3.3.tar.gz"
  sha256 "2a093e13eb9c9b27f35af8ef84f51c9f7e76f8caa1672810997b442571aeda9d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9f8b44a882c5a9d698dda57f35679042ba2198811f9fa6746da21be1376f9c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c4c5b2c630df08447abb02ce336af83e2619eeb5c0d07cdaa6041cddca945a1"
    sha256 cellar: :any_skip_relocation, monterey:       "3e74560bd9c9d98e6a688a886b9de4c345888eb301c058acb5d43ada4b9be329"
    sha256 cellar: :any_skip_relocation, big_sur:        "4da1a5a4ed7ceef385202aedde19c472d08cdb549263181d2c59b80a963d08e1"
    sha256 cellar: :any_skip_relocation, catalina:       "e6d9e632ec6b95bfb50207d19c15eb6b0d17737010602fa09914ed6744cf257e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5885fb5f77dd0869812fef4132c41dcde6225c84a590a9c32a5e8eafb3ab5e9"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    # v0.6.12 - source contains tests which fail if these environment variables are set locally.
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"

    # resolves issues fetching providers while on a VPN that uses /etc/resolv.conf
    # https://github.com/hashicorp/terraform/issues/26532#issuecomment-720570774
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~EOS
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    EOS
    system "#{bin}/terraform", "init"
    system "#{bin}/terraform", "graph"
  end
end
