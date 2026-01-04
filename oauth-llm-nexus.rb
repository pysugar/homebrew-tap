class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.1.3"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "56edfc364da47cee8c0957735bb62087857bd5eb3f069bbceffa5b6cc2c5adcc"

      def install
        libexec.install "nexus-darwin-amd64" => "nexus"
        chmod 0755, libexec/"nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "26adc29cba9fac477f25056ad48b7a8d4c6295dc15cb7fd3e6ee6c4e5a654dbc"

      def install
        libexec.install "nexus-darwin-arm64" => "nexus"
        chmod 0755, libexec/"nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-amd64"
      sha256 "5099ef4503aed0f2dfea5d6c44c3eacfb01e5d4e01c970e325bed0257d8dca3e"

      def install
        libexec.install "nexus-linux-amd64" => "nexus"
        chmod 0755, libexec/"nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "5a61d942c4cd875354cdf2ecef9940c4fc3843bffd6e3e5271c4b6240c20c0fd"

      def install
        libexec.install "nexus-linux-arm64" => "nexus"
        chmod 0755, libexec/"nexus"
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
        PORT                  - Server port (default: 8086 in release mode)
        HOST                  - Bind address (default: 127.0.0.1)
                                Set HOST=0.0.0.0 for LAN access
        NEXUS_ADMIN_PASSWORD  - Optional password for Dashboard/API access

      Dashboard: http://localhost:8086
      OpenAI API: http://localhost:8086/v1
      Anthropic API: http://localhost:8086/anthropic/v1
      GenAI API: http://localhost:8086/genai
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
