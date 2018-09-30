# Docker Image with Nginx Auth-PAM and SSSD
A Docker image that configures Nginx auth-pam with the SSSD client.

## Introduction

This Docker image creates a container with Nginx listening on port 80. 
Every path is protected by HTTP basic auth. The authentication succeeds and returns 204 if:

1. Username and password are correct in the SSSD backend.
2. The user belongs to the group that is indicated by the path.

The container must mount */var/lib/sss* from another container for authentication.  
An example of such a container can be found [here](https://github.com/phihos/docker-sssd-krb5-ldap/).

### Example

*User: tom  
Password: secret  
Tom's groups: groupA,groupB*

*If we visit http://\<container-ip>:\<port>/groupA and enter "tom" as user and "secret" and password we get a blank page and 204 as status code.*

*If we visit http://\<container-ip>:\<port>/groupC and enter "tom" as user and "secret" and password we get the default Nginx 403 error page.*

*If we visit http://\<container-ip>:\<port>/groupA and enter "tom" as user and "wrongpasswd" and password we get the default Nginx 403 error page.*

## Running

```
docker run --name nginx-sssd \
            --volumes-from <sssd-container> 
            -p 8080:80 nginx-sssd
```

The SSSD backend container must be launched with ```-v /var/lib/sss```.

## Troubleshooting

Open a shell in the container and run

```
getent passwd <username>
```

with a user that certainly exists in the SSSD backend.  
If no user is returned, the communication with the backend might be broken. 
Make sure that */etc/nssswitch.conf* is not modified and the backend volume is mounted to */var/lib/sss*.

With
```
groups <username>
```
you can check whether the user is actually in that group.

If the log output of Nginx tells you that the PAM script */check_group.sh* failed then either the user actually does not belong to that group
or the group name is not correctly parsed from the URL. Check if the path is URL encoded. SO "#my-group" must be ".../%23my-group".  

Also take a look at */check_group.sh*. It should return exit 0 if the user belongs to the group.
You can add debug logging statements like ```echo "..." > /dev/console``` to the script to get further insight.

To trigger the authentication you can use cURL instead of a browser:

```
curl -su '<user>' http://<container-ip>:<port>/<group>
```
