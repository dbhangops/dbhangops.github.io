---
layout: post
title: '#DBHangOps 04/30/15 -- Percona Live 2015 Recap and more!'
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
\#DBHangOps 04/30/15 -- Percona Live 2015 Recap and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **April, 30, 2015 at 11:00am pacific (19:00 GMT)**, to participate in the discussion about:

* Percona Live 2015 Recap
  * MySQL Community award winners!
  * What were your favorite talks? What would you recommend?
  * Did you learn anything new at Percona Live 2015?
  * Overall impression of Percona Live 2015
* How did you get started with MySQL?

You can check out the event page at https://plus.google.com/events/csdu8k7bmdmvinojhrm4dbvdgck on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/5ZNLsRe3HU4" frameborder="0" allowfullscreen></iframe>

<a id='show-notes'>Show Notes</a>
==========

# MySQL SSL/TLS Downgrade vulnerability
* See http://backronym.fail/ for some initial details (there's good links about the vulnerability!)
    * http://mysqlblog.fivefarmers.com/2015/04/29/ssltls-in-5-6-and-5-5-ocert-advisory/
    * http://www.ocert.org/advisories/ocert-2015-003.html
* This is fixed by using a MySQL 5.7.3+ client

# Awesome MySQL
Shlomi is curating an "awesome list" for MySQL software. Check it out at http://shlomi-noach.github.io/awesome-mysql/!


# Events in MySQL
* Pseudo GTID events are used by injecting via mysql events
* mysql events provide some layers of protection
* Booking.com uses the MySQL Event scheduler in MySQL 5.1, 5.5, and 5.6
  * inject heartbeat type statements
  * pseudo GTID statements
* Example heartbeat injection
  * have an insert ON DUPLICATE KEY

    ```
    DROP EVENT IF EXISTS update_heartbeat_event
    DELIMITER $$
    CREATE EVENT
      update_hearbeat_event
      ON SCHEDULE EVERY 1 SECOND STARTS CURRENT_TIMESTAMP
      ON COMPLETION PRESERVE
      ENABLE
      DO
        INSERT INTO heartbeat
        (id, master_ts, update_by)
        VALUES (1, NOW(), 'init')
        ON DUPLICATE KEY UPDATE master_ts=NOW(), update_by=VALUES(update_by);
    $$
    ```

* Some gotchas:
  * These replicate so you'll only want it to run on the master!
  * a new connection is created by the scheduler to get a dedicated connection thread to do its statement
  * What happens if the master is under pressure?
    * An event will continue to fire, regardless of the success of the last event
    * Eventually, you can saturate a databases' connections by having these stack up
    * There *is* a way to protect against this problem however! using `GET_LOCK`!

    ```
    drop event if exists update_heartbeat_event;
    delimiter $$
    create event
      update_heartbeat_event
      on schedule every 1 second starts current_timestamp
      on completion preserve
      enable
      do
        begin
          DECLARE lock_result INT;
          DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;

          /*!50600
          SET innodb_lock_wait_timeout = 1;
          */
          SET lock_result = GET_LOCK('meta_heartbeat', 0);
          IF lock_result = 1 THEN
            insert into heartbeat (id, master_ts, update_by) values (1, NOW(), 'event_scheduler') on duplicate key update master_ts=NOW(), update_by=VALUES(update_by);
            SET lock_result = RELEASE_LOCK('meta_heartbeat');
          END IF;
        end
    $$

    delimiter ;
    ```


## How Pseduo GTID events work
* want to insert random values or unique looking values into the binary log
* With statement based replication, using RANDOM() or UUID() functions, it gets a little dicey to trust that the slave is doing it the same.
* Booking.com's Pseudo GTID events look like: https://github.com/outbrain/orchestrator/wiki/Orchestrator-Manual#pseudo-gtid-via-create-or-replace-view
* Need to remember that when you're promoting a replica to master, the events need to be added to your new master
* It should work with in-order-commit-apply on mysql 5.7
* The question arises -- with transactions that can be executed in parallel on a downstream replica, do we have a guarantee that they're applied in the same order as on the master?
  * If not, there's a chance Pseudo GTIDs will break down.
  * Booking.com is currently benchmarking and testing a lot of MySQL 5.7 to figure this out.
* Why are folks using heartbeat mechanisms? Is it because `Seconds_Behind_Master` is a little sucky?
  * Yes!
    * When `Seconds_Behind_Master` is `NULL`, you don't know how genuninely far behind a replica is
    * the value can be jumpy based on the age of statements

## Links
* MySQL SSL/TLS downgrade issues -- http://backronym.fail/
    * http://mysqlblog.fivefarmers.com/2015/04/29/ssltls-in-5-6-and-5-5-ocert-advisory/
    * http://www.ocert.org/advisories/ocert-2015-003.html
* Awesome MySQL Software -- http://shlomi-noach.github.io/awesome-mysql/
* New Time Series Database from VividCortex -- https://vividcortex.com/resources/webinars/catena/
* YesMark benchmark -- https://github.com/jeremycole/yesmark
* Pseudo GTIDs using Orchestrator -- https://github.com/outbrain/orchestrator/wiki/Orchestrator-Manual#pseudo-gtid
* Allow multiple concurrent locks with `GET_LOCK()` bug --  https://bugs.mysql.com/bug.php?id=1118
* `Seconds_Behind_Master` vs. Absoluate Lag -- http://code.openark.org/blog/mysql/seconds_behind_master-vs-absolute-slave-lag
