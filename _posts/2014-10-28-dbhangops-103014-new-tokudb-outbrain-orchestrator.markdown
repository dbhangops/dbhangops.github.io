---
layout: post
title: "#DBHangOps 10/30/14 -- New in TokuDB, Outbrain's Orchestrator, and more!"
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
\#DBHangOps 10/30/14 -- New in TokuDB, Outbrain's Orchestrator, and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **October, 30, 2014 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* What's new in TokuDB 7.5
* Outbrain's [Orchestrator](https://github.com/outbrain/orchestrator) - how are other people using it?
* Mixing data and metadata

You can check out the event page at https://plus.google.com/events/c133qbpofubhliavlou8iie4qic on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/fMCN4c3u45A" frameborder="0" allowfullscreen></iframe>


<a href="#show-notes">Show Notes</a>
==========
## What's new in TokuDB 7.5
* What is TokuDB?
	* a transactional MySQL Storage Engine
	* Free/OSS Community editiong. Check out the code at http://github.com/Tokutek/ft-engine
	* Always about Performance + Compression + Agility
* Indexing 101!
	* B-Trees
		* InnoDB and MyISAM use BTree indexes.  It typically looks like a pyramid with "Pivots" and points that can get you to the sorted leaf nodes.
			* This allows you to quickly get to the data you're looking for.
		* Imagine the data in the BTree index being simply Key=\>Value pairs.
		* Once you get to the leaf nodes, a binary search will happen, but everything is already sorted so it's a quick scan
		* BTrees were invented in the early 1970s.  A good data structure, but we're starting to push it's scale limits
			* When the BTree doesn't wholly fit in memory, you'll start to see "problems".
		* One IO is needed for every insert/update (actually it's one IO for every index on the table)
	* Fractal trees
		* similar to B-Trees.  The 2 big differences are:
			* All internal nodes have message buffers
			* Big nodes (4MB vs. ~16KB)
		* You can define the node size at a table level
		* thanks to the message buffers, you can sometimes serve reads before traversing farther down the index.  Eventually changes cascade down into the leaf nodes.
		* Updates are effectively a "Delete then Insert". So only inserts/deletes were needed initially
		* New message types allow for greater flexibility too.
			* add_column() message means a new field can be kep in the message buffer before persisting down in the leaf nodes.
	* What about the InnoDB Change buffer?
		* The primary key index doesn't have a buffer
		* Each secondary index only has one buffer (and it can grow pretty large)
		* The bigger the dataset, the slower your insertions will get over time
* MySQL Replication 101
	* Modes and logging:
		* Statement Based - statement that's run on a master is written verbatim into the replication log
		* Row Based - inserts and deletes simply write a PK and the operation.  Updates write a copy of the row before the update and the changed version of the row
		* Mixed - defaults to statement unless MySQL detects an "unsafe" statement (e.g. a non-deterministic UPDATE statement)
	* Read only slaves
		* typically you want to set "read_only=1".  This means only replication or users with the SUPER privilege can change data
			* "Read-free Replication" in TokuDB will break if a statement is inserted by a SUPER user. Be warned!
	* Slave lag
		* in MySQL 5.5, replication is single-threaded.  The master is concurrent, but the slave will not be.
		* MySQL 5.6 and MariaDB 10.0 have parallel replication methods
		* Read Free Replication in TokuDB benefits from these too!
* TokuDB Read Free Replication
	* Binlog format must be set to ROW
	* Slave must have the following set:
		* read_only=1
		* tokudb_rpl_unique_checks=0 and/or tokudb_rpl_lookup_rows=0
	* Skipping unique checks (tokudb\_rpl\_unique\_checks)
		* Master's already done the uniqueness check, so the slave can probably skip this
			* Since InnoDB doesn't support change buffering on the primary key, it needs to do this uniqueness check for maintenance
	* Skipping Read/Write/Modify behavior (tokudb\_rpl\_lookup\_rows)
		* If RBR is enabled, master is already providing before/after images of a row
		* Everything that's needed for the change is already in the binary log
		* TokuDB can do a simple message injection
	* Enabling Read Free Replication can help lagging slaves keep up.  It also opens up a significant percentage of read capacity.
	* When enabling Read Free Replication , most reads on a slave that would be needed for replication effectively go away.
	* By opening up read capacity, you could potentially co-locate more than one mysqld for different mysql clusters to save on hardware
	
## Outbrain Orchestrator
* Check out the GitHub project at https://github.com/outbrain/orchestrator
	* This is an API'ed tool so it's pretty pluggable and easy to use!
* Read Shlomi's blog post about Pseudo GTID Mode http://code.openark.org/blog/mysql/refactoring-replication-topologies-with-pseudo-gtid-a-visual-tour
	* This has been partially built into Orchestrator.  Inspired by some work around re-pointing slaves that Sam Lambert from Github was doing.
	* Allows slave promotion across different masters by using repli

