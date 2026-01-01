# Homebrew Tap for PySugar

This is a Homebrew tap for PySugar projects.

## Installation

```bash
brew tap pysugar/tap
```

## Available Formulae

### oauth-llm-nexus

OAuth proxy for LLM APIs - bridge OpenAI/Anthropic/GenAI to Google Cloud Code.

```bash
brew install pysugar/tap/oauth-llm-nexus
```

**Start as service:**
```bash
brew services start oauth-llm-nexus
```

**Configuration:**
```bash
export GOOGLE_CLIENT_ID="your-client-id"
export GOOGLE_CLIENT_SECRET="your-client-secret"
```

**Dashboard:** http://localhost:8086

For more information, visit [oauth-llm-nexus](https://github.com/pysugar/oauth-llm-nexus).
