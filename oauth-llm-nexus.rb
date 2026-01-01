class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "PLACEHOLDER_SHA256_DARWIN_AMD64"

      def install
        bin.install "nexus-darwin-amd64" => "nexus"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "PLACEHOLDER_SHA256_DARWIN_ARM64"

      def install
        bin.install "nexus-darwin-arm64" => "nexus"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-amd64"
      sha256 "PLACEHOLDER_SHA256_LINUX_AMD64"

      def install
        bin.install "nexus-linux-amd64" => "nexus"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "PLACEHOLDER_SHA256_LINUX_ARM64"

      def install
        bin.install "nexus-linux-arm64" => "nexus"
      end
    end
  end

  def caveats
    <<~EOS
      To use oauth-llm-nexus, you need to set up Google OAuth credentials:
        export GOOGLE_CLIENT_ID="your-client-id.apps.googleusercontent.com"
        export GOOGLE_CLIENT_SECRET="your-client-secret"

      Then start the service:
        brew services start oauth-llm-nexus

      Or run manually:
        nexus

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
    environment_variables GOOGLE_CLIENT_ID: "", GOOGLE_CLIENT_SECRET: ""
  end

  def post_install
    (var/"oauth-llm-nexus").mkpath
  end

  test do
    assert_match "OAuth-LLM-Nexus", shell_output("#{bin}/nexus --version 2>&1", 1)
  end
end
