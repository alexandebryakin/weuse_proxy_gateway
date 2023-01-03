echo "weuse-client: Deploying changes..."

# Pull changes from the main branch
# cd ./polza
cd "$HOME/weuse_proxy_gateway/weuse-client/polza"
git pull

# TODO: we need to remove this folder before each manual `scp ...`
# rm -rf ./build

# Build the image with the new changes
docker build -t weuse-production -f ./docker/Dockerfile.production .

cd $HOME/weuse_proxy_gateway

# Shut down the existing containers
docker-compose down

# Start the new containers
docker-compose up -d

echo "Deployed!"
