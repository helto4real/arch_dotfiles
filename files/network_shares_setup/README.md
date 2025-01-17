# In the /etc/fstab file add the following mount points

```
//IP/config /mnt/homeassistant cifs credentials=/home/[[insert user here]]/.smbcredentials,iocharset=utf8,file_mode=0777,dir_mode=0777 0 0
```
# The .smbcredentials file
Add the following format
```
user=myUser
password=pass
```
secure the credentials
```  
chmod 600 /home/<username>/.smbcredentials
```
