# Setup the AI features

This instructions of how to setup AI locally with Ollama.

```bash
yay -S ollama
```

Then run the open web ui to chat etc. Use `-d` option to run in the background

```sh
docker run -d  -p 3000:8080 --gpus=all -e OLLAMA_BASE_URL=http://localhost:11434 -e WEBUI_AUTH=False -v ~/.ollama:/root//.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama
```
