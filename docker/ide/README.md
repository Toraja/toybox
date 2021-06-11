# IDE Container

## Things to do on Host machine
### Docker related
- Install `docker`
- Install `pip` and `docker-compose`
- Add `~/.local/bin` to  `$PATH` in `.bashrc`.  
  That is where `pip` installs `docker-compose`.
  ```sh
  if [[ ! ${PATH} =~ "${HOME}/.local/bin" ]]; then
    export PATH=${PATH}:${HOME}/.local/bin
  fi
  ```
- Add user to docker group  
  `sudo usermod -aG docker <user>`
- Generate ssh key and put on Github
  `ssh-keygen -t rsa -b 4096 -C '<description>' -f '/home/<user>/.ssh/<key_file_name>'`
- Create ssh config
  ```sshconfig
  Host github.com
      User <github user>
      IdentityFile <path to key file>
  ```
- Run `mkdir ~/workspace`
- Change docker's detach key (refer to `general.md`)
- Run `cp .env.example .env` and set appropriate values.

### Misc
- Create symlink to windows home `/mnt/c/User/<user>`
- Set up X window
