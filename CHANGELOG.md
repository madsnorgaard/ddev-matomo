# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-04-27

### Added
- `tests/test.bats` integration test covering install, restart, container health, database isolation, and removal
- `.github/workflows/tests.yml` CI running `ddev/github-action-add-on-test@v2` on pushes, PRs, and a daily schedule against both `stable` and `HEAD` DDEV
- `ddev_version_constraint: '>= v1.24.10'` in `install.yaml` so older DDEV versions fail fast with a clear message
- README badge for the tests workflow

### Changed
- Healthcheck endpoint switched from `/matomo.php` (returns 400 before setup) to `/index.php` (returns 200 once Apache is ready) so a fresh install no longer reports unhealthy
- README rewritten to reflect Matomo 4.x EOL since 2024-12-19; pin guidance now uses 5.9.0 as the example
- MariaDB compatibility note added for users overriding DDEV's defaults (avoid 11.5.x)

### Removed
- Matomo 4.x as an offered option in `configure-matomo.sh` — 4.x is end-of-life and shouldn't be promoted to new users
- Stale `.gitignore.matomo` and `.gitkeep.matomo` files (the equivalent gitignore is generated inline by `pre_install_actions`)

## [1.1.3] - 2025-08-13

### Fixed
- Removed remaining interactive prompts from the install flow so `ddev add-on get` runs cleanly in CI and non-interactive shells
- Version configuration moved entirely to the post-install `configure-matomo.sh` script

## [1.1.2] - 2025-08-13

### Fixed
- Removed the plugins volume mount that triggered Matomo's file integrity check failure on first boot

## [1.1.1] - 2025-01-13

### Fixed
- **CRITICAL**: Fixed "File integrity check failed" errors during Matomo setup
- Removed unnecessary plugins and tmp volume mounts that were overriding Matomo's built-in files
- Simplified directory structure - only config and misc directories are now mounted
- Updated troubleshooting documentation with file integrity error solutions

### Removed
- Volume mounts for plugins and tmp directories (not needed and caused issues)

## [1.1.0] - 2025-01-13

### Fixed
- **CRITICAL**: Fixed environment variable loading issues with DDEV
- Removed dependency on external config files that DDEV doesn't load automatically
- Now uses proper DDEV docker-compose environment variable patterns

### Added
- Interactive installation with version selection prompts
- `configure-matomo.sh` script for easy post-install configuration
- Comprehensive git integration with automatic .gitignore setup
- Clear documentation for all configuration methods

### Changed
- Simplified configuration approach using direct docker-compose editing
- Updated documentation to reflect proper DDEV practices
- Enhanced installation messages with better guidance

### Removed
- `config.matomo.yaml` approach (didn't work with DDEV's environment system)

## [1.0.0] - 2025-01-13

### Added
- Initial release of the community-maintained fork
- Support for both Matomo 4.x (LTS) and 5.x versions via configuration
- Comprehensive documentation for database isolation
- `config.matomo.yaml` for easy user customization
- Environment variable support for all Matomo settings
- Automatic database creation during installation
- Health check for Matomo container
- Persistent storage for plugins and temporary files
- Troubleshooting guide with common issues and solutions
- Clear warnings about database separation to prevent data loss

### Changed
- Updated docker-compose.matomo.yaml with version flexibility
- Improved README with step-by-step installation guide
- Enhanced database configuration with clear isolation from application database
- Better default settings for PHP and Matomo configuration
- Added table prefix by default (`matomo_`) for additional safety

### Fixed
- Database overwrite issues from the original add-on
- Missing volume mounts for plugins directory
- PHP memory and execution time limitations

### Security
- Enforced HTTPS by default with `MATOMO_GENERAL_ASSUME_SECURE_PROTOCOL`
- Disabled trusted host check for easier local development

## Previous History

This is a fork of the original [valthebald/ddev-matomo](https://github.com/valthebald/ddev-matomo) add-on, which was created by valthebald but is no longer actively maintained. This fork aims to keep the add-on updated and improve the user experience for the DDEV community.