#!/bin/sh

# post process script
# first param: hexo workspace path

BLOG_SOURCE_PATH=$1
HTML_PATH=$2
NGINX_PATH=$3

echo $BLOG_SOURCE_PATH  $HTML_PATH

rm -rf $BLOG_SOURCE_PATH/source/_posts/*
cp -f ./posts/* $BLOG_SOURCE_PATH/source/_posts

cd $BLOG_SOURCE_PATH
source /etc/profile
hexo clean
hexo g

rm -rf $HTML_PATH/blog/*
rsync -av --delete $BLOG_SOURCE_PATH/public/ $HTML_PATH/blog/

# 放置nginx的首页
cp -rf htmls/index.html $NGINX_PATH/html/nginx_index.html
