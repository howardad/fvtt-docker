pushd portainer > /dev/null

# Get hostname
echo -n "Enter host for portainer (e.g. manage.example.com): "
read host
echo

# Generate docker-compose.yaml
cp ./templates/docker-compose.yaml ./docker-compose.yaml
sed -i "s/<host>/$host/" ./docker-compose.yaml

popd > /dev/null
