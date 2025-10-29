# Claude Code API Switcher

A bash script to quickly switch between different API configurations for Claude Code. This allows you to toggle between using Anthropic's official API and custom API endpoints (like alternative providers or local models).

## Why This Exists

Claude Code's `/model` command only changes the UI display, but the actual API routing is controlled by environment variables in `~/.claude/settings.json`. This script provides a simple way to switch between different API configurations without manually editing configuration files.

## Features

- Switch between Anthropic login and custom API configurations
- Load API keys from environment files
- Backup your current settings automatically
- Show current configuration status
- Template generation for custom API setups

## Installation

### Option 1: Local Installation

1. Clone the repository:
```bash
git clone https://github.com/mkw2000/claude-code-api-switcher.git
cd claude-code-api-switcher
```

2. Make the script executable:
```bash
chmod +x claude-switch.sh
```

3. Run it directly:
```bash
./claude-switch.sh status
```

### Option 2: System-wide Installation

1. Copy the script to your local bin directory:
```bash
mkdir -p ~/.local/bin
cp claude-switch.sh ~/.local/bin/claude-switch
chmod +x ~/.local/bin/claude-switch
```

2. Add to your PATH (if not already there):
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

3. Now you can run it from anywhere:
```bash
claude-switch status
```

## Usage

### Basic Commands

```bash
# Show current configuration
claude-switch status

# Switch to custom API configuration
claude-switch use-custom

# Switch back to Anthropic login
claude-switch use-anthropic

# Show help
claude-switch help
```

### Setting Up Custom API Configuration

1. Create a `.env` file in your home directory with your API key:
```bash
# ~/.env
YOUR_API_KEY=your-actual-api-key-here
```

2. Run the custom command to generate the template:
```bash
claude-switch use-custom
```

3. Edit the generated configuration file:
```bash
# ~/.claude/settings.custom.json
{
  "env": {
    "ANTHROPIC_MODEL": "your-model-name",
    "ANTHROPIC_BASE_URL": "https://api.example.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "your-actual-api-key"
  },
  "alwaysThinkingEnabled": true
}
```

## Configuration Files

The script manages several configuration files:

- `~/.claude/settings.json` - Active Claude Code configuration
- `~/.claude/settings.custom.json` - Custom API configuration template
- `~/.claude/settings.anthropic.json` - Anthropic login configuration

Your original settings are backed up automatically the first time you run the script.

## Examples

### Using an Alternative API Provider

```bash
# Create ~/.env with your API key
echo "OPENAI_API_KEY=sk-your-key-here" >> ~/.env

# Switch to custom configuration
claude-switch use-custom

# Edit the generated settings to point to your provider
# ~/.claude/settings.custom.json
{
  "env": {
    "ANTHROPIC_MODEL": "gpt-4",
    "ANTHROPIC_BASE_URL": "https://api.openai.com/v1",
    "ANTHROPIC_AUTH_TOKEN": "sk-your-key-here"
  },
  "alwaysThinkingEnabled": true
}
```

### Switching Between Configurations

```bash
# Check current setup
claude-switch status
# Output: Currently using: Anthropic login (default)

# Switch to custom API
claude-switch use-custom
# Output: Now using custom API settings

# Verify the change
claude-switch status
# Output: Currently using: Custom API configuration
```

## Troubleshooting

### Common Issues

1. **Command not found**: Make sure `~/.local/bin` is in your PATH
2. **Permission denied**: Run `chmod +x claude-switch.sh`
3. **API not working**: Check that your `~/.claude/settings.custom.json` has the correct API endpoint and key

### Resetting Configuration

If you want to start over:

```bash
# Remove generated files
rm ~/.claude/settings.custom.json
rm ~/.claude/settings.anthropic.json

# Restore from backup (if available)
cp ~/.claude/settings.backup.json ~/.claude/settings.json
```

## Security Notes

- The script reads API keys from `~/.env` - make sure this file has appropriate permissions (`chmod 600 ~/.env`)
- Configuration files contain sensitive API keys - don't commit them to version control
- The script only reads from `~/.env` and never modifies it

## Contributing

Feel free to submit issues and pull requests. When contributing, please:

1. Test changes on your own Claude Code installation first
2. Update documentation for any new features
3. Ensure no personal information or API keys are included in the code

## License

MIT License - see LICENSE file for details.