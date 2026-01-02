class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.0.8"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "cead13133065b768a2b31532ff9ccc201dad67f294738340327865f7ff53c2c1"

      def install
        libexec.install "nexus-darwin-amd64" => "nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "5c9a31cf94c4854d1ff52dda782bb6d8fb97addf169ddacea5748d65176c8ec8"

      def install
        libexec.install "nexus-darwin-arm64" => "nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-amd64"
      sha256 "f87accf3b5857dc1c565383e62eb9bb505ab07fa5bd5b2b36adf61d0ae111d4e"

      def install
        libexec.install "nexus-linux-amd64" => "nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "f8cfde2fa0d39357a4a3be500a893708e130017355d519a01cd25105c8f848d4"

      def install
        libexec.install "nexus-linux-arm64" => "nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end
  end

  def caveats
    <<~EOS
      To start oauth-llm-nexus:
        brew services start oauth-llm-nexus

      Or run manually:
        nexus

      Environment Variables:
        PORT    - Server port (default: 8086 in release mode)
        HOST    - Bind address (default: 127.0.0.1)
                  Set HOST=0.0.0.0 for LAN access

      Dashboard: http://localhost:8086
      OpenAI API: http://localhost:8086/v1
      Anthropic API: http://localhost:8086/anthropic/v1
    EOS
  end

  service do
    run [opt_bin/"nexus"]
    working_dir var/"oauth-llm-nexus"
    keep_alive true
    log_path var/"log/oauth-llm-nexus.log"
    error_log_path var/"log/oauth-llm-nexus.log"
  end

  def post_install
    (var/"oauth-llm-nexus").mkpath
  end

  test do
    assert_match "OAuth-LLM-Nexus", shell_output("#{bin}/nexus --version 2>&1", 1)
  end
end
