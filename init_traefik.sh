pushd traefik > /dev/null

# Generate password for traefik
echo -n "Enter username: "
read username
echo -n "Enter password: "
read -s password
traefik_pwd=$(htpasswd -nb $username $password)
echo

# Get SSL email
echo -n "Enter email for Let's Encrypt SSL certs: "
read email

# Get hostname
echo -n "Enter host for traefik (e.g. monitor.example.com): "
read host
echo

# Generate traefik.yml
cp ./templates/traefik.yml ./traefik.yml
sed -i "s/<email>/$email/" ./traefik.yml

# Generate dynamic_conf.yml
cp ./templates/dynamic_conf.yml ./dynamic_conf.yml
sed -i "s/<host>/$host/" ./dynamic_conf.yml
# Use '#' as the delimiter since the MD5 hash can contain '/' characters
sed -i "s#<pwd>#$traefik_pwd#" ./dynamic_conf.yml

# Generate acme.json
cat /dev/null > acme.json
chmod 600 acme.json

popd > /dev/null
