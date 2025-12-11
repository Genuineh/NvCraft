# NvCraft Agent Instructions

This document provides specific instructions for AI agents working on the NvCraft repository.

## Dependency Management

### Missing Lua 5.1 Interpreter

If you detect that the required Lua 5.1 interpreter is not installed on the system, your primary responsibility is to inform the user and provide them with clear, platform-specific installation instructions.

**Do not attempt to install `lua5.1` yourself.**

Your response should follow this pattern:
1.  Acknowledge that Lua 5.1 is a required dependency and appears to be missing.
2.  Provide example installation commands for common package managers (e.g., `apt`, `brew`, `pacman`).
3.  Clearly state that the user needs to perform this installation before you can proceed with the task.
