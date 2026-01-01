class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.0.1"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "9aaaf371c61415742cf2066376ddef8eeaf4e187f3290984984b73d9a51de19c"

      def install
        bin.install "nexus-darwin-amd64" => "nexus"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "182d89333896405ba60d7a9403ce0c051bc232af9442eed14d813532a780d045"

      def install
        bin.install "nexus-darwin-arm64" => "nexus"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-amd64"
      sha256 "e0229a6b60a289f4dc6d052c772e1fc8f8fd99dd88e2228430191255ab2281d2"

      def install
        bin.install "nexus-linux-amd64" => "nexus"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "83bfa7bf7b8ed2dc6c6f9c7e4a15e8c08b5fc4c14a592116b4be4a447edf2d9b"

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
