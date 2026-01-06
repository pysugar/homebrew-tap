class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.1.5.1"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "510ddcc4e2a848805962addc1b68d213546d1fe85e6819048160a4fbba4f50c5"

      def install
        libexec.install "nexus-darwin-amd64" => "nexus"
        chmod 0755, libexec/"nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "f8bf0e372b67d34d9f1c9f2719e2f40af6389df300dcb1f2d39f013b1f2e7d65"

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
      sha256 "d1c33ae88e300cf25f751596d426bc250076b3f7a2bef6024b07ef7cf5d5c757"

      def install
        libexec.install "nexus-linux-amd64" => "nexus"
        chmod 0755, libexec/"nexus"
        (bin/"nexus").write_env_script libexec/"nexus", NEXUS_MODE: "release"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "fac4b31e9cb666c8325b61db8f5c43c2d13d49aa422ccddaa03c0f4a55c73022"

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
