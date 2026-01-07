class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.1.15"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "d98792795b9902eaebcfa0fa848944bf5fdae1a2c5f60100841779f056fc986d"

      def install
        install_binary "nexus-darwin-amd64"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "c12d4f2729839303c341bb07e9026ccda43c7c88b5cdbee46e9c0f145322937f"

      def install
        install_binary "nexus-darwin-arm64"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-amd64"
      sha256 "23fa57ed604fc982f49de6d490007e53e838aeccf90251afdc0007d16c2cde23"

      def install
        install_binary "nexus-linux-amd64"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "62d8cd1fe8c495fa784ce6d6bf913a67e3957bfbef63b3cad91375decb7842a8"

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
