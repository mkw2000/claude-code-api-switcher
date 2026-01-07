#!/bin/bash

# Claude Code API Switcher
# Switch between different API configurations for Claude Code
# Usage: ./claude-switch [command]

CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
CUSTOM_FILE="$CLAUDE_DIR/settings.custom.json"
ANTHROPIC_FILE="$CLAUDE_DIR/settings.anthropic.json"

load_env() {
    if [[ -f "$HOME/.env" ]]; then
        export $(grep -v '^#' "$HOME/.env" | xargs)
    else
        echo "Warning: ~/.env file not found"
    fi
}

create_custom_settings() {
    load_env
    cat > "$CUSTOM_FILE" << EOF
{
  "env": {
    "ANTHROPIC_MODEL": "CUSTOM_MODEL_NAME",
    "ANTHROPIC_BASE_URL": "https://api.example.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "\${YOUR_API_KEY:-your-api-key-here}"
  },
  "alwaysThinkingEnabled": true
}
EOF
}

create_anthropic_settings() {
    cat > "$ANTHROPIC_FILE" << 'EOF'
{}
EOF
}

init_files() {
    if [[ ! -f "$CUSTOM_FILE" ]]; then
        echo "Creating custom API settings template..."
        create_custom_settings
        echo "Custom settings template created. Edit $CUSTOM_FILE with your API configuration."
    fi

    if [[ ! -f "$ANTHROPIC_FILE" ]]; then
        echo "Creating Anthropic login settings file..."
        create_anthropic_settings
    fi
}

use_custom() {
    echo "Switching to custom API configuration..."
    cp "$CUSTOM_FILE" "$SETTINGS_FILE"
    echo "Now using custom API settings"
}

use_anthropic() {
    echo "Switching to Anthropic login..."
    cp "$ANTHROPIC_FILE" "$SETTINGS_FILE"
    echo "Now using Anthropic login (default settings)"
}

show_status() {
    if [[ -f "$SETTINGS_FILE" ]]; then
        if grep -q "ANTHROPIC_AUTH_TOKEN" "$SETTINGS_FILE" 2>/dev/null; then
            echo "Currently using: Custom API configuration"
        else
            echo "Currently using: Anthropic login (default)"
        fi
    else
        echo "No Claude settings file found"
    fi
}

case "${1:-status}" in
    "custom"|"api"|"use-custom"|"glm")
        init_files
        use_custom
        ;;
    "anthropic"|"login"|"use-anthropic"|"default")
        init_files
        use_anthropic
        ;;
    "status"|"--status"|"-s")
        show_status
        ;;
    "help"|"--help"|"-h")
        echo "Claude Code API Switcher"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  custom, api, use-custom    Switch to custom API configuration"
        echo "  anthropic, login, use-anthropic  Switch to Anthropic login"
        echo "  status, --status          Show current configuration"
        echo "  help, --help              Show this help"
        echo ""
        echo "Environment Variables:"
        echo "  The script loads API keys from ~/.env file"
        echo "  Edit settings.custom.json to configure your API endpoints"
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac
