# ===============================
# Powerlevel10k Config
# ===============================
# Nerd Font must be installed and set in Kitty
# font_family FiraCode Nerd Font

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir vcs)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)

# User prompt segment
typeset -g POWERLEVEL9K_USER_ICON='\uF415 ' # 

# Directory segment
typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=true
typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=33

# Git (vcs) segment
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uE0A0 ' # 
typeset -g POWERLEVEL9K_VCS_STATUS_COLORS=(added green modified yellow deleted red untracked blue)

# Status (exit code)
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=2
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=1

# Time
typeset -g POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S}"

# Command execution time > 2s
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=3

# Prompt style
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%F{243}┌─%f'
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{243}└─>%f '

# Colors
typeset -g POWERLEVEL9K_DIR_FOREGROUND=33
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=2
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=3
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=9
