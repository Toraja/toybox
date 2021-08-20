# IDE Container

## Things to do on Host machine
- Generate ssh key and put on Github
  `ssh-keygen -t rsa -b 4096 -C '<description>' -f '/home/<user>/.ssh/<key_file_name>'`
- Create ssh config
  ```sshconfig
  Host github.com
      User <github user>
      IdentityFile <path to key file>
  ```
- Clone toybox
	`git clone https://github.com/Toraja/toybox.git ~/toybox`
- Install `make` and run `make` in `../host-setup/`
- Run `cp .env.example .env` and set appropriate values.

### WSL
- Create symlink to windows home `/mnt/c/User/<user>`
- Install X server and set `DISPLAY` environment variable

## Start IDE container
Containers are separated by language.  
Each language requires `base` IDE image be built. Run `make build i=base` to build the
docker image.
Run `make enter <language>` to start and get inside the container.
