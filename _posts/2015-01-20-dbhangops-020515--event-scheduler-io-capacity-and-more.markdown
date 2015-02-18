---
layout: post
title: '#DBHangOps 02/05/15 -- MySQL Event Scheduler, InnoDB IO Capacity, and more!'
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
\#DBHangOps 02/05/15 -- MySQL Event Scheduler, InnoDB IO Capacity, and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **February, 5, 2015 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* Managing Multiple instance of MySQL
* MySQL Event Scheduler
  * What use cases do you have?
* What is everyone's understanding of *innodb_io_capacity*?
* Percona Live MySQL Conference and Expo 2015
  * What are you excited about?

You can check out the event page at [https://plus.google.com/events/c50qple2vajgq6ltrutk1s3cfss](https://plus.google.com/events/c50qple2vajgq6ltrutk1s3cfss) on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/K8sqsLoHZes" frameborder="0" allowfullscreen></iframe>


Show Notes
==========
## Managing Multiple MySQL Instances
* Why?
  * pre-sharded environments for future proofing can share common hardware until they grow out of it
  * allows better utilization of expensive resources. E.g.:
* How?
  * init scripts
      * use mysqld_multi
      * setup multiple sepearate init scripts
  * make sure data directories are all different, etc.
* Better to use virtualization than using multiple instances?
  * If you're worried about the hypervisor, you can look at containerization (e.g. Docker)
* single instnace is preferred because you have better control of the configuration and memory allocation

## `innodb_io_capacity`
* What's it used for?
  * (Jeremy) Last I checked, it's a value used to influence how frequently the innodb engine can flush
  * (Daniel) the old setting used to be 100. When they made it a configurable, the default was 200.
* What is actulaly is!
  * https://dev.mysql.com/doc/refman/5.6/en/innodb-parameters.html#sysvar_innodb_io_capacity_max
  * Flushing's not a bad description.  InnoDB tries to do a lot of stuff in the background automatically.
  * When you make a modification, it's done in memory and logged in the log file.  Now you have "debt" that you need to get persisted.
  * It's a throttling number to help influence how many IOs innodb can do in the background
      * insert buffer page merges
      * deleting marked records
  * 200 is still the default since it became configurable
    * For good hard drives, they can usually do 200 IOPS so this is reasonable unless you have more IO available (e.g. RAID, SSD, etc.)
  * if it's too high, you do background activity too quick
  * if it's too low, log files accumulate too much debt and adaptive flushing may kick in to protect the durability of log data until the 
  * How do you know if you've fallen out of the sweet spot?
    * If you start hitting adaptive flushing, it means you need either a larger log file or to tweak your `innodb_io_capacity`
  * How do folks determine what to set this to in practice?
    * Sysbench to figure out how much work can be done
        * Rough idea based on today's hardware:
            * 15k drives in RAID10 -- 1600 - 2000 IOPS
            * some SSD drives 20k-60k IOPS
        * Set innodb_io_capacity to ~80% of max IOPS
        * You probably need to drive a sysbench benchmark from a different machine so you don't rob it from the server

## MySQL Event Scheduler
* How can it be used?
  * Anything you can do in a stored procedure can be done in an event
  * Any variables you change will probably only last on the session level
  * Doing anything that's purely database is probably good to keep in events because then you can "backup" the maintenance work too (e.g. partition maintenance)
* Do you currently use it? If so, what for?
  * Flushing `query_cache` periodically.
  * For some datasets in partitioned tables, the scheduler could be used to drop the oldest partition automatically
    * Setup a daily, weekly, and monthly event that would validate the partitions and correct them
    * This worked regardless of the operating system (so you don't need to do a crontab).
  * Use to make Pseudo GTIDs to support orchestrator for MySQL 5.5.
* Any Gotchas or problems?
  * Need to remember to dump/restore it and have definer properly defined
  * You can't easily fire an e-mail/alert from events.
    * You can define a UDF to support firing e-mails
    * You could create a table to log the output from stored procedures and such

## Additional Links
* http://databaseblog.myname.nl/2014/11/throttling-mysql-enterprise-backup-with.html
* https://github.com/mysql/mysql-server/blob/5.6/storage/innobase/buf/buf0flu.cc#L2174
* https://github.com/mysql/mysql-server/blob/5.7/storage/innobase/buf/buf0dump.cc#L333
* http://gtowey.blogspot.com/2012/09/how-to-shoot-yourself-in-foot-with.html

