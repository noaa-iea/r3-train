## Launch AWS EC2

console: https://us-west-1.console.aws.amazon.com/ec2

- [Troubleshooting Instances Connecting](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/TroubleshootingInstancesConnecting.html)

- t2.medium "Amazon Linux 2 AMI"
- download private key to `~/private/nps-ec2.pem`
- Security Groups -> Create: Inbound for Anywhere: SSH TCP 22, HTTP TCP 80, Custom TCP 8787. Match with instance in Network Interfaces.
## Log into machine

```
cd ~/private
chmod 400 nps-ec2.pem

USR=ec2-user # ubuntu
PEM=nps-ec2.pem
DNS=ec2-13-57-194-144.us-west-1.compute.amazonaws.com

echo ssh -i "$PEM" $USR@$DNS
ssh -i "$PEM" $USR@$DNS
```

## Setup Docker

- [Docker Basics for Amazon ECS - Amazon Elastic Container Service](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#install_docker)

```
# Update the installed packages and package cache on your instance.
sudo yum update -y

# Install the most recent Docker Community Edition package.
sudo yum install -y docker

#Start the Docker service.
sudo service docker start

# Add the ec2-user to the docker group so you can execute Docker commands without using sudo.
sudo usermod -a -G docker ec2-user

# logout and login again
exit
```

## docker build

```
sudo yum install -y git

git clone https://github.com/ecoquants/nps-r-workshop.git
```

```
cd nps-r-workshop/docker
docker build -t "bdbest/rstudio-shiny:2018-11-08" .
docker images
```

## TODO: push image

```
docker login # registered as bdbest (bdbest@gmail.com)
docker push "bdbest/rstudio-shiny:2018-11-08"
```

## docker run

```
cd # /home/ec2-user
mkdir data
```

```
# set password as environment variable
NPS_PASSWD=******

# run docker, downloading image if needed
docker run --name "rstudio-shiny" \
  --restart unless-stopped \
  -p 8787:8787 -p 80:3838 \
  -v /home/ec2-user/data:/data \
  -e ROOT=TRUE \
  -e USER=rstudio -e PASSWORD=$NPS_PASSWD \
  -d -t "bdbest/rstudio-shiny:2018-11-08"
```

## Other: docker-compose

- [Docker Desktop for Mac and Windows](https://embed.vidyard.com/share/txhmiXXLzoQqDKKnZeo5nj?)
    - [dockersamples/node-bulletin-board at v5](https://github.com/dockersamples/node-bulletin-board/tree/v5)


## Adding Users
[Adding users in Docker container running RStudio that can use RStudio Addins · Issue #206 · rocker-org/rocker](https://github.com/rocker-org/rocker/issues/206)

```
docker exec -it <container-id> bash
adduser <username>
```
