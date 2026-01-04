class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "5d76c258293d1a00a3a149608baa1683c03e7446a3976b98fcdfdb4b20d826e7"

      def install
        libexec.install "nexus-darwin-amd64" => "nexus"
        chmod 0755, libexec/"nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "800a81d4ba177d37237f4ce9a62dfb648bb18626fd76cc31f97710d8589b6e12"

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
      sha256 "e4d507c2949e30e74ea38f8ccde48acdb88064e7f833677ee452de412241b47e"

      def install
        libexec.install "nexus-linux-amd64" => "nexus"
        chmod 0755, libexec/"nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "4e083dfeff3fcd706c3a855d07454cc9298b6afd68b1ea89716c4822bd2be032"

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
