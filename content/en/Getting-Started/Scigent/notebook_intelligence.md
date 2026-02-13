---
title: "Notebook Intelligence"
linkTitle: "NBI"
weight: 4
description: >
  Use the notebook intelligence plugin in Neurodesk - the notebook coding agent
---

Start Notebook Intelligence from the side panel:
![Start Notebook Intelligence](nbi_start.png)

Then connect Github Copilot (or Change the model provider)

Switch to agent, select all tools (via the settings button next to the Agent Selector) and give it a task:
![NBI tools](nbi_tools.png)

You can also ask it to fill in code in specific cells:

For a more capable model you can also switch to Claude in the settings:
![claude](nbi_claude.png)

You can also self-host a model in Ollama on your computer. For this install Ollama on your system and start the neurodesktop container with these additional docker parameters:
```
--add-host=host.docker.internal:host-gateway \
-e OLLAMA_HOST="http://host.docker.internal:11434" \
```

These models work well:
```
ollama pull qwen3-coder-next
ollama pull devstral
```

Then switch to Ollama in the settings
![alt text](image.png)