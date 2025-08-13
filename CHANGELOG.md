# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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