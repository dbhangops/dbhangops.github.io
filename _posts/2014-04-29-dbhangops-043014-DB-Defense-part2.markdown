---
layout: post
title: '#DBHangOps 04/30/14 -- Database Defense (part 2) and 5.6 upgrade stories!'
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
\#DBHangOps 04/30/14 -- Database Defense (part 2) and 5.6 upgrade stories!
=========================================================

Check out the recording below:

<iframe width="420" height="315" src="http://www.youtube.com/embed/5V2V2mynsIY" frameborder="0" allowfullscreen></iframe>


Hello everybody!

Join in \#DBHangOps this Wednesday, **April, 30, 2014 at 12:00pm pacific (19:00 GMT)**, to participate in the discussion about:

* Database Defense part 2
	* Protecting production
	* Security!
* 5.6 Upgrade stories from Ike Walker

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Wednesday!

Also hit up the scheduling doodle at http://doodle.com/vbhupvveihzt95z8 and let us know what time works best for you to make it to \#DBHangOps!

See all of you on Wednesday!

<a name="show-notes">Show notes</a>
===========

## Database Defense (part 2)
* Security!
	* Most data transfers should go through a secured pipe
		* SSL for replication and backups
	* Passwords
		* Have password rotation policies in place!
		* Dictionary word passwords are easy to crack using sites like https://crackstation.net/ (just scan a rainbow table)
			* Make sure you've got nice secure passwords!
		* User management
			* MariaDB has support for roles via https://mariadb.com/kb/en/roles-overview/
			* Most versions of MySQL have support for LDAP/PAM authentication
				* http://dev.mysql.com/doc/refman/5.6/en/validate-password-plugin.html
				* https://mariadb.com/kb/en/pam-authentication-plugin/
* Shared resource defense (e.g. running in the cloud or using shared virtualized environment)
	* AWS has provisioned IOPS which can help you get more dedicated resources
	* When in shared environments, "over-provisioning" may get you a more dedicated resource
* Tools/suggestions
	* Server-level changes
		* MAX CONNECTIONS -- you can set this on a server-level, user-leve, and *per-user* level.  If you have multiple applications, assigning them different user and setting a MAX CONNECTION on the user acocunt can help
		* wait_timeout -- influences how long sleeping connections are allowed on the server.  Default is 8 hours. Consider setting this lower (perhaps 5-15 minutes)
		* lock_wait_timeout -- This influences how long a query will wait for a lock to be granted before proceeding.  The default of this is *1 year*.  This value does not influence locking behavior in InnoDB (see innodb_lock_wait_timeout)
			* This is checked by some tools to influence their behavior (e.g. pt-online-schema-change)
		* slave_net_timeout -- cross geo replication (cross-continent) and network delays hit 100ms+, replication might constantly stop
	* After you're in a bad state
		* pt-kill -- Get familiar with the tool. It can be supremely helpful during problems!


## 5.6 Upgrade stories (Ike Walker)
* Read the MySQL upgrade document!
	* https://dev.mysql.com/doc/refman/5.6/en/upgrading-from-previous-series.html
* Upgrading gets you to some really nice features
	* Online DDL
	* Improved replication speed (even w/o parallel replication)
	* GTIDs
* Gotchas to watch out for!
	* Binlog checksums
		* 5.6 couldn't replicate to a 5.5 server because binlog checksums are on by default
		* Read Ike's blog post about it http://mechanics.flite.com/blog/2014/04/29/disabling-binlog-checksum-for-mysql-5-dot-5-slash-5-dot-6-master-master-replication/
	* Timestamp changes
		* support for milliseconds
		* datetime storage went from 8 bytes to 5 bytes -- you may need to rebuild all tables with timestamps to pick up this change.
	* Increased I/O due to InnoDB flushing. Read Shlomi's blog post about this behavior http://code.openark.org/blog/mysql/the-mystery-of-mysql-5-6-excessive-buffer-pool-flushing

