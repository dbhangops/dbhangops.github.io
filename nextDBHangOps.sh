#!/usr/bin/env bash
# Quick an dirty script to create the next post!

# Ensure we have a short title (needed for the filename)
if [[ -z "$1" ]]
then
	echo "usage: ${0} shortTitle"
	echo "e.g.: ${0} new-dba"
	exit 1
fi
root="$(dirname "$0")"
nextShortDate="$(date -v+wed "+%m%d%y")"
nextSlashDate="$(date -v+wed "+%m/%d/%y")"
fullDate="$(date -v+wed "+%B, %d, %Y")"
newFile="${root}/_posts/$(date "+%Y-%m-%d")-dbhangops-${nextShortDate}-${1}.markdown"

cat << EOF > "$newFile"
---
layout: post
title: '#DBHangOps ${nextSlashDate} -- TODO:ReplaceWithFullTitle'
categories:
- computing
- database
- debugging
- linux
- mysql
tags:
- '#DBHangOps'
- computing
- database
- HangOps
- linux
- mysql
- mysql_planet
status: publish
type: post
published: true
---
\#DBHangOps ${nextSlashDate} -- TODO:ReplaceWithFullTitle
=========================================================

Hello everybody!

Join in \#DBHangOps this Wednesday, **${fullDate} at 12:00pm pacific (20:00 GMT)**, to participate in the discussion about:

* TODO:ReplaceWithDiscussionPoint
	* TODO:ReplaceWithDiscussionPointSubItem

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Wednesday!

See all of you on Wednesday!
EOF

