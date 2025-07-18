# Development Workflow Hooks

A collection of Git hooks and automation scripts designed to streamline the development workflow when working with Claude Code assistant.

## Overview

This repository contains automation hooks that manage the complete development lifecycle:
- **Pre-task preparation**: Branch management and environment setup
- **Post-task cleanup**: Code formatting, staging, and committing
- **PR automation**: Pull request creation with standardized templates
- **Audio notifications**: Sound alerts for task completion

## Components

### Core Scripts

#### `pre-task.sh`
Prepares the development environment before starting a new task:
- Ensures you're on the main branch
- Pulls latest changes from remote
- Creates a timestamped feature branch (`feat/claude-task-YYYYMMDD_HHMMSS`)

#### `post-task.sh`
Handles cleanup and commit automation after task completion:
- Formats code using available formatters
- Stages all changed and new files
- Creates standardized commit messages with Claude attribution
- Ensures nothing is left uncommitted

#### `pr-task.sh`
Automates pull request creation:
- Pushes the current feature branch to remote
- Creates PR using GitHub CLI (`gh`) if available
- Uses standardized PR templates with test checklists
- Provides manual PR creation fallback instructions

#### `sound_notifier.py`
Audio notification system for development sessions:
- Plays completion sounds when tasks finish
- Supports custom sound files
- Cross-platform audio detection and playback
- Generates pleasant two-tone completion chimes
- Graceful fallback when audio is unavailable

### Sound Files

The `sound_files/` directory contains pre-recorded audio notifications:
- `kakko.wav` - Kakko bird sound effect
- `cow.wav` - Cow sound effect
- `horse.wav` - Horse sound effect

## Installation

1. Clone this repository to your development environment
2. Install optional dependencies for enhanced functionality:
   ```bash
   # For GitHub CLI (PR automation)
   sudo apt install gh  # Ubuntu/Debian
   brew install gh      # macOS
   
   # For audio support (Linux)
   sudo apt install pulseaudio-utils alsa-utils
   ```

## Usage

### Manual Execution

```bash
# Start a new development task
./pre-task.sh

# Complete current task (format, commit)
./post-task.sh

# Create pull request
./pr-task.sh

# Test audio notification
python3 sound_notifier.py

# Play custom sound
python3 sound_notifier.py sound_files/cow.wav
```

### Integration with Claude Code

These hooks are designed to work seamlessly with Claude Code assistant workflows. The scripts handle:

1. **Branch Management**: Automatic feature branch creation with timestamps
2. **Code Quality**: Automated formatting and linting
3. **Version Control**: Standardized commit messages with proper attribution
4. **Collaboration**: PR creation with consistent templates
5. **Feedback**: Audio notifications for task completion

### Claude Code Hooks Configuration Example
- Adjust the `command` field to the path of the script you want to run.
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "/home/urakamiy/.claude/hooks/pre-task.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "/home/urakamiy/.claude/hooks/post-task.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "python /home/urakamiy/.claude/hooks/sound_notifier.py /home/urakamiy/.claude/hooks/horse1.wav"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "python /home/urakamiy/.claude/hooks/sound_notifier.py /home/urakamiy/.claude/hooks/cow.wav"
          }
        ]
      }
    ]
  }
}
```

## Configuration

### Git Requirements

- Git repository with `main` branch as default
- Remote origin configured
- GitHub CLI (`gh`) authenticated (optional, for PR automation)

### Audio Configuration

The sound notifier automatically detects available audio systems:
- **Linux**: `paplay`, `aplay`, or `play` commands
- **Cross-platform**: Generates WAV files for maximum compatibility

### Customization

- **Commit Messages**: Edit templates in `post-task.sh`
- **PR Templates**: Modify PR body in `pr-task.sh`
- **Sound Files**: Add custom `.wav` files to `sound_files/`
- **Branch Naming**: Adjust prefix in `pre-task.sh`

## Dependencies

### Required
- Bash shell
- Git
- Python 3.x (for sound notifications)

### Optional
- GitHub CLI (`gh`) - for automated PR creation
- Audio system - for sound notifications
- Code formatters - for automated formatting

## Error Handling

All scripts include robust error handling:
- Git repository validation
- Branch protection (prevents running on `main`)
- Graceful fallbacks for missing dependencies
- Clear error messages and status indicators

## Contributing

When contributing to this hooks system:

1. Test all scripts in isolated Git repositories
2. Ensure cross-platform compatibility
3. Add appropriate error handling
4. Update this README with new features
5. Follow the existing code style and conventions

## License

This project is designed for development workflow automation and is provided as-is for educational and productivity purposes.

## Troubleshooting

### Common Issues

**"Not in a git repository"**
- Ensure you're running scripts from within a Git repository

**"Cannot run post-task hook on main branch"**
- Switch to a feature branch before running post-task operations

**"gh CLI not available"**
- Install GitHub CLI or create PRs manually using the provided URL

**"Audio playback failed"**
- Install audio utilities or run without sound notifications

### Getting Help

- Check script output for detailed error messages
- Ensure all dependencies are installed
- Verify Git configuration is correct
- Test individual components separately
