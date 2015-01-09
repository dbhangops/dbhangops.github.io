---
layout: post
title: '#DBHangOps 01/08/15 -- MySQL Event Scheduler, Compression, and more!'
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
\#DBHangOps 01/08/15 -- MySQL Event Scheduler, Compression, and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **January, 08, 2015 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* MySQL Event Scheduler
* More compression!
* What is everyone's understanding of `innodb_io_capacity`?

You can check out the event page at https://plus.google.com/events/cb7pdn3egenc6c79lc4bc74kr04 on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/mz-379Bna5E" frameborder="0" allowfullscreen></iframe>


<a href="#show-notes">Show Notes</a>
==========
# Compression
## TokuDB compression
* Quick review of TokuDB data structures
  * Fractal Indexes in TokuDB are essentially a B+ Tree
  * Compression was added after the original design was completed for this storage engine
  * Fractal tree nodes are *very large*.
    * This makes for great compression benefits
    * By default, all nodes are 4MB (InnoDB pages are 16KB) and the same size (root nodes *and* leaf nodes)
      * As a result of spinning disks, this was the preferred size to better utilize disk bandwidth (circa 2008-2009)
  * What's in a fractal tree leaf node?
    * the first byte of a node's header is a byte to indicate compression algorithm (e.g. QuickLZ, LZMA, SNAPPY)
    * The header also contains record ranges and offsets in the existing page (pointers to "basement nodes")
    * Entire rows are stored inline in "basement nodes" (InnoDB stores a portion of records inline)
    * MVCC data is stored inline (InnoDB does something else...)
    * Why "Basement nodes"?
      * If running a point query, TokuDB only needs to fetch a basement node (64KB compressed by default) instead of the whole 4MB node
* Compression in TokuDB!
  * it's a simple 2 step process:
    * Compress each basement node (this can be done in parallel)
    * Write out a leaf node
      * compress basement nodes into a continues byte stream and create a new header with updated offsets for the compressed basement nodes
  * After compression happens, the compressed nodes are written as-is (e.g. a compressed node that is down to 1MB is just written. No standardized compressed format is written)
  * Lessons Learned
    * Rotating disks
      * Higher compression is usually a win
      * The cost of an IO (milliseconds) is far greater than the cost of decompression (microseconds)
      * Having a basement node of 64KB or 128KB with LZMA/ZLib compression is usually a huge savings
    * SSDs
      * The cost of an IO (microseconds) might be less than the cost of decompression
      * QuickLZ or SNAPPY compression and a 16KB basement node is probably better here
        * Depends more on the workload

## Quick InnoDB Compression Comments
* How does InnoDB manage storing rows inline?
    * It depends on the storage engine version.  In Barracuda:
        * if the row fits in the it'll be stored inline.  If data can't fit inline, it'll punt it off-page (e.g. BLOB fields) and leave a 20-byte pointer to the off-page data
* InnoDB Compression Future
  * Using filesystems that support sparse files to allow for transparent page compression
    * Newer versions of Ext4, ZFS, XFS, and NTFS should support this
  * Transparent page compression eliminates complexity around key block sizing with your page size
  * InnoDB will be able to set punch hole support for any compressed data pages it's writing out which saves on disk usage
    * This will give better performance and make InnoDB's compression configuration a lot easier.

## Links
* BLOB storage in InnoDB -- http://mysqlserverteam.com/externally-stored-fields-in-innodb/
* Some more details on InnoDB compression internals -- http://dev.mysql.com/doc/refman/5.6/en/innodb-compression-internals.html
* MySQL's Change buffer and how to change its max value -- https://dev.mysql.com/doc/refman/5.6/en/innodb-parameters.html#sysvar_innodb_change_buffer_max_size
* "What defaults would you like to see changed in MySQL 5.7" -- http://www.tocker.ca/2015/01/05/what-defaults-would-you-like-to-see-changed-in-mysql-5-7.html
