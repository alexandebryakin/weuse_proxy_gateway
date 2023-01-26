# Setting up

## Clone current repo to the VPS

```bash
git clone ...
```

## Enter the directory:

```bash
cd weuse_proxy_gateway
```

<!-- ## Make the `deploy.production.sh` executable by running:

```bash
chmod +x deploy.production.sh
```

## Run the file for the first time:

```bash
./deploy.production.sh
``` -->

# Setting Up

Article: https://devsday.ru/blog/details/62100

→ SSH to VPS
→ Install `git`
→ Go to GitHub and generate a token to be able to fetch
→ Clone the client repo by:

```bash
git clone https://github.com/alexandebryakin/weuse_proxy_gateway.git
```

→ Change directory:

```bash
cd "$HOME/weuse_proxy_gateway/weuse-client"
git clone https://github.com/alexandebryakin/polza.git
```

# The commented approach below doesn't suit for the VPS since it consumes all the resources and breaks.

<!-- → Copy ENV file into `polza`

```bash
cd polza
touch .env
nano .env
```

→ make sure the changes are saved into `.env` file

```bash
cat .env
```

---

NOTE: ENV file should be updated before build

```bash
# OR it's done by the `deploy.production.sh`?
docker build -t weuse-production -f ./docker/Dockerfile.production2 .
```

---

# Front-End CI: https://devsday.ru/blog/details/62100

```bash
# → use ssh-actions or whatever
cd
chmod +x $HOME/weuse_proxy_gateway/weuse-client/deploy.production.sh
$HOME/weuse_proxy_gateway/weuse-client/deploy.production.sh
``` -->

---

# Other approach to 'deploy' FE to prod https://articles.wesionary.team/deploying-react-app-to-vps-server-with-nginx-with-ssl-b5d7dedc784f

## SSH to the server and:

```bash
rm -rf "$HOME/weuse_proxy_gateway/weuse-client/polza/build"
mkdir "$HOME/weuse_proxy_gateway/weuse-client/polza/build"
```

## Go to the local machine and:

→ Change/Create a `.production.env` and specify all the variables

→ Build React App:

```bash
yarn prod:build
```

→ Perform a secure copy to the VPS

```bash
scp -r ./build/* root@45.130.42.14:/root/weuse_proxy_gateway/weuse-client/polza/build/
```

→ ssh to VPS

```bash
cd "$HOME/weuse_proxy_gateway/weuse-client/polza"
docker build -t weuse-production -f ./docker/Dockerfile.production2 .
```

NOTE:
`Dockerfile.production` performs build (expensive to do it on VPS with current setup)
`Dockerfile.production2` is an nginx that statically serves the pre-built `/build` folder

# `API`

## Initial API Setup

→ SSH to VPS via:

```bash
ssh root@45.130.42.14
```

→ Clone a repo:

```bash
cd "$HOME/weuse_proxy_gateway/"

git clone https://github.com/alexandebryakin/polza_api.git
```

→ Go to local machine and copy the `.production.env` file via:

```bash
scp .production.env root@45.130.42.14:/root/weuse_proxy_gateway/polza_api/
```

`--OR--` simply COPY & PASTE with `nano`:

```bash
cd "$HOME/weuse_proxy_gateway/polza_api/"
touch '.production.env'
nano '.production.env'
# ... COPY & PASTE the variables
```

→ Build Docker Compose:

```bash
cd "$HOME/weuse_proxy_gateway/"
docker-compose -f "$HOME/weuse_proxy_gateway/polza_api/docker-compose.yml" \
               -f "$HOME/weuse_proxy_gateway/polza_api/docker/production/docker-compose.yml" \
               build
```

```bash
docker-compose -f "$HOME/weuse_proxy_gateway/polza_api/docker-compose.yml" \
               -f "$HOME/weuse_proxy_gateway/polza_api/docker/production/docker-compose.yml" \
               up
```

```bash
# [DOESN'T WORK]
# docker-compose -f "$HOME/weuse_proxy_gateway/docker-compose.yml" \
#                -f "$HOME/weuse_proxy_gateway/polza_api/docker-compose.yml" \
#                -f "$HOME/weuse_proxy_gateway/polza_api/docker/production/docker-compose.yml" \
#                up
```

→ CORS for the backend:
within the `/weuse_proxy_gateway` directory make sure there is a `/vhost/default_location` file with the following content:

```bash
if ($http_origin ~* (.*\\.weuse\\.ru)) {
    add_header 'Access-Control-Allow-Origin' "$http_origin" always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, DELETE, PATCH, PUT';
    add_header 'Access-Control-Allow-Credentials' 'true' always;
    add_header 'Access-Control-Allow-Headers' 'Keep-Alive,Content-Type,Authorization';
    add_header 'Access-Control-Expose-Headers' 'Authorization';
}
if ($request_method = OPTIONS) {
    add_header 'Access-Control-Allow-Origin' "$http_origin";
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, DELETE, PATCH, PUT';
    add_header 'Access-Control-Allow-Credentials' 'true';
    add_header 'Access-Control-Allow-Headers' 'Keep-Alive,Content-Type,Authorization';
    add_header 'Access-Control-Expose-Headers' 'Authorization';
    return 204;
}

```

# File Structure Notes

```bash
/
|--vhost
|  |--default # is probably generated by letsencrypt
|  |--default_location # used for CORs
```

# IMPORTANT!!! an Article on how to setup nginx-proxy properly

→ !!! Each app should always run on port 80 for nginx-proxy to work
For example:
weuse client: nginx on port 80
weuse api: rails on port 80 (NOT a 3000)

→ !!! add CORs rules to default_location

# =========================================== Useful commands ===========================================

## Empty the trash

```bash
# [INSTALL `trash-cli` if not yet installed]:
# sudo apt install trash-cli

trash-empty
```

## Enter a container:

```bash
# sudo docker exec -it <container-name> /bin/bash
  sudo docker exec -it nginx-proxy /bin/bash
  sudo docker exec -it weuse-api-production /bin/bash
```

## Check the network of a container:

```bash
docker inspect --format='{{.NetworkSettings.Networks}}' <container-name>

docker inspect --format='{{.NetworkSettings.Networks}}' \
  weuse-api-production \
  nginx-proxy \
  weuse-api-postgres \
  weuse-api-redis \
  weuse-production

docker network ls -f driver=bridge --format "{{.ID}}" | xargs docker network inspect | grep Name
```

```bash
curl -X POST localhost:80/graphql_schema
```

## List occupied ports:

```bash
# https://www.cyberciti.biz/faq/unix-linux-check-if-port-is-in-use-command/
sudo lsof -i -P -n | grep LISTEN
```

```js
r = await fetch("https://api.weuse.ru/graphql_schema", { method: "POST" });
```
