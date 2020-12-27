# Restic Docker

[Restic](https://github.com/restic/restic) in a docker container for timed backups using [tinycron](https://github.com/bcicen/tinycron). 

## Usage

```yml
version: '3'

services:

  # some service that saves data in /var/service/data
  app:
    image: someservice
    volumes:
      - data:/var/service/data

  restic:
    image: janstuemmel/restic 
    restart: always
    volumes:
      # mount .ssh for remote backup
      # - ~/.ssh:/app/.ssh:ro
      - backup:/repo
      - data:/backup/data
    environment:
      CRON: '@daily'
      RESTIC_JSON: 'true'
      RESTIC_HOST: example_host
      RESTIC_TAG: example_tag
      RESTIC_ARGS: --exclude cache
      # using ssh, disable host key verification
      # RESTIC_ARGS: -o sftp.command="ssh -o StrictHostKeyChecking=no"
      RESTIC_FORGET_ARGS: --keep-daily 1
      # default
      RESTIC_REPOSITORY: /repo
      RESTIC_PASSWORD: restic

volumes:
  data:
  backup:
```
