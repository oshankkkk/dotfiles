config.load_autoconfig()

# ============================
# Explanation of config.bind()
# ============================
# Syntax:
# config.bind(key, command, mode=None)

# Arguments:
# - key:     The key or key combo you want to press (e.g., 'gy', 'zs', '<Ctrl-p>')
# - command: The Qutebrowser command or action to perform when that key is pressed
# - mode:    (Optional) The mode where this binding applies: 'normal', 'insert', or 'command'

# ----------------------------
# Open YouTube in a new tab and orther websites
config.bind('gy', 'open -t https://www.youtube.com')
config.bind('gg', 'open -t https://github.com')          # g for go, g for GitHub
config.bind('gi', 'open -t https://www.instagram.com')   # g for go, i for Instagram
config.bind('gc', 'open -t https://chat.openai.com')     # g for go, c for ChatGPT
# Key to open WhatsApp Web
config.bind('aw', 'open https://web.whatsapp.com')

# Example 2: Set a keybinding for insert mode only (pass 'insert' as mode)
# This one simulates pressing Ctrl+u in insert mode

# ----------------------------
# Tip: Use a common prefix like 'z', ';', or ',' for all your custom keys
# to avoid overwriting default bindings and keep things organized.
# dark mode setup
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'
config.set('colors.webpage.darkmode.enabled', False, 'file://*')
# Invert J/K tab navigation
config.unbind('J')
config.unbind('K')
config.bind('J', 'tab-prev')   # J now goes left
config.bind('K', 'tab-next')   # K now goes right








