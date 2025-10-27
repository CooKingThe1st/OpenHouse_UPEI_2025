#!/usr/bin/env bash
sudo ps -ef | grep Ras_normal_run | grep -v grep | awk '{print $2}' | xargs sudo kill
sudo ./Ras_normal_run 0 0 0 -s
