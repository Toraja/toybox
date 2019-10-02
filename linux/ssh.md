## SSH

### Connect without storing finger print  
`ssh -o StrictHostKeyChecking=no`

### Connect without password prompt
1. Create a pair of RSA keys on the local machine. (`ssh-keygen`)
1. Store the private key in somewhere secure on the local machine.
1. Add the content of the public key to the file `~/.ssh/authorized_key` of the user
   on the remote machine you want to connect to,
   or simply issue `ssh-copy-id <user>@<host>` command.
1. Add the code below to bashrc etc. of the local machine  
   `eval $(keychain --agents ssh --eval <path-to-key>)`  
   where *pass-to-key* is the absolute path or the relative path from `~/.ssh` to the private key on
   the local machine.  
1. SSH to the server.

If keychain output warning message like below, update keychain as it is old and does not support
OpenSSH 6.8+ format.  
`Can't determine fingerprint from the following line, falling back to filename`
