---
layout: post
title: '#DBHangOps 08/06/15 -- Orchestrator and Binlog Servers and more!'
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
\#DBHangOps 08/06/15 -- Orchestrator and Binlog Servers and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **August, 06, 2015 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* Orchestrator and Binlog Servers from Shlomi Noach
* Configuration vs. Orchestration

You can check out the event page at https://plus.google.com/events/ci32euumljnmivfo8kkh9j8kum8 on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/QNuAj7XsDow" frameborder="0" allowfullscreen></iframe>

<a id="show-notes" href="#show-notes">Show Notes</a>
==========

### Binlog Servers
* Binlog servers appear as a mysql daemon to any mysql masters or replicas, but it merely proxies binary log events to downstream replicas
    * Binlog servers are also meant to act as if they're the same as their upstream master
    * you do a "CHANGE MASTER TO..." pointing at the hostname of an individual binlog server, but when statements are relayed from a binlog server, they have the server_id of their masters
* "binlog servers: Ctrl-C Ctrl-V as a service!"
* binlog servers help provide "master fanout" to allow more read replicas to for a given set of data
* At Booking.com, replicas connect to a VIP in order to access the next available binlog server.  As a result, if a binlog server fails, a replica will connect to the next available one.
* Binlog servers will download a list of credentials from its upstream master to service data under the same authorization flow
* Anything interrogation for replication (e.g. `SHOW SLAVE STATUS` or `SHOW VARIABLES`) will work, but data inspection statements like `SHOW TABLES` won't return anything
* Using binlog servers in place of intermediate masters has interesting implications with parallel replication
    * Intermediate masters in the parallel replication world slow down things a little bit more than binlog servers at present.
    * http://blog.booking.com/better_parallel_replication_for_mysql.html has some more details about this!

## Orchestrator and Binlog Servers
* Binlog servers show up in orchestrator as "INHERIT" for their statement types
* Orchestrator is now able to support interacting with binlog servers and making intelligent decisions with binlog servers in a replication topology
* since binlog servers serve the same server-id as an upstream master, orchestrator knows it can simply update "MASTER_HOST" on downstream replicas
* It seems like orcehstrator with binlog servers has a lot of overlap with GTIDs in MySQL. Why use one over the other?
    * using binlog servers allows for faster healing of large topolgoies.  If you have to repoint 10 replicas, you need to have scan binary logs on each replica.  Binlog servers allow you to just change the host you point at.
    * using binlog servers doesn't really add additional lag into the topology like you would see with an intermediate master
        * Unless you do something extreme like delete 1mil records using Row-Based Replication
* How does semi-sync play into a topology with Binlog servers?
    * Support for this is being worked on.  This allows for stronger guarantees of statement durability across multiple nodes.  Current idea is that binlog servers will be semi-sync and downstream replicas may still be asynchronous
* Other Binlog servers ideas/use cases
    * Could binlog servers also service backup architecture work?
        * Binlog servers could compress binary logs and relay them elsewhere for backup/recovery purposes
* Orchestrator and Binlog servers are both solutions to help solve self-healing replication
    * Even though these are effectively competing solutions, they work together very well for addressing read-scaling and gradual migration of topologies from stock replication to a binlog server topology
        * Booking.com is presently running a hybrid solution to help with the transition to binlog servers

### Example of reconverging a topology after a master failure with Binlog servers
* if you have a master fail that has binlog servers directly below it, there's a chance these binlog servers might not be 100% in sync.  The solution is to make any lagged binlog servers replicate from a more up to date one
* This makes the notion of automated convergence even faster/easier since you can simply point all binlog servers to the most up to date one.  All other downstream replicas don't notice a difference.
    * This will make it easy to promote a downstream RO replica to master for all nodes.
    * until MySQL Bug#77482 is addressed, you effectively issue `FLUSH LOGS` on the replica to promote until it's binary log file and position match what its old master used to have
    * If you have an RO replica that has a binary log file with a higher number than the master, you could issue a `RESET MASTER` on the replica to set it back to binary log file 1 (e.g. bin.000001) and then issues `FLUSH LOGS` until it's caught up to the binary log file of the master

## Interesting links!
* https://www.percona.com/live/mysql-conference-2015/sessions/binlog-servers-bookingcom
* https://github.com/outbrain/orchestrator
* https://bugs.mysql.com/bug.php?id=77482 and https://mariadb.atlassian.net/browse/MDEV-8469 are tracking a fix to add `RESET MASTER TO...` syntax to MySQL
    * This fix has already made it into MariaDB https://mariadb.com/kb/en/mariadb/mariadb-1016-release-notes/ !
* http://jfg-mysql.blogspot.nl/2015/04/maxscale-binlog-server-howto-poc-master-promotion.html
* http://blog.booking.com/better_parallel_replication_for_mysql.html
