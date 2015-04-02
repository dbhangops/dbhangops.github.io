---
layout: post
title: '#DBHangOps 04/02/15 -- Getting Started with PERFORMANCE_SCHEMA and more!'
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
\#DBHangOps 04/02/15 -- Getting Started with PERFORMANCE_SCHEMA and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **April, 02, 2015 at 11:00am pacific (19:00 GMT)**, to participate in the discussion about:

* Getting started with `PERFORMANCE_SCHEMA`
	* What are issues P\_S can help you find and fix faster?
  * How does P_S start to look under load?
* What's the hardest issue you've had to debug?
  * How did it initially manifest?
  * How did you discover it?
  * How did you resolve it?
  * Any bug reports come out of it?
* Percona Live 2015 is coming up! Are you presenting? What are you excited for?

You can check out the event page at https://plus.google.com/events/chc1fg244bbts8jp7r84eg1i3hg on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/vt10rYKiD2g" frameborder="0" allowfullscreen></iframe>


<a href="#show-notes" id='show-notes'>Show Notes</a>
==========

## Getting started with `PERFORMANCE_SCHEMA`
* `PERFORMANCE_SCHEMA` is a new database that was introduced in MySQL 5.5
  * added to allow developers to add instrumentation points in the MySQL server
  * most of the tables are a way to expose the instrumentation points
  * Any tables prefixed with `setup_` are used to enable/disable different instruments
    * `setup_instruments` will determine what's enabled/disabled for monitoring in the server
  * In MySQL 5.5, a lot of global mutex tracking instruments were on by default which added a pretty steep performance impact
    * In MySQL 5.6+, a lot of these instruments are disabled by default to allow lighter weight impact from P_S
  * Some instrument categories:
    * Global locks
    * Stages -- the state of threads that you may see in `SHOW PROCESSLIST` -- e.g. preparing tmp table, etc.
    * Statement tracking -- you can watch for specific types of statements -- e.g. `SHOW...` statements, `DELETE...` statements, etc.
      * `statement/sql/...` instruments actually track the text of queries while  `statement/com/...` tracks counts/latencies of those statement types
      * `statement/sql/...` instruments actually track the text of queries while  `statement/com/...` tracks counts/latencies of those statement types
    * Table IO and locking in the storage engine
  * In MySQL 5.6 there's `events_waits_` and `events_statements_` tables.  For most of these prefixes, there's a summary table and a per-event/per-statement table
    * For the per-statement tables, you'll see timing information (start/end of a statemtn in time), a digest, the full SQLTEXT, which schema it was on, any errors, row changes counts, etc.
        * Also a `NO_INDEX_USED` and `NO_GOOD_INDEX_USED` field which indicates if a index wasn't used to satisfy the query vs. not having an index available to satisfy some joins in a query
    * You can execute queries against `events_statements_current` to see performance inforamtion about queries that are *actively* running on a server (specifically, last statement from active threads)
  * If you want to look at digested/aggregated information about queries on you server, you can look at `events_statements_summary_by_digest`
    * The structure is similar to `events_statements_current`, but the records are rolled up by the `DIGEST_TEXT` field
    * `SELECT * FROM events_statements_summary_by_digest ORDER BY sum_timer_wait LIMIT 5\G` could be used to find statements that are spending a lot of wait time for example.
  * `table_io_waits_summary_by_table` will provide table-level information about IO waits
    * `SELECT object_schema, object_name, count_star, sum_time_wait  FROM table_io_waits_summary_by_table ORDER BY sum_timer_wait DESC LIMIT 10` would show an ordering of top table IO usage.
      * You can find your heaviest used tables and track down why they're so heavily used by querying the other fields in the `table_io_waits_summary_by_table`
  * `file_summary_by_instance` -- you could see which physical datafiles are observing the most latency
  * You can typically issue a `TRUNCATE` statement against any P\_S tables in order to "reset" the data in them.
    * These statements will *not* replicate to downstream replicas, so you'll need to do this on all machines in a replication topology
  * *All of the P\_S data is collected in memory and doesn't required a file mutex lock (like the slow query log does).*
* `SYS` is another schema that is provided to help simplify interactions with `PERFORMANCE_SCHEMA`
  * `SYS` has one table (`sys_config`), the rest of the objects in `SYS` are views
  * Configuration for monitoring is done via the `SYS.sys_config` table
    * Be aware that changes to this table will replicate to your downstream replicas
  * views in the `SYS` schema will make things more human readable by leveraging data in `PERFORMANCE_SCHEMA`
    * e.g `SELECT * FROM sys.statements_with_temp_tables LIMIT 5\G` would give you a list of statements on the server using temporary tables, including statistics about how many temporary tables happen, how often they happen, and so on.
  * `schema_table_statistics` collects P\_S data about table usage and I/O and presents it in an easily consumable view.  You can gauge how much time is spent inserting/updating/reading from a table.


### Some new `PERFORMANCE_SCHEMA` tables in MySQL 5.7+
* `events_transactions_current` -- information about in flight transactions, their isolation levels, and so forth
  * You can link statements to records in this table using the `NESTING_EVENT_*` fields
* `global_status` and `global_variables` -- this is data that 
* `status_by_` tables show status counters by a given aggregate
  * e.g. `status_by_user` allows you to see all these counters on a per-user basis
  * e.g. `status_by_thread` allows you to see all these counters on a per-connected thread
* `metadata_locks` -- displays all current metadata locks on the server at a given moment
* `memory_summary_` tables report information about types of memory interactions, allocations, and high/low watermarks
  * The `SYS.memory_global_by_current_bytes` table is an excellent view for looking at this
  * these memory instrument tables wrap mallocs in the server to increment counters so that querying this data is pretty cheap
    * Seriously...this is pretty cheap and awesome to see!
* `replication_` tables collect output from something like `SHOW SLAVE STATUS` and stores it in a normalized set of tables
  * with the addition of multi-threaded slaves and programmatic interactions with them, the `SHOW SLAVE STATUS` command couldn't serve as well
  * E.g. `replication_applier_status_by_worker` displays information about each worker thread for replication
  * E.g. `replication_connection_status` provides information about each IO thread connected for replication (to support multi-master replication)
  * Since all replication threads are simply threads on the server, you can query other P\_S tables to see information about why those threads may be slowing down or having trouble
  * There's plans to add a `busy_timer` type field in the `replication_applier_status_by_worker` so it'll be easier to get information about how busy replication threads are.


### Awesome links
* `pstop` - https://github.com/sjmudd/pstop
  * Top-like tool that queries `PERFORMANCE_SCHEMA` and shows a live status of what's happening in a server
  * Seriously...this is an amazing tool!

