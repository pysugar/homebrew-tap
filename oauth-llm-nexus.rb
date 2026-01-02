class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.1.1"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "d863e35b5cdb89b2c88fd075128a367fc39029a4798f2eda0ad392bd6068f646"

      def install
        libexec.install "nexus-darwin-amd64" => "nexus"
        chmod 0755, libexec/"nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "fe6c393f40269552b150068685539533c023741eed0203ebea72772dcc26391c"

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
      sha256 "634b08f2a04c846ff5db8abf55b616e40a0a9a9e2cec954c8bf370f82dfcd8d9"

      def install
        libexec.install "nexus-linux-amd64" => "nexus"
        chmod 0755, libexec/"nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "bf35187240adeb5de34a8f3c631b413ab85991272b0d1b815b8c9ee2572ddc62"

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
