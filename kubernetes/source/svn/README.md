# Subversion SSH Image
build/push: `docker build -t 192.168.86.7:5000/svn-image . && docker push 192.168.86.7:5000/svn-image`

## After creation
Create Repository:
```
svnadmin create /svn/SampleProject
chown -R bevrist:svn-writers /svn/SampleProject
chmod -R ug+w /svn/SampleProject
```

## Connect
connect with CLI client:
> edit `~/.subversion/config`:
```
[tunnels]
# ssh = $SVN_SSH ssh -q --
ssh2500 = $SVN_SSH ssh -p 2500 -q --
```
use this to checkout repo:
`svn co svn+ssh2500://bevrist@<IP>/svn/SampleProject dirname-optional`


connect with GUI client:
`svn+ssh://<IP>:2500/svn/SampleProject`
