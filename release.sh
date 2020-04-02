#!/bin/bash
# 发布

project='TFoundation'
#spec='NLSpecs'

echo -n "输入该私有库版本号(tag):"
read version

read -p "输入发布私有库的版本更新描述:" desc

echo "==================🚀======================="
echo "仓库名称: $spec"
echo "项目名称: $project"
echo "项目版本: $version"
echo "版本描述: $desc"
echo "==================🚀======================="

read -n2 -p "是否发布?[Y/N]?" answer
case $answer in
(Y | y)
	fastlane release_pod project:$project version:$version repo:$spec desc:$desc
	echo "===Finished===🎆======================"
(N | n)
	echo "ok, good bye";;
(*)
	echo "error choice";;
esac
