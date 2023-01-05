# Setting up

## Clone the repo to the VPS

```bash
git clone ...
```

## Enter the directory:

```bash
cd weuse_proxy_gateway
```

## Make the `deploy.production.sh` executable by running:

```bash
chmod +x deploy.production.sh
```

## Run the file for the first time:

```bash
./deploy.production.sh
```

# Setting Up

Article: https://devsday.ru/blog/details/62100

→ SSH to VPS
→ Install `git`
→ Go to GitHub and generate a token to be able to fetch
→ Clone the client repo by:

```bash
git clone https://github.com/alexandebryakin/weuse_proxy_gateway.git
# git clone https://github.com/alexandebryakin/polza.git
```

→ Change directory:

```bash
cd "$HOME/weuse_proxy_gateway/weuse-client"
git clone https://github.com/alexandebryakin/polza.git
```

→ Copy ENV file into `polza`

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
```

---

# Other approach https://articles.wesionary.team/deploying-react-app-to-vps-server-with-nginx-with-ssl-b5d7dedc784f

## SSH to the server and:

```bash
rm -rf "$HOME/weuse_proxy_gateway/weuse-client/polza/build"
mkdir "$HOME/weuse_proxy_gateway/weuse-client/polza/build"
```

## Go to the local machine and:

→ Build React App:

```bash
yarn prod:build
```

→ Perform a secure copy to the VPS

```bash
scp -r ./build/* root@45.130.42.14:/root/weuse_proxy_gateway/weuse-client/polza/build/
```

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



docker-compose -f "$HOME/weuse_proxy_gateway/polza_api/docker-compose.yml" \
               -f "$HOME/weuse_proxy_gateway/polza_api/docker/production/docker-compose.yml" \
               build
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

# Useful commands

## Empty the trash

```bash
# [INSTALL `trash-cli` if not yet installed]:
# sudo apt install trash-cli

trash-empty
```
