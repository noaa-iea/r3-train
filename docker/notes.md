## Launch AWS EC2

console: https://us-west-1.console.aws.amazon.com/ec2

- [Troubleshooting Instances Connecting](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/TroubleshootingInstancesConnecting.html)

- t2.medium "Amazon Linux 2 AMI"
- download private key to `~/private/nps-ec2.pem`

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
```

## Setup RStudio / Shiny Server

```
sudo yum install -y git

git clone https://github.com/ecoquants/nps-r-workshop.git
```

```
cd nps-r-workshop/docker

```

- [Docker Desktop for Mac and Windows](https://embed.vidyard.com/share/txhmiXXLzoQqDKKnZeo5nj?)
    - [dockersamples/node-bulletin-board at v5](https://github.com/dockersamples/node-bulletin-board/tree/v5)

```
# set password as environment variable
NPS_PASSWD=******

# run docker, downloading image if needed
docker run --name "nrel-uses-app" \
  --restart unless-stopped \
  -p 8787:8787 -p 80:3838 \
  -e ROOT=TRUE \
  -e USER=nps -e PASSWORD=$NPS_PASSWD \
  -d -t "bdbest/nrel-uses-app"
```

## Adding Users
[Adding users in Docker container running RStudio that can use RStudio Addins · Issue #206 · rocker-org/rocker](https://github.com/rocker-org/rocker/issues/206)

```
docker exec -it <container-id> bash
adduser <username>
```
