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

<!--  -->

# Setting Up

Article: https://devsday.ru/blog/details/62100

-> SSH to VPS
-> Install `git`
-> Go to GitHub and generate a token to be able to fetch
-> Clone the client repo by:

```bash
git clone https://github.com/alexandebryakin/weuse_proxy_gateway.git
# git clone https://github.com/alexandebryakin/polza.git
```

-> Change directory:

```bash
cd weuse_proxy_gateway
git clone https://github.com/alexandebryakin/polza.git

cd polza
```

-> Copy ENV file into `polza`

---

NOTE: ENV file should be updated before build

```bash
# OR it's done by the `deploy.production.sh`?
docker build -t weuse-production -f ./docker/Dockerfile.production .
```

---

# Front-End CI: https://devsday.ru/blog/details/62100

```bash
# -> use ssh-actions or whatever
./weuse_proxy_gateway/weuse-client/deploy.production.sh
```
