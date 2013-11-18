---
layout: post
title: '#DBHangOps 11/13/13 -- MySQL Setup Through Puppet!'
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
\#DBHangOps 11/13/13 -- MySQL setup through Puppet!
========================================================

Here's the recording. Be sure to view the presentation and [show notes below](#show-notes):
<iframe width="560" height="315" src="//www.youtube.com/embed/4XuDhkobzX0" frameborder="0" allowfullscreen></iframe>

Hello everyone!

Participate in \#DBHangOps this Wednesday, **November 13th, 2013 at 12:00pm pacific (19:00 GMT)**, to hear about:

* ~~How do you ramp up new DBAs?~~
	* ~~How do you ramp up a non-DBA to being a DBA?~~
* How Mozilla manages MySQL through puppet
* ~~MySQL-isms!~~
	* ~~(From Gerry) Sub SELECTs -- Why aren't these as mature as other databases?~~
	* ~~(From Daniel) GROUP_CONCAT and other OLAP Style query functions -- Why doesn't MySQL have them?~~
	* ~~(From Gerry) MySQL DBAs are used to building covering indexes to avoid PK lookups -- Is there a plan for this to change?~~

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Wednesday!

See all of you on Wednesday!



---

<a name="show-notes">Show notes</a>
==========

## How Mozilla manages MySQL Through Pupppet ##
Feel free to fork the repository and submit fixes at on github at
### **[https://github.com/mozilla-it/puppet-mysql](https://github.com/mozilla-it/puppet-mysql)** ###

<iframe src="https://notouchems.app.box.com/embed_widget/uoudgcdqxiss/s/ikgq53wudh0w0x6wr4hw?view=list&sort=name&direction=ASC&theme=gray" width="500" height="400" frameborder="0" allowfullscreen webkitallowfullscreen mozallowfullscreen oallowfullscreen msallowfullscreen></iframe>

* The puppet module is focused on single-instance of mysql per host
	* Mozilla has additional glue that allows for multiple instances on backup servers
* server ID is auto-generated from a custom script using the IP address
	* Mark Leith calls out [this blog post](http://www.tusacentral.net/joomla/index.php/mysql-blogs/163-server-id-misconfiguration-can-affect-you-more-then-you-think.html) that explains some pitfalls of adminstrators when setting server IDs
* Only the needed YUM repositories should be realized for a given installation since there may be conflicts (e.g. MariaDB, Percona, Oracle, etc.)
* Mozilla doesn't set swappiness to 0
	* The reason is so that the Out-of-Memory Killer (OOMKiller) doesn't kill MySQL on a host (since it's typically the largest memory consumer)
	* It's possible to exempt MySQL from the OOMKiller -- this way you could set swappiness to 0 and have other processes killed instead
	* If MySQL over-commits on memory, you may encounter a system crash.
