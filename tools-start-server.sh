
if [ -z $1 ]
then
port=9292
else
port=$1
fi

echo $port


sudo fuser -k $port/tcp
#sudo rackup


xdg-open http://localhost:9292

sudo bundle exec rackup -p $port

