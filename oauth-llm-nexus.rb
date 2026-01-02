class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.0.3"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "eb26b2cfb70d6baf5ec958ec1bc8a4d22eb3a8b753b8bd0e7f2b744b513a3f30"

      def install
        bin.install "nexus-darwin-amd64" => "nexus"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "3aadae9a5f5bb463cc2281b0787f6ab2a9d0722933aa71d6ecc0c7f1be2b3107"

      def install
        bin.install "nexus-darwin-arm64" => "nexus"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-amd64"
      sha256 "2e0a993d73a19ea7fb7b3638c65574f0f3002bc5015b5204771ae0afb81fd8c9"

      def install
        bin.install "nexus-linux-amd64" => "nexus"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "3160d18c2a0f300ebaf7ca5ffd3a658d21c8ca688394658b2dde3a083a6e05ce"

      def install
        bin.install "nexus-linux-arm64" => "nexus"
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
        PORT    - Server port (default: 8080)
        HOST    - Bind address (default: 127.0.0.1)
                  Set HOST=0.0.0.0 for LAN access

      Example (LAN access):
        HOST=0.0.0.0 PORT=8086 nexus

      Dashboard: http://localhost:8080
      OpenAI API: http://localhost:8080/v1
      Anthropic API: http://localhost:8080/anthropic/v1
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
