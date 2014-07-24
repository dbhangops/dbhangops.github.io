---
layout: post
title: '#DBHangOps 07/24/14 -- More Indexing!'
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
\#DBHangOps 07/24/14 -- More Indexing!
=========================================================

All done for this week!  Check out the recording below:

<iframe width="420" height="315" src="http://www.youtube.com/embed/Mrcg2eLjFJo" frameborder="0" allowfullscreen></iframe>

Hello everybody!

Join in \#DBHangOps this Thursday, **July, 24, 2014 at 11:00am pacific (18:00 GMT)**, where we pick up on our [last conversation about indexing](http://dbhangops.github.io/2014/07/08/dbhangops-071014-mysql-index-types/):

* Indexing
	* More discussion on geo spatial indexes
	* Fulltext indexing and ranking
	* MariaDB indexing features (From Gerry!)
	* Anything else indexing!

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!


<a name="show-notes">Show notes</a>
==========

## Change Buffer and B+ Trees
* Very cool visualization tool of how B+Trees work can be tried out at http://www.cs.usfca.edu/~galles/visualization/BPlusTree.html
* B+Trees typically stay 3-4 levels deep so that you don't have to scan too far down
	* As a result, you sometimes have a lot of leaf pages that may not it in memory. This is where MySQL's Change Buffer comes into play
	* Using the change buffer, InnoDB can keep a change log of modifications for an index page and defer the change until the page is loaded into memory
	* During idle/background cycles, innodb will apply any change buffer changes that have not yet been applied
	* The change buffer only works for non-unique indexes (Secondary indexes)
	* Variables that help influence this setting are:
		* innodb_io_capacity -- this influences innodb decisions around disk operations. You should set it up based on how much IO your system has available.
		* innodb_change_buffering -- this influences what types of statements can be put into the change buffer

* Multiple Buffer pool instances
	* Change buffer and works well with multiple buffer pool instances. Things are hashed across the change buffer as well.
	* What's a good number of buffer pool instances?
		* 8-16 seems like a good number but your mileage may vary!
		* You can have a maximum of 64!

## Clustered vs. Non-clustered indexes
* What are they?
	*Non-clustered indexes
		* You have an index that simply points to records inside of a table.
		* You can have multiple indexes that point to the same pieces of data
	* Clustered index
		* The leaf nodes of a clustered index include the data right with the index (no pointers)
		* InnoDB stores table data in a clustered index (primary key)
* Secondary indexes in MySQL are non-clustered indexes
	* Keep in mind that unless your secondary index covers/satisfies all the fields of a query, you're incurring a cost to do a Primary Key lookup as well
* InnoDB provides a feature called the Adaptive Hash
	* This is a quick lookup structure to avoid traversing the secondary index
	* There can be some mutex contention on this structure in busy enough workloads
* Warning! If you don't define a Primary Key, InnoDB will automatically make one for you
	* There's a shared structure that is used to watch for PK increments for tables that don't have a defined primary key. This could be a point of contention!
	* AUTO_INCREMENT has been improved over the years to deal very well with contention  issues!
