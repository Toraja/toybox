# IDE Container

## Things to do on Host machine
### Docker related
- Install `docker`
- Install `pip` and `docker-compose`
- Add below `.bashrc`.  
  ```sh
  # docker-compose is installed here
  if [[ ! ${PATH} =~ "${HOME}/.local/bin" ]]; then
    export PATH=${PATH}:${HOME}/.local/bin
  fi
  # disable Ctrl-s and Ctrl-q keybind
  stty -ixon
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
- Install X server and set `DISPLAY` environment variable
