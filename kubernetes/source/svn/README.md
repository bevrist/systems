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
> edit `~/.ssh/config`:
```
Host svn.brettevrist.net
  Port 2500
  User bevrist
```
use this to checkout repo:
`svn co svn+ssh://svn.brettevrist.net/svn/SampleProject dirname-optional`


connect with GUI client:
`svn+ssh://svn.brettevrist.net:2500/svn/SampleProject`
