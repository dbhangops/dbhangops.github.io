---
layout: post
title: '#DBHangOps 05/28/15 -- Deep Engine and more!'
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
\#DBHangOps 05/28/15 -- Deep Engine and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **May, 28, 2015 at 11:00am pacific (19:00 GMT)**, to participate in the discussion about:

* Deep Engine presentation by Mike Skubisz! (Come with questions!)
* ~~What does being a DBA mean to you?~~
  * ~~What are your expectations of a DBA?~~
* ~~What's the last thing you automated and why?~~

You can check out the event page at https://plus.google.com/events/cgomeasl8m4fr47tl25e74rvh9g on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/SVc3fU_a7PU" frameborder="0" allowfullscreen></iframe>


Show Notes
==========
# Deep Engine
* Company was started about 4 years ago. Wanted to tackle the problem of scaling up modern database infrastructures as hardware has improved
* Also wanted to tackle the science about the storage technology to improve things. Kudos to TokuDB with their Fractal Index work

## Legacy Sciences
* log files -- optimized for write optimized work loads
* B+ Tree -- optimized for reads
* LSM Tree -- write optimized
* Typically engines are optimized to support specific workloads
    * read/write optimization
    * tree width/depth
* Ultimately, a lot of these are very rigid in their implementations which is why there's so many options to use

## Rethinking Sciences of Databases
* can we redefine data structures during runtime to improve performance
    * Optimize key size and space usage on the fly
    * have storage algorithms be tolerant of these changes
    * dynamically changing page sizes
* Continue to be ACID compliant while solving these storage challenges

## CASSI: Adaptive Structure/Algorithm
* Continuous Adaptive Sequential Summarization of Information
* storage to disk doesn't use pages like other traditional storage engines. Data is written as append-only log files
    * DeepIS has some patented methods to avoid painful locking behavior while maintaining a denormalized copy of statistics for tables in their engine
    * You can effectively get a `SELECT COUNT(*)...` in constant time without added locking pain or full scans
* DeepIS effectively treats their engine as a "Segmented column store"
    * There's multiple segments of individual parts of the total keyspace to support storing this data
    * How's this handle the issue where data wouldn't be uniformly distributed across keyspace?
        * The adaptive algorithm work in Deep Engine is what helps with this. In the background, data is re-organized/defragmented to help improve this.
        * Live data can still be manipulated while these background tasks are happening to improve data access
        * As a result of this, you don't need to worry about doing "OPTIMIZE TABLE" operations and such since the engine is always restructuring the underlying data.
        * In the directory on the filesystem, there's multiple files for each index and table data to support adaptive changes to the underlying storage objects.

## CASSI Benefits
* Secondary indexes have a pointer back to the primary index *and* to the actual data on disk
    * This sounds like a lot of I/O, both during writes and during normal (idle) operation
        * Disk flushing dynamically changes for grouping writes based on the velocity of writes coming into MySQL
        * Since there's a single data structure here (append-only file), grouping allows for coalescing of operations too
        * Write amplification of 1 since this isn't page-based storage
        * A lot of seeks (I/O operations!) are removed due to being append only
    * How's garbage collection handled since this is append only?
        * A statistic about a segment's level of fragmentation is kept.  This allows for decisions to defragment a segment if it's getting to heavy.
        * Initial data is written uncompressed as well and then a segment re-write will compress it.
        * After defragment operations complete, older segments can be either archived, or purged and cleared out.
        * As a result of the append-only structure too, rollbacks are pretty cheap and can go to any point in time.
* This sounds kinda like PBXT (https://mariadb.com/kb/en/mariadb/about-pbxt/)

## Deep Engine
* lightweight plug-and-play storage engine (~10MB) for MySQL.
* designed as an alternative to InnoDB/XtraDB storage engines as an application/schema compatible storage engine
* A lot of data about statistics are exposed via `INFORMATION_SCHEMA`
    * there's plans in the future to push data into `PERFORMANCE_SCHEMA`, but that's not present yet.
* Were you able to break the single-core per query
    * DeepDB is still behind the MySQL optimizer, so that's pegged to a single core.  Data retrieval *can* be parallelized in the storage engine, but isn't just yet.
* How's this play along with MySQL replication
    * At present, there's no changes to how replication works beyond the engine being able to persist data pretty quickly
    * Replication lag may be lower since the engine is faster at writing data in due to the append-only structure)
* Backups
    * Since everything is an append-only structure, you can use normal filesystem tools to backup (e.g. `rsync`)
    * Even with multiple files for indexes and data, the engine should be able to rebuild them up to the newest checkpoint.  Recovery mode should be pretty quick based on the velocity of data that came in.
* Feel free to grab a development version and mess around with the engine at http://deepis.com/downloads!

