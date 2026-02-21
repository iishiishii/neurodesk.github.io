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


You can also self-host a model in Ollama on your computer (recommended Apple Silicon with at least 64GB RAM). For this install Ollama on your system and start the neurodesktop container with these additional docker parameters:
```
--add-host=host.docker.internal:host-gateway \
-e OLLAMA_HOST="http://host.docker.internal:11434" \
```

This model works well:
```bash
ollama pull devstral
```

We need to extend the context window to make it usable for coding:
```bash
echo "FROM devstral:latest
PARAMETER num_ctx 16384" > Modelfile

ollama create devstral-16k -f Modelfile

rm Modelfile
```

Then switch the model to Ollama:
- ctrl+p 
- and select switch model 

you can watch the model working and for errors:
```bash
tail -f ~/.ollama/logs/server.log
```