#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install fish -y
echo "${public_key}" >> /home/ec2-user/.ssh/authorized_keys