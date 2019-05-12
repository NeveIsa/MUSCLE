
if [ -z $1 ]
then
port=9292
else
port=$1
fi

echo $port


sudo fuser -k $port/tcp
#sudo rackup
sudo bundle exec rackup -p $port
