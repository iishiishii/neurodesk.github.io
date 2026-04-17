---
title: "Opencode"
linkTitle: "Opencode"
weight: 1
description: >
  Use OpenCode in Neurodesk - the open source coding agent
---

start OpenCode on a terminal with `opencode`. Our Opencode wrapper script will walk you through setting it up depending on which models are available to you.

You can also configure your own model provider:

- ctrl+p
- and select switch model
- then ctrl+a to connect a different provider

## Self-host a model in Ollama

You can also self-host a model in Ollama on your computer (recommended hardware: Apple Silicon with at least 64GB RAM). For this install Ollama on your system and start the neurodesktop container with these additional docker parameters (the neurodesk app does this automatically):

```bash
--add-host=host.docker.internal:host-gateway \
-e OLLAMA_HOST="http://host.docker.internal:11434" \
```

One example model:

```bash
ollama pull devstral
```

We need to extend the context window to make it usable for coding:

```bash
echo "FROM devstral:latest
PARAMETER num_ctx 32768" > Modelfile

ollama create devstral-32k -f Modelfile

rm Modelfile
```

Then switch the model to Ollama:

- ctrl+p
- and select switch model

you can watch the model working and for errors:

```bash
tail -f ~/.ollama/logs/server.log
```

## Use of models provided through llm.neurodesk.org

create an API key at <https://llm.neurodesk.org> and add it to your opencode config file `.config/opencode/opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "neurodesk/kimi-k2.5",
  "provider": {
    "neurodesk": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Neurodesk LiteLLM",
      "options": {
        "baseURL": "https://llm.neurodesk.org/openai",
        "apiKey": "YOUR_LLM.NEURODESK.ORG_API_KEY"
      },
      "models": {
        "gpt-oss": { "name": "gpt-oss", "limit": { "context": 131000, "output": 8192 } },
        "gemma": { "name": "gemma" },
        "kimi": { "name": "kimi" },
        "minimax-m2": { "name": "minimax-m2" },
        "gemma-4-e4b": { "name": "gemma-4-e4b" },
        "glm-4.7": { "name": "glm-4.7" },
        "qwen3": { "name": "qwen3" },
        "qwen3-small": { "name": "qwen3-small" },
        "qwen3-27b": { "name": "qwen3-27b" },
        "deepseek-v3.2": { "name": "deepseek-v3.2" },
        "gpt-oss-120b": { "name": "gpt-oss-120b" },
        "kimi-k2.5": { "name": "kimi-k2.5" },
        "llama-4-scout": { "name": "llama-4-scout" },
        "DeepSeek-R1": { "name": "DeepSeek-R1" }
      }
    },
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama Local",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "devstral-32k": {
          "name": "Devstral"
        },
        "qwen3-16k": {
          "name": "Qwen3"
        }
      }
    }
  }
}
```
