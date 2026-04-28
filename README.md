# MikroTik Automation Suite

This project contains network automation scripts for MikroTik RouterOS.

## Features
- Monthly automated backup of router configuration
- Export of configuration files (.backup and .rsc)
- Email notification system (local SMTP only)
- Automatic cleanup of temporary files

## Automation logic
Backup is executed once per month using MikroTik scheduler.

## Security
- No external cloud dependencies
- No hardcoded credentials in public scripts
- Designed for internal network environments

## Files
- scheduler: monthly backup trigger
- scripts: export and maintenance utilities
