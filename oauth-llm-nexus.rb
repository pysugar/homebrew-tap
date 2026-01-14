class OauthLlmNexus < Formula
  desc "OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code"
  homepage "https://github.com/pysugar/oauth-llm-nexus"
  version "0.1.30"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-amd64"
      sha256 "728cdf89104eab51db6a7d154f7035f7e306405a02c34e52a9f700af80296996"

      def install
        install_binary "nexus-darwin-amd64"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-darwin-arm64"
      sha256 "1f335e611582a70eeb1fa100831bf0b8683391b5e1f7d3e95f1eb72e061a6ca4"

      def install
        install_binary "nexus-darwin-arm64"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-amd64"
      sha256 "0d01d47a642a338241dd56d4389fe35faf5e50f8dbb25d4f86faaaeba7b33aab"

      def install
        install_binary "nexus-linux-amd64"
      end
    end

    on_arm do
      url "https://github.com/pysugar/oauth-llm-nexus/releases/download/v#{version}/nexus-linux-arm64"
      sha256 "c7d128dac3acbd8ccb3612bac3613fad133af4cee188c433a0a581918b060c93"

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

      ⚠️  DISCLAIMER & LICENSE:
        This software is provided for EDUCATIONAL and RESEARCH purposes only under the
        Sustainable Use License.
        - STRICTLY PROHIBITED for commercial use.
        - STRICTLY PROHIBITED to violate Google's Terms of Service.
        - Users assume all risks associated with internal API usage.

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
