dotfiles
===

# Configuration

`config.yml` stores the configuration. It can differentiate between folders and files.


# Dependencies

`rsync` is used to copy instead of `cp`, due to convenient way to copy folders. 

# Running

`saviour` is a python script which reads `config.yml` and backups or restores based on the argument provided.

```bash
./savior -o backup # Backup files
./savior -o restore # Restore files. *untested*
```

