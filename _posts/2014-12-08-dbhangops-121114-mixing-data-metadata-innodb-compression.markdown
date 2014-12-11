---
layout: post
title: '#DBHangOps 12/11/14 -- Mixing Metadata with Data, InnoDB Compression, and more!'
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
\#DBHangOps 12/11/14 -- Mixing Metadata with Data, InnoDB Compression, and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **December, 11, 2014 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* Mixing Metadata and Data (requested by Shlomi Noach)
  * E.g. schema representing some data instead of metadata
* InnoDB Compression (requested by John Cesario)
  * How did you performance tune it for MySQL 5.6?
  * Expected metrics changes when enabling it
  * Overall performance with InnoDB compression enabled vs. disabled
  * Comparing TokuDB and InnoDB compression

You can check out the event page at https://plus.google.com/events/cmiu31cksfj21t4b196hg7mi7jg on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/WvuqhIrEYFs" frameborder="0" allowfullscreen></iframe>


<a id="show-notes">Show Notes</a>
==========
## Mixing Data and Metadata
* sometimes you're forced to mix some of this data
  * Views in MySQL or triggers
    * these are created and run on behalf of the user that created them
    * When dumping your schema or data, you don't want to know about this user account.
      * running a mysqldump and then loading it into another server may fail because the user account doesn't exist on a new server
        * If you create all your views/triggers as the root@localhost account, you may avoid these problems
        * The flipside is that root@localhost has A LOT of privileges, not a limited set
    * Ultimately, metadata around your data gets exported with it all the time
    * If I create a trigger, it's forever owned by my user account or "root@localhost"
    * It just...bothers Shlomi!
	  * How could we improve this?
	    * Maybe have it run the same way the event scheduler does -- it just runs as the 'mysql' user.
	    * It almost feels like the entire security model might need to be changed
	    * Maybe making these objects more apart of the application schema than the mysql routines table
	  * How do others deal with this?
	    * Some people just don't use stored routines at all!  The instruments needed to properly monitor their performance are mostly non-existent until newer version of MySQL (5.7+)
	    * Views are definitley used more in general.  For example, common\_schema uses views to supply a lot of helpful functionality.
  * There's a bunch of stuff that people may do that ties their data to MySQL specifically
    * Table partitioning depends on your data to influence the metadata for patitioning
    * Changes you'll make to your data access patterns may be dependent on the data in your schemas
      * These are ultimatley leaky abstrations. Read Baron Schwartz's Blog post about MVCC and the associated links off it at http://www.xaprb.com/blog/2014/12/08/eventual-consistency-simpler-than-mvcc/

## InnoDB Compression
* Introduced in MySQL 5.0 (or 5.1) with the InnoDB plugin
* Every company has talked about compression at some point because it helps you save money on expensive storage (like solid-state drives!)
* Some compression issues/gotchas
  * Appears to be a big hit on write latencies sometimes
  * Also some rough stalls in InnoDB sometimes
* If you can afford some looser SLAs around your writes, then this is probably okay, overall
* Standard InnoDB page size is 16K.
  * You can set the "key block size" for InnoDB compression to a value that will encourage it to pack into a smaller page size
    * e.g. setting this value to "4" would be trying to pack innodb data into a 4kb page
* Getting good performance out of InnoDB compression, you really need to know your data
  * If innodb can't meet the key block size you want, it'll have to recompress at a higher size (a "compression miss")
    * a compression miss will result in higher CPU
  * INFORMATION\_SCHEMA.INNODB\_CMP is the table that'll have information around compression in InnoDB.
* In TokuDB, compression is enabled by default.  All benchmarks are always run with compression to be on.
* Something interesting that was added in MySQL 5.6 was "dynamic padding"
  * "dynamic padding" helps with heuristics around compression.  If there's a lot of compression misses, MySQL will pad pages in the table with empty space to help data fit.
  * The downside of this is that the full 16K data block needs to go into memory, so you'll have some "empty space" when in memory
* When working with compressed innodb tables, some portion of the buffer pool is reserved for compressed pages and some is for regular pages
  * To minimize IO, at times the buffer pool will containt both compressed and uncompressed pages.
  * Compression's hard!
* Direct I/O provides the most consistent performance.  For workloads where there are a lot of reads as opposed to writes, then more spindles and memory can allow for OS caching of the compressed data
* Compression is slower, yet your CPUs may not be 100% utilized sometimes so is compression still being efficient?
  * the actual compression part isn't what's slowing it down.  There seems to be other mutexes happening inside InnoDB that slow down things.
  * The LRU pending flush list and other buffer pool mutexes showed some increased locking when compression was enabled
  * How do we solve this problem?  Storage is always expensive, so getting these efficiencies is ideal.
    * the "compression miss" problem is probably a significantly large portion of this.
* Some of the challenges with "hole punching" in file systems (which allows for simple padding in InnoDB pages) arise operationally:
  * More info can be read up at https://wiki.archlinux.org/index.php/sparse_file
  * Things get weird with os level tools for file management (e.g. cp, mv, ls, etc.)
* What compression libraries are used?
  * In MySQL 5.5 and 5.6, compression defaults to ZLIB
    * Newer labs releases allow you to specify LZ4
  * TokuDB supports a wider array of compression libraries (dynamically changeable!):
    * ZLIB
    * LZMA
    * QuickLZ
    * SNAPPY is being benchamrked right now
* Some helpful reading around compression:
  * http://mysqlserverteam.com/innodb-transparent-pageio-compression/
  * http://dev.mysql.com/doc/refman/5.6/en/innodb-cmp-table.html
  * http://dev.mysql.com/doc/refman/5.6/en/innodb-compression.html
  * http://dev.mysql.com/doc/refman/5.5/en/innodb-compression-internals.html
  * http://www.xaprb.com/blog/2014/12/08/eventual-consistency-simpler-than-mvcc/
  * https://wiki.archlinux.org/index.php/sparse_file


