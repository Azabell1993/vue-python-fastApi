#!/bin/bash
sudo docker-compose down
sudo docker system prune -a
sudo systemctl restart docker
sudo docker-compose down
sudo docker-compose up -d

