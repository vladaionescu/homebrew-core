  url "https://www.vtk.org/files/release/9.2/VTK-9.2.2.tar.gz"
  sha256 "1c5b0a2be71fac96ff4831af69e350f7a0ea3168981f790c000709dcf9121075"
    sha256 cellar: :any,                 arm64_monterey: "fd8b5266a33f0cf2d967df1ef522ed2c56aec78ce371669496343c98ed1f65f0"
    sha256 cellar: :any,                 arm64_big_sur:  "ce4d4f25b956014b0b45a96da8361ae053931ae9548b7da83056c9d27c5f7669"
    sha256 cellar: :any,                 monterey:       "8183b6b8fc6b8df5639e47027f62cab729aa7ff79e2aac19d2b15ccd44e8ec68"
    sha256 cellar: :any,                 big_sur:        "b447d02c13ee4127382316c24e10d2551c5e2faa6234db005c73c5342477b66e"
    sha256 cellar: :any,                 catalina:       "e370593ac5ec40f462bd8212db0cd940b5add11061aba88fe82f65d79f58027c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aa435ad572edb96b633065c2174b319c44c0f3d145f0b707d2d4847c9816db9"
    ENV.llvm_clang if DevelopmentTools.clang_build_version == 1316 && Hardware::CPU.arm?