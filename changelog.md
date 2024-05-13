# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [unreleased] - 2007-08-11
(redacted 2024-05-12: Undo reversions of improved setup and readme.)
### Added
- PrintLit (highlighted text drawing) function for JakDraw help text.

### Changed
- Rename symbols in 256BLOCK and JakDraw.
- Change JakDraw save format from proprietary JAG to reusable QBasic files (BA1, BA2, BA3, BA4).
- Change JakDraw color replace to flood fill (but simple horizontal check algorithm may not fill whole area).
- Improve readability of JakDraw help screen (Use new PrintLit function).

### Fixed
- Enable sound by default.
- Do not try to hide the mouse cursor in JakDraw nor JakSound.
- Use relative paths for install (if using new "Double-click me" install file).


## [unreleased] - 2007-08-09
### Added
- JakSound mouse support.
- use qjak.ini for the PROGDIR.
- particles in SMBreak

### Changed
- Improve QJak icon.
- Improve SMBreak icon.
- Rename QUIET.JAK to BSOUND.DAT for clarity (and use 0 and 1, not 1 and 2).
- Rename CHECK.DID to BLOADING.DAT for clarity.
- Rename variables in JakDraw.
- Rename subroutines and variables in SMBreak.
- Make the readme more suitable for end users (provide instructions for use instead of install).
- Improve SMBreak help screen wording.

### Fixed
- Change version to 2.2 in menu (previous version(s) had 2.2 in readme already).

### Removed
- Install instructions


## [2.2] - 2007-08-03
(redacted 2024-05-12: Redact SMBreak name. Add changelog.)

### Added
- Windows 2000 & XP support
- 256block.ico

### Fixed
- Do not use Z:\TEMP

### Changed
- Change QUIET.TXT to QUIET.JAK to discourage hand editing of the single boolean setting file.
- Make multi-statement lines easier to read and change one to multiple lines.

