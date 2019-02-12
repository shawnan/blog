#!/bin/sh

# post process script
# first param: hexo workspace path

POSTS_PATH=$1
echo $POSTS_PATH
rm -rf $POSTS_PATH/source/_posts/*
cp -f ./posts/* $POSTS_PATH/source/_posts

cd $POSTS_PATH
source /etc/profile
hexo clean
hexo g
