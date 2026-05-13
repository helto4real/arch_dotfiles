# Create a local systemd user service

- Add the comfyui.service file to `~/.config/systemd/user/`


# manage the serice with systemctl --user commands:
```
Ladda om: 
```
systemctl --user daemon-reload
```

Starta: systemctl --user start comfyui

Aktivera (starta vid inloggning): systemctl --user enable comfyui

Status: systemctl --user status comfyui

Loggar: journalctl --user -u comfyui -f
```

# Alias
# ComfyUI Systemd Alias
alias -start='systemctl --user start comfyui'
alias cui-stop='systemctl --user stop comfyui'
alias cui-restart='systemctl --user restart comfyui'
alias cui-status='systemctl --user status comfyui'
alias cui-logs='journalctl --user -u comfyui -f -n 100'
