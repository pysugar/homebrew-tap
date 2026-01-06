class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.1.6"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "69a484054dbf10c38e4b15c16b9595be75a02559add2e1963b510790ea7698eb"

      def install
        libexec.install "nexus-darwin-amd64" => "nexus"
        chmod 0755, libexec/"nexus"
        
        # Create a custom wrapper that sources an optional environment file from etc
        (bin/"nexus").write <<~SH
          #!/bin/bash
          ENV_FILE="#{etc}/oauth-llm-nexus.env"
          if [ -f "$ENV_FILE" ]; then
            source "$ENV_FILE"
          fi
          export NEXUS_MODE="release"
          exec "#{libexec}/nexus" "$@"
        SH
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "36368acecd7e4ff624bcd68c65a8dbc6733062bc5b20683c55cd121654c3420c"

      def install
        libexec.install "nexus-darwin-arm64" => "nexus"
        chmod 0755, libexec/"nexus"
        
        # Create a custom wrapper that sources an optional environment file from etc
        (bin/"nexus").write <<~SH
          #!/bin/bash
          ENV_FILE="#{etc}/oauth-llm-nexus.env"
          if [ -f "$ENV_FILE" ]; then
            source "$ENV_FILE"
          fi
          export NEXUS_MODE="release"
          exec "#{libexec}/nexus" "$@"
        SH
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-amd64"
      sha256 "95e6f7f0e25cdb3c6f37715acc1f3f956e52b7c1458123203f91d2bc8732d084"

      def install
        libexec.install "nexus-linux-amd64" => "nexus"
        chmod 0755, libexec/"nexus"
        
        # Create a custom wrapper that sources an optional environment file from etc
        (bin/"nexus").write <<~SH
          #!/bin/bash
          ENV_FILE="#{etc}/oauth-llm-nexus.env"
          if [ -f "$ENV_FILE" ]; then
            source "$ENV_FILE"
          fi
          export NEXUS_MODE="release"
          exec "#{libexec}/nexus" "$@"
        SH
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "008ddc04bfc77d3e0e987b36bf3f36d1d71080f8ebc49a1dbabc354b4fc156da"

      def install
        libexec.install "nexus-linux-arm64" => "nexus"
        chmod 0755, libexec/"nexus"
        
        # Create a custom wrapper that sources an optional environment file from etc
        (bin/"nexus").write <<~SH
          #!/bin/bash
          ENV_FILE="#{etc}/oauth-llm-nexus.env"
          if [ -f "$ENV_FILE" ]; then
            source "$ENV_FILE"
          fi
          export NEXUS_MODE="release"
          exec "#{libexec}/nexus" "$@"
        SH
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
        To customize, add exports to: #{etc}/oauth-llm-nexus.env
        
        PORT                  - Server port (default: 8086 in release mode)
        HOST                  - Bind address (default: 127.0.0.1)
                                Set HOST=0.0.0.0 for LAN access
        NEXUS_VERBOSE         - Enable detailed logging (true/false)
        NEXUS_ADMIN_PASSWORD  - Optional password for Dashboard/API access

      Dashboard: http://localhost:8086
      OpenAI API: http://localhost:8086/v1
      Anthropic API: http://localhost:8086/anthropic/v1
      GenAI API: http://localhost:8086/genai/v1beta
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
