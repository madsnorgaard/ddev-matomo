![project is maintained](https://img.shields.io/maintenance/yes/2025.svg)

# ddev-matomo <!-- omit in toc -->


## What is ddev-matomo?

ddev-matomo provides an integration with [Matomo](https://matomo.org/) - the leading open-source analytics platform that gives you more than powerful analytics. This add-on makes it easy to run Matomo alongside your DDEV project with proper database isolation and version flexibility.

## Features

- ✅ **Separate database** for Matomo (prevents conflicts with your application database)
- ✅ **Version flexibility** - Choose between Matomo 4.x or 5.x
- ✅ **Easy configuration** via environment variables
- ✅ **Automatic HTTPS** with DDEV's router
- ✅ **Persistent data** across project restarts
- ✅ **Git-friendly** - Runtime files automatically ignored, safe for team development

## Getting started

### Quick Install

```bash
ddev add-on get madsnorgaard/ddev-matomo
ddev restart
```

### Step-by-Step Installation

1. **Install the add-on**
   ```bash
   ddev add-on get madsnorgaard/ddev-matomo
   ```

2. **Configure your Matomo version** (optional - defaults to Matomo 5)
   Create or edit `.ddev/config.matomo.yaml`:
   ```yaml
   # For Matomo 5 (latest):
   MATOMO_VERSION: "5"
   
   # For Matomo 4 (LTS):
   # MATOMO_VERSION: "4"
   ```

3. **Configure database settings** (optional - defaults are safe)
   The add-on creates a separate database named `matomo` by default. To customize:
   ```yaml
   # In .ddev/config.matomo.yaml
   MATOMO_DATABASE_DBNAME: "matomo"  # Change if needed
   ```

4. **Restart DDEV**
   ```bash
   ddev restart
   ```

5. **Complete Matomo setup**
   - Visit https://matomo.\<projectname\>.ddev.site
   - Follow the installation wizard
   - Database settings (use these during setup):
     - Database Server: `db`
     - Database Name: `matomo` (or your custom name)
     - Username: `db`
     - Password: `db`
     - Table Prefix: `matomo_` (recommended)

## Database Configuration

### ⚠️ Important: Database Isolation

This add-on creates a **separate database** for Matomo to prevent any conflicts with your application database (Drupal, WordPress, etc.). 

**Default behavior:**
- Matomo uses its own database named `matomo`
- Your application database remains untouched
- Both databases run in the same MariaDB/MySQL container

**Custom database name:**
If you need a different database name, create `.ddev/config.matomo.yaml`:
```yaml
MATOMO_DATABASE_DBNAME: "analytics"  # or any name you prefer
```

### Creating the Database

The database is automatically created during installation. If you need to recreate it:
```bash
# Create empty Matomo database
echo "CREATE DATABASE IF NOT EXISTS matomo;" | ddev mysql

# Or if using custom database name:
echo "CREATE DATABASE IF NOT EXISTS your_custom_db;" | ddev mysql
```

### Importing Existing Matomo Data

If you have an existing Matomo installation:
```bash
# Import to Matomo database (not your main database!)
ddev import-db --database=matomo --file=matomo-backup.sql
```

## Matomo Version Selection

### Supported Versions

| Matomo Version | Support Status | Use Case |
|---------------|----------------|----------|
| **5.x** (default) | Latest features | Recommended for new installations |
| **4.x** | LTS until Nov 2025 | For compatibility with older plugins |

### How to Change Versions

Edit `.ddev/config.matomo.yaml`:
```yaml
# For specific versions:
MATOMO_VERSION: "5.1.2"  # Specific version
MATOMO_VERSION: "5"      # Latest 5.x
MATOMO_VERSION: "4"      # Latest 4.x
```

Then restart:
```bash
ddev restart
```

## Advanced Configuration

### Environment Variables

All configuration is done via `.ddev/config.matomo.yaml`:

```yaml
# Matomo version
MATOMO_VERSION: "5"

# Database configuration
MATOMO_DATABASE_DBNAME: "matomo"

# PHP settings (optional)
MATOMO_PHP_MEMORY_LIMIT: "256M"
MATOMO_PHP_MAX_EXECUTION_TIME: "300"

# Matomo settings (optional)
MATOMO_GENERAL_ENABLE_TRUSTED_HOST_CHECK: "0"
MATOMO_GENERAL_ASSUME_SECURE_PROTOCOL: "1"
```

### Multi-site Setup

For tracking multiple sites in one Matomo instance:
1. Complete the initial Matomo setup
2. Log into Matomo admin
3. Go to Administration → Websites → Add a new website
4. Configure each site with its tracking code

### Git Integration

The add-on automatically handles git integration for team development:

**What gets committed:**
- Directory structure (via `.gitkeep` files)
- Configuration files (like `config.matomo.yaml`)
- The docker-compose configuration

**What gets ignored:**
- Matomo runtime files (config.ini.php, cache, logs)
- User data and plugins
- Temporary files
- GeoIP databases

**Team Development:**
```bash
# New team member setup - just install and restart
ddev add-on get madsnorgaard/ddev-matomo
ddev restart

# Matomo will recreate all runtime files automatically
```

The `.ddev/.gitignore` file is automatically created/updated during installation.

## Troubleshooting

### Common Issues

#### Database Connection Error
**Problem:** "Error while trying to connect to the database"

**Solution:** Ensure the database exists:
```bash
echo "CREATE DATABASE IF NOT EXISTS matomo;" | ddev mysql
ddev restart
```

#### Matomo Already Installed Error
**Problem:** Matomo says it's already installed but you can't access it

**Solution:** Clear Matomo's config:
```bash
ddev exec -s matomo rm -f /var/www/html/config/config.ini.php
ddev restart
```

#### Wrong Database Used
**Problem:** Matomo tables appearing in your application database

**Solution:** 
1. Check your database configuration in `.ddev/config.matomo.yaml`
2. Ensure you're using `matomo` (or your custom name) as the database during Matomo setup
3. Never use your application's database name for Matomo

#### Permission Issues
**Problem:** "Matomo couldn't write to some directories"

**Solution:**
```bash
ddev exec -s matomo chown -R www-data:www-data /var/www/html
ddev restart
```

### Getting Help

- 🐛 **Report issues:** [GitHub Issues](https://github.com/madsnorgaard/ddev-matomo/issues)
- 💡 **Request features:** [GitHub Discussions](https://github.com/madsnorgaard/ddev-matomo/discussions)
- 📖 **Matomo docs:** [matomo.org/docs](https://matomo.org/docs/)
- 🔧 **DDEV docs:** [ddev.readthedocs.io](https://ddev.readthedocs.io/)

## Maintainer

This is a community-maintained fork of the original ddev-matomo add-on. The original was created by [valthebald](https://github.com/valthebald/ddev-matomo) but is no longer actively maintained.

### About this fork

This fork aims to:
- ✅ Keep the add-on updated with latest Matomo and DDEV versions
- ✅ Provide clear database isolation to prevent data loss
- ✅ Support both Matomo 4.x (LTS) and 5.x versions
- ✅ Improve documentation for the community
- ✅ Fix known issues and compatibility problems

### Contributing

We welcome contributions from the community! Here's how you can help:

1. **Report bugs:** Open an issue with reproduction steps
2. **Suggest features:** Start a discussion or open an issue
3. **Submit PRs:** Fork, make changes, and submit a pull request
4. **Improve docs:** Documentation improvements are always welcome
5. **Test:** Help test new releases and report feedback

### License

MIT License - See [LICENSE](LICENSE) file for details
