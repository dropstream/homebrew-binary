class Eventstore < Formula
  desc "functional database with complex event processing"
  homepage "http://geteventstore.com"
  url "http://download.geteventstore.com/binaries/EventStore-OSS-MacOSX-v3.5.0.tar.gz"
  sha256 "504d48376cd4ba3949d85d0a75d2875ea51b6ef6b7f6c1c64cc6e6a38839aec5"

  bottle :unneeded

  depends_on :macos => :mavericks

  def install
    prefix.install Dir["*"]

    (bin/"eventstore").write <<-EOS.undent
      #!/bin/sh
      cd "#{prefix}"
      exec "#{prefix}/clusternode" "$@"
    EOS

    (bin/"eventstore-testclient").write <<-EOS.undent
      #!/bin/sh
      exec "#{prefix}/testclient" "$@"
    EOS
  end

  test do
    system "#{bin}/eventstore", "--version"
    system "#{bin}/eventstore --mem-db & sleep 3; pid=$!; #{bin}/eventstore-testclient --command wrfl; #{bin}/eventstore-testclient --command rdfl; kill $pid"
  end
end
