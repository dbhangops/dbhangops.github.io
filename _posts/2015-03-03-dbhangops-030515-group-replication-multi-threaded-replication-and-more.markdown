---
layout: post
title: '#DBHangOps 03/05/15 -- Group Replication, Multithreaded Replication, and more!'
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
\#DBHangOps 03/05/15 -- Group Replication, Multithreaded Replication, and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **March, 05, 2015 at 11:00am pacific (19:00 GMT)**, to participate in the discussion about:

* Group Replication
* Multithreaded Replication
* Operational learnings with GTID
* New MySQL 5.7 defaults from Morgan Tocker

You can check out the event page at https://plus.google.com/events/cjbmf109r6d7isr715iupigsrq4 on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/I_cqAcx1gZ4" frameborder="0" allowfullscreen></iframe>


Show Notes
==========
## Multithreads Replication
* MySQL 5.7 and MariaDB support true multi-threaded replication
  * MySQL 5.6 has a dependency on needing different schemas for replication to be parallel
  * statements are issue concurrently in the master and are grouped when written to the binary log
  * statements within the same schema can be issued in parallel as well
* When things are committed together on the master, how do we guarantee they're committed the same on the slave?
* How do things change for operators?
  * `SHOW SLAVE STATUS` should be the same, but can you interpret it the same?
    * the `Seconds_Behind_Master` field is set based on the timestamp in the binary log, so that should still reflect the state of the statement's last executed
  * `STOP SLAVE` may be a little slower because you need to wait for in flight transactions to wrap up.
  * In MySQL prior to 5.7.5, transactions can be out of order so shorter transactions may be favored first.
  * Tools like pt-heartbeat will work differently here because the heartbeat statements can commit before other larger transactions.


## Group Replication
* What is group replication?
  * multi-master update everywhere replication plugin!
    * provides group membership, conflict detection, and distributed recovery
    * will also replicate up new nodes automatically
    * InnoDB/MySQL look and feel!
* Allows clients to connect to multiple servers in a topology and trust that their write makes it to all servers
* Architecture:
  * registers listeners to serve events
  * decoupled from server core
  * reuses trueted replication code base
  * Binary log statements are injected into relay log for transactions coming from other servers
* Plugin is responsible for:
  * conflit detection
  * distributed recovery (e.g. membership changes, providing state of transactions, collecting state of transactions)
* Limitations
  * InnoDB only for now
  * Concurrent DDLs are not supported
  * Requires PK on all tables
  * Requires GTIDs to be enabled
  * Limited transaction payload size
  * Hotspotting for transactions having a higher chance to fail
    * To alleviate, run these transactions on the same node
  * Better suited for low-latency, high-bandwidth network
  * Every member of a Group Replication topology has the same full set of data
    * As a result, you probably won't have hundreds of machines (costly to keep in sync). Dozens is a possiblity
* This is different than semi-synchronous replication because it's N<->M master replication.
* Competing technologies
  * This is comparable to Galera replication
    * This could be a replacement for Galera that's out of the box with MySQL
* Great for environments with an elasticity requirement
* Data hotspotting with Group Replication
  * Counters can be hot spots.  If this is a problem, send these statements to the same node potentially.

## Links
* Semi-synchronous replication in MySQL 5.7 -- http://dev.mysql.com/doc/refman/5.7/en/replication-semisync-interface.html
* An easy way to describe MySQL's Binary Log Group Commit (Morgan Tocker) -- http://www.tocker.ca/2014/12/30/an-easy-way-to-describe-mysqls-binary-log-group-commit.html
* Binlog group commit configurations -- http://dev.mysql.com/doc/refman/5.7/en/replication-options-binary-log.html#sysvar_binlog_group_commit_sync_delay

