class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.1.9"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "77c45e3f20bd656a7ae2330c4b1fa6ab0bbd6d1cd1a7773c6ccbeb28dc2ab35e"

      def install
        install_binary "nexus-darwin-amd64"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "78da435997bb674af1b03f7bfff9bf518ab5cba937dbcd805c7b5693f2874e99"

      def install
        install_binary "nexus-darwin-arm64"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-amd64"
      sha256 "261d3ae8a5004c5bd0e80bef2337d53d643037dafec658f92b3e20c4a36b5d58"

      def install
        install_binary "nexus-linux-amd64"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "a26ed17e6dea90e3f53c557b8d51523fed8de29bf6c2fd0387c1b93161da397a"

      def install
        install_binary "nexus-linux-arm64"
      end
    end
  end

  # Shared installation logic - reduces code duplication
  def install_binary(binary_name)
    libexec.install binary_name => "nexus"
    chmod 0755, libexec/"nexus"

    # Create wrapper script that sources optional environment file
    (bin/"nexus").write <<~SH
      #!/bin/bash
      ENV_FILE="#{etc}/oauth-llm-nexus.env"
      if [ -f "$ENV_FILE" ]; then
        set +e  # Don't exit on source error
        source "$ENV_FILE"
        set -e
      fi
      export NEXUS_MODE="release"
      exec "#{libexec}/nexus" "$@"
    SH
    chmod 0755, bin/"nexus"
  end

  def caveats
    <<~EOS
      To start oauth-llm-nexus:
        brew services start oauth-llm-nexus

      Or run manually:
        nexus

      Environment Variables:
        Customize by editing: #{etc}/oauth-llm-nexus.env
        
        Example:
          echo 'export NEXUS_VERBOSE="true"' >> #{etc}/oauth-llm-nexus.env
          brew services restart oauth-llm-nexus

        Supported variables:
          PORT                  - Server port (default: 8086)
          HOST                  - Bind address (default: 127.0.0.1)
          NEXUS_VERBOSE         - Enable detailed logging (true/false)
          NEXUS_ADMIN_PASSWORD  - Optional password for Dashboard/API

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

    # Create example env file if it doesn't exist
    env_file = etc/"oauth-llm-nexus.env"
    unless env_file.exist?
      env_file.write <<~ENV
        # OAuth-LLM-Nexus Environment Configuration
        # Uncomment and modify the variables below as needed
        
        # export NEXUS_VERBOSE="true"
        # export PORT="8090"
        # export HOST="0.0.0.0"
        # export NEXUS_ADMIN_PASSWORD="your-password"
      ENV
    end
  end

  test do
    assert_match "OAuth-LLM-Nexus", shell_output("#{bin}/nexus --version 2>&1", 1)
  end
end
