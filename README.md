Vagrant LibreNMS
================


Basic provision of [LibreNMS](https://github.com/librenms/librenms) inside a scientific linux (6) VM, using nginx

| Username | Password | URL |
| --- | --- | --- |
| `admin` | `admin` | http://librenms.local |

## Requirements
- **Vagrant** - Portable development environment manager

## Installation

```bash
$ git clone git@github.com:jacobgardiner/vagrant-librenms.git
$ cd vagrant-librenms
$ vagrant up
```

## Contributing

```
# when starting a new feature or bugfix
# make sure you are on master and it is up to date
$ git checkout master
$ git pull

# create a new branch off master with a meaningful name
$ git checkout -b <new-branch-name>

# commit to this branch with commit messages
$ git commit -m 'fixed all the things'

# push to github
$ git push
```

Then create a pull request
