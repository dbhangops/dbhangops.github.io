---
layout: post
title: '#DBHangOps 11/13/14 -- More Orchestrator, Dealing with logical corruption, and more!'
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
\#DBHangOps 11/13/14 -- More Orchestrator, Dealing with logical corruption, and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **November, 13, 2014 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* More uses of [Orchestrator](https://github.com/outbrain/orchestrator) for MySQL
* Dealing with logical corruptions (a.k.a. a bug in my application changed data it shouldn't have...)
* Mixing data and metadata

You can check out the event page at https://plus.google.com/events/cuuu7aua9sg2q7k5krlvhgqgntg on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

The recording can be seen below:

<iframe width="560" height="315" src="//www.youtube.com/embed/qAQ0c97TODk" frameborder="0" allowfullscreen></iframe>


<a href="#show-notes">Show Notes</a>
==========
## More uses of Orchestrator
* Pseudo GTIDs
	* Benefits
		* being able to easily move nodes around in your replication topology even if you don't have GTID enabled
		* One of the problems with enabling GTID is you have to stop a whole cluster of MySQLs
		* Psedo GTIDs were inspired by some work by Sam Lambert at Github
		* You're able to recover from an intermediate master failure and reattach replication.
		* If you stop the master of all nodes in a topology all slaves may not be at the same position
			* Using Pseudo GTIDs, you can resync all the slaves to the same position using the Orchestrator API
	* How it works
		* MySQL is writing binary logs in order for replication to work
		* A downstream slave will copy these binary logs into a set of local relay logs.
			* these aren't identical to the upstream binary logs, so you'll have different sizes and numbers of these files
			* relay logs are automatically deleted shortly after statements have been consumed from them, so you can't trust that they'll always be available
		* If a slave is also using "log_slave_update", it'll also log statements in its relay logs into its *own* binary logs
			* Again, file sizes, counts, and positions will be different but ultimately the same "data" should be here, and in the same order.
			* You have a guarantee that the binary logs will be available (at least until the expiration that you set)
		* Pseudo GTIDs depend on injecting a unique statement on a fixed time interval (e.g. every 10 seconds)
			* This is meant to be an identifiable statement that can be parsed from the binary log on downstream replicas
		* if you were to concatenate all the binary logs into a "virtual binary log", you'd see a pretty similar file between the master and slave
			* There may be a few bogus statements like "END OF BINARY LOG" or such.
			* Pseudo GTID expects otherwise identical statements in the logs.  There are some things that could cause it to fail still (e.g. ANALYZE TABLE, etc.), so be cognizant of this when testing!
		* Using the Unique inserted statement, we can easily find a "synchronization point" on all servers to help figure out what statements haven't been executed on a given slave
	* Until you have a path for online switching to GTIDs, you can potentially leverage Pseudo GTIDs and use orchestrator to help!
	* The orchestrator website has information to help bootstrap you with Pseudo GTIDs using Orchestrator! :)
		* you'll need to enable log_slave_updates and potentially sync_binlog

## Logical corruptions
* What are logical corruptions?
	* these happen when data is inadvertently changed inside of your RDBMS.  E.g. your application starts writing modified timestamp instead of updated timestamp in a field
* entity level backup
	* backup information for particular objects in your application (e.g. a specific user and their relationships in the data set)
	* It seems like http://www.ddengine.org/ might provide some help with doing this type of process
* Logical corruptions could be protected by not updating records and instead inserting new ones and purging old ones from the system offline
	* This can be very costly for disk space and some other performance considerations
* You can try to mandate maintaining some level of history in a record, but this can be hard to enforce
* To defend against corruption you should:
	* Take backups often
	* Test your backups often (periodically restore your backups and verify they work)
	* If you don't have a backup solution, get one! Even a cron job that does a `mysqldump` periodically should help
		* You should also backup binlogs so you have a more complete history to restore
* Physical corruptions are just as bad and tend to be more noticed
	* E.g. a bad disk, a bad block in your innodb datafile
	* innodb_force_recovery is available when this happens http://dev.mysql.com/doc/refman/5.6/en/forcing-innodb-recovery.html
	* Typically, you'll find there's a range of bad records that you need to retrieve data from before and after

