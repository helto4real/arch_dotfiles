# System and utility aliases
alias top='bpytop'                 # Enhanced system monitor replacement for top
alias tm='tmux new-session -A -s main'  # Start or attach to a tmux session named 'main'
alias lzg='lazygit'                # Git TUI client
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"  # Modern ls replacement with git integration
alias z="zoxide"

# Editor aliases
alias vi='nvim'                    # Use neovim instead of vi
alias vim='nvim'                   # Use neovim instead of vim 
alias ni='nvim'                    # Short alias for neovim
alias rvim='nssh'                  # Remote vim (presumably via SSH)

# AI chat model aliases
alias oai='aichat -m "openai:gpt-4o-mini"'  # OpenAI GPT-4o-mini chat
alias ai='~/.config/scripts/open_local_ai.sh -m ollama:gpt-oss:latest'  # Local Llama 3.2 model
alias cai='~/.config/scripts/open_local_ai.sh -m ollama:qwen2.5-coder:32b'  # Qwen 2.5 coder model (32B)
alias rai='~/.config/scripts/open_local_ai.sh -m ollama:deepseek-r1:14b'  # DeepSeek R1 model (14B)
