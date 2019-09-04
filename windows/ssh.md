## SSH
### Trouble shooting
<dl>
  <dt>Symptom</dt>
  <dd>Error: <code>unable to start ssh-agent service, error :1058</code></dd>
  <dt>Solution</dt>
  <dd>Run: <code>Set-Service ssh-agent -StartupType Manual</code></dd>
  <dd>Optionally start the service</dd>
</dl>
<dl>
  <dt>Symptom</dt>
  <dd><code>Bad owner or permissions on <u>ssh config file</u></code></dd>
  <dt>Solution</dt>
  <dd>
    <a href="https://superuser.com/questions/1296024/windows-ssh-permissions-for-private-key-are-too-open#1296046">
    How to change permission on windows</a>
  </dd>
</dl>

<dl>
  <dt>Symptom</dt>
  <dd><code>warning: agent returned different signature type ssh-rsa (expected rsa-sha2-512)</code></dd>
  <dt>Solution</dt>
  <dd>Update ssh (>7.9: get new version <a href="https://github.com/PowerShell/Win32-OpenSSH/releases">here</a>)</dd>
<dl>


