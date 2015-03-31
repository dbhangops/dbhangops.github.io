---
layout: post
title: '#DBHangOps 03/19/15 -- Failing over in the moment, Old and weird bugs, and more!'
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
\#DBHangOps 03/19/15 -- Failing over in the moment, Old and weird bugs, and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **March, 19, 2015 at 11:00am pacific (19:00 GMT)**, to participate in the discussion about:

* Failing over in the moment
  * How do you recognize you need to failover?
  * When is it safe to kill -9 the server?
  * Other thoughts?
* Old/Weird bugs!
* GTID for operators -- Have you set it up?

You can check out the event page at https://plus.google.com/events/ch7dvhercc2anl9knnvig02hng4 on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/nCSPA6Mwn3Y" frameborder="0" allowfullscreen></iframe>


<a id='show-notes'>Show Notes</a>
==========
## Failing over in the moment
* Failover stories?
  * Etsy has an active<->active topology, so writes go to both masters
    * Historically, most problems are hardware trouble that requires some sort of failover
    * typically set the `read_only` flag on a machine that's getting moved to a slave role
    * push a configuration to move traffic from one write master to another to manage failover
* In the past, had a custom heartbeat tool to set `read_only` flags correctly and move customer traffic automatically

### Master<->Master Replication
* Master<->Master replication is a pretty common pattern to be able to quickly failover
  * This can give benefits around quick failover if you pin reads/writes to one side
* Not wholly recommended because of the gotchas that can come up
  * Potential for data drift as writes hit both masters in a topology
* MySQL 5.6 with GTIDs and something like MySQL Fabric make it easier to not need Master<->Master replication

* When is it safe to kill -9 the server?
  * Make a judgement call. If you can't failover a server, you may wait less time
* When do you failover a server?
  * Typically for maintenance
  * Hardware issues
    * In larger shops, this is probably more common
  * some edge case in the application that can't be reverted quickly

### Other thoughts?
* Being able to setup delayed replication in MySQL for disaster recovery scenarios
  * folks historically would use tools to do this (e.g. `pt-slave-delay`)
  * In MySQL 5.6+, you can natively do this and have more confidence about the catch up

## Old/Weird bugs!
* ALTER with ADD AFTER followed by Change fails -- http://bugs.mysql.com/bug.php?id=75473
* Premature expression evaluation prevents short-circuited conditionals -- http://bugs.mysql.com/bug.php?id=70598
* Replication with no tmpdir space can break replication -- http://bugs.mysql.com/bug.php?id=72457
* Safest and most common upgrade strategy broken by 5.7.6 -- https://bugs.mysql.com/bug.php?id=76264
* Replication stall with multi-threaded replication -- http://bugs.mysql.com/bug.php?id=73066
* GTIDs lack a reasonable deployment strategy -- http://bugs.mysql.com/bug.php?id=69059
* mysqldump always includes AUTO_INCREMENT -- https://bugs.mysql.com/bug.php?id=20786
* Disabling innodb_thread_concurrency might cause queries to hang -- http://bugs.mysql.com/bug.php?id=68876
* Truncate table causes innodb stalls -- http://bugs.mysql.com/bug.php?id=68184
* Query to I_S.tables and I_S.columns leads to huge memory usage -- http://bugs.mysql.com/bug.php?id=72322

## GTIDs for Operators
* Enabling GTIDs without downtime in MySQL 5.7.6 -- http://mysqlhighavailability.com/enabling-gtids-without-downtime-in-mysql-5-7-6/

## Other links!
* The "Fun with Bugs!" blog series at http://mysqlentomologist.blogspot.com/
* Upgrading from MySQL 5.6 to 5.7 -- http://dev.mysql.com/doc/refman/5.7/en/upgrading-from-previous-series.html
* Superuser connections variable in twitter's build of MySQL -- https://github.com/twitter/mysql/wiki/System-Variables#superuser_connections
* `extra_port` variable in MariaDB (in case you use all your connections!)-- https://mariadb.com/kb/en/mariadb/server-system-variables/#extra_port
* Write Yourself a Query Rewrite Plugin
  * Part 1 -- http://mysqlserverteam.com/write-yourself-a-query-rewrite-plugin-part-1/
  * Part 2 -- http://mysqlserverteam.com/write-yourself-a-query-rewrite-plugin-part-2/






