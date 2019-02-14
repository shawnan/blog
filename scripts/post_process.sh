#!/bin/sh

# post process script
# first param: hexo workspace path

BLOG_SOURCE_PATH=$1
HTML_PATH=$2

echo $BLOG_SOURCE_PATH  $HTML_PATH

rm -rf $BLOG_SOURCE_PATH/source/_posts/*
cp -f ./posts/* $BLOG_SOURCE_PATH/source/_posts

cd $BLOG_SOURCE_PATH
source /etc/profile
hexo clean
hexo g

rm -rf $HTML_PATH/blog/*
cp $BLOG_SOURCE_PATH/public/* $HTML_PATH/blog

