---
layout: post
title: '#DBHangOps 02/19/15 -- Long Query Time, Operational TokuDB, and more!'
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
\#DBHangOps 02/19/15 -- Long Query Time, Operational TokuDB, and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **February, 19, 2015 at 11:00am pacific (19:00 GMT)**, to participate in the discussion about:

* Learnings from operating TokuDB
* What's a good `long_query_time`?
* Testing your backups
* MySQL 5.7 defaults suggestions

You can check out the event page at https://plus.google.com/events/cohut2qncrbkrrmbs868kjorvbo on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/JxrjYwtU62I" frameborder="0" allowfullscreen></iframe>


<a href="#show-notes" id="show-notes">Show Notes</a>
==========

## Learnings from operating TokuDB
* Jeremy Tinley from Etsy setup (and [blogged about](https://jeremytinley.wordpress.com/2015/02/09/operationalizing-tokudb/)) setting up TokuDB
* Had a mysql store that was getting bulk-loaded periodically
* Previously using Percona server
* Wanted to try out TokuDB for faster bulk load and high compression rates.  As part of testing:
  * Workload was predominantly insert-bound
  * 190GB InnoDB tablespace was ~30GB in TokuDB
  * Got a 30% speed improvement
* Setup Chef recipes for Percona server 5.6.17+ with TokuDB
  * Using JMAlloc
  * Disabling Transparent Huge Pages.
    * Setup MySQL to not start on boot so Chef can properly disable THP
  * Newer version of percona server have a script to check for all the components needed to start the server with preferred plugins (e.g. JMalloc)
* TokuDB Config defaults are very sane
  * One gotcha: defaulting 80% of memory to InnoDB.  TokuDB defaults to 50% for the engine and the other 50% is left for OS file cache.
    * Accidentally overallocated here.  Changed the InnoDB heap to 5% so that memory wasn't over-committed
* TokuDB data directory
  * A lot of files with a ".tokudb" extensions
* Monitoring
  * Mostly the same monitoring:
    * Is MySQL up?
    * How many threads in the server?
  * Most things are handled at the MySQL, not the engine level, so it works pretty easily
  * Need to add some graphing for "SHOW ENGINE TOKUDB STATUS" (which is very nicely formatted and easy to parse).
    * This output is moslty key=value pairs and are prefixed with common names to be easy to search
  * Still a challenge figuring out which new status counters to watch for the engine and to identify contentious points
    * Not an easy guide to show correlations between innodb counters and tokudb counters
* Backups
  * Xtrabackup doesn't work for TokuDB! :(
  * Using MyLVMBackup to do basic LVM snapshots on the dataset
    * Needed to patch this to do an SSH copy to a backup server on the fly instead of rsync'ing after the backup
* Overall results
  * Storing a feed of all modifications to production sharded environment for being inserted into Solr for searching
  * 190GB InnoDB table went to ~30GB TokuDB table
  * Slightly higher CPU usage due to compression, but great for I/O bound systems
  * 6x increase in backfill process
  * Successful win for Etsy.
  * Want to get more operational experience with MySQL 5.6 and TokuDB
* Other Questions
  * Is there a hot backup tool for Tokutek?
    * There's an enterprise solution that comes with a hot backup tool
    * Works like a snapshot method
  * What's the typical workload with respect to concurrency and locking?
    * ~80% insert volume and the rest are selects for inserts into Solr
  * Debuggability
    * How do you trace transaction locking and deadlocks as compared to InnoDB (e.g. ENGINE INNODB STATUS and `information_schema` data)
    * There's tables in `information_schema` for accessing locks
      * More data on Tokutek's documentation for identifying this information
  * TokuDB's sweet spots are insert speed (like bulk inserts) and compression ratios. Any noticeable weak spots that came up?
    * Are point selects and range queries less efficient compared to innodb?
    * Jeremy hasn't observed any of this yet, but there's definitely more learning that needs to happen
    * When Shlomi did some testing some locking behavior got heavy
      * TokuDB v7.1.6
  * Schema Changes?
    * Were able to apply schema changes on the fly against the engine. Except for the thread initiating the query, everything seemed to move along well.
    * When you add a column, you can begin using it, even before the alter finishes
* First time playing with MySQL 5.6
  * Multi-threaded slaves!
    * Saw replication lag jump when loading the first set of inserts.  Jeremy wrote a [follow-up blog post](https://jeremytinley.wordpress.com/2015/02/08/multithreaded-replication-to-the-rescue/) for setting up MTS replication.
  * Any issues?
    * When restartin Percona Server a 1755 error was generated. The workaround was to set the number of worker threads back to '0'. Frustrating, but not a show stopper.
      * It's good to keep this at 0 and increase it to speed up replication when things slow down.
  * Deep dive blog post about multi-threaded slaves http://geek.rohitkalhans.com/2013/09/enhancedMTS-deepdive.html and configuration suggestions at http://geek.rohitkalhans.com/2013/09/enhancedMTS-configuration.html may help!
  * MySQL 5.7 has improved group commit to help move replication along even faster

## `long_query_time`
* How do you set it?
  * 1 second
    * It's a reasonable value that can still capture enough of things
    * If you go above 1 you can still miss a whole bunch of slow queries
  * 500ms these days is starting to be considered "slow"
* 0 seconds?
  * You get *all* queries when set to this threshold
  * This can give you a global view of everything going through a server
* Building on top of `performance_schema` data is probably more valuable to get at this data now
  * Any tools that leverage `performance_schema` can help find problematic queries that may not run a long time (e.g. MySQL Enterprise Monitor)
* Instead of using the slow query log to get this data, measure traffic coming over tcpdump and evaluate from there
  * VividCortex does this to try and identify per-query basis measuring of traffic
  * You're not required to turn on `performance_schema` or the slow query log
* MySQL 5.7 is proposing to lower this value because the default is too high (10s). Planning to drive this down to 2s
  * MongoDB's equivalent to long query time is 100ms.
* Is there value in having a long transaction log?
  * Not yet...but you can get at this information by probing the `INNODB_TRX `
  * Perhaps having a `transaction_timeout` configuration in a future
  * In MySQL 5.7, some transaction instruments will be enabled by default in performance schema.
    * You can get information about the type of transaction, isolation level, length, user, etc.
    * Also planning to turn on statement history instruments so you can see the last couple statements from a transaction/connection as well
