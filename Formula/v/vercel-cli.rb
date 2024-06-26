require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.4.tgz"
  sha256 "195f58dd1327a281fe3cca6f224a0230bad566cede16ed43714e1a78cfb6bca8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "507293118d714783c37690b989902b0502e4941b915db32ff2a77b83b8506e66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "507293118d714783c37690b989902b0502e4941b915db32ff2a77b83b8506e66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "507293118d714783c37690b989902b0502e4941b915db32ff2a77b83b8506e66"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdf194e12174ac89aab9bae02ce790c248cd3570b745ade667162d38ecdb5f48"
    sha256 cellar: :any_skip_relocation, ventura:        "cdf194e12174ac89aab9bae02ce790c248cd3570b745ade667162d38ecdb5f48"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf194e12174ac89aab9bae02ce790c248cd3570b745ade667162d38ecdb5f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d0a648d550cf3498c1c40e4fb86ab74e2035b71a2b1b890ae7295174bf09f76"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
