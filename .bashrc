#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ============================================================================
# ALIASES
# ============================================================================
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias chromium-wayland='chromium --ozone-platform=wayland --enable-features=VaapiVideoDecoder'
alias rwaybar='pkill waybar && waybar& disown'

# ============================================================================
# PROMPT
# ============================================================================
# quesadx@quesadx-hypr | /path
# $
PS1='\[\e[1;37m\]\u@\h\[\e[0m\] \[\e[1;36m\]|\[\e[0m\] \[\e[1;37m\]\w\[\e[0m\]\n\[\e[1;36m\]$\[\e[0m\] '

# ============================================================================
# STARTUP
# ============================================================================
#fastfetch
#echo

# ============================================================================
# GIT SHORTCUTS
# ============================================================================
alias gadd='git add .'
alias gst='git status'
alias gco='git checkout'
alias gpl='git pull'
alias gph='git push'
