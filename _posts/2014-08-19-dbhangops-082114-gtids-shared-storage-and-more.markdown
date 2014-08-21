---
layout: post
title: '#DBHangOps 08/21/14 -- GTIDs, Shared Storage, and more!'
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
\#DBHangOps 08/21/14 -- GTIDs, Shared Storage, and more!
=========================================================

You can join today's Google Hangout at http://bit.ly/1vmGR9W or watch the livestream below:

<iframe width="420" height="315" src="http://www.youtube.com/embed/xNsN8nuei80" frameborder="0" allowfullscreen></iframe>

Hello everybody!

Join in \#DBHangOps this Thursday, **August, 21, 2014 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* GTIDs in MariaDB Demo from Gerry!
* Shared storage and MySQL
	* How about NFS?
* Index Fragmentation (requested by Shlomi)

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!


<a name="show-notes">Show notes</a>
===========
## GTIDs in MariaDB
* MariaDB is always implicitly running with GTIDs under the hood, even if you don't have them enabled.
	* This allows you to easily enable/disable GTIDs on a running server without shutting down a whole topology of machines
	* You can convert a master's binlog coordinates to GTID coordinates using "SELECT BINLOG_GTID_POS('binlog_file.000001', binlog_pos)"
		* This is similar to doing "MASTER_AUTO_POSITION" in Oracle MySQL.
* Future version of MySQL 5.7 will begin allowing for enabling GTIDs without restarting MySQL
* MySQL creates a UUID to identify itself for GTIDs whereas MariaDB depends on the setting of server_id
	* If you want stronger uniqueness for server_id, you can use the "inet_aton()" function in MySQL to create a numerical representation of an IP address

## Shared storage and NFS
* A lot of the historical issues with NFS have improved with NFSv4 since there is now mandatory and advisory locking support
* The "binlog_impossible_mode" variable is extremely useful to set for MySQL servers running on NFS
	* http://dev.mysql.com/doc/refman/5.6/en/replication-options-binary-log.html#sysvar_binlog_impossible_mode
	* Allows you to dictate how mysql should behave if it can't write it's binlogs
* A word of caution: historically, periodic performance issues with a database server could be as a result of shared storage if it's used by other machines
* Also be cognizant of NFS issues and documentation with mysql -- http://bugs.mysql.com/bug.php?id=71969
* Would shared storage be better going forward now that we can start using SSDs in shared storage devices?
* Ideally, putting less-performance-critical data onto NFS would allow you to leverage the best of both worlds
	* There's an option to store individual tables on different data directories in future versions of MySQL?

