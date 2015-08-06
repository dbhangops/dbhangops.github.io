---
layout: post
title: '#DBHangOps 07/23/15 -- Information Security, Database, and you!'
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
\#DBHangOps 07/23/15 -- Information Security, Database, and you!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **July, 23, 2015 at 11:00am pacific (19:00 GMT)**, to participate in the discussion about:

* What does security mean for you?
  * What tools do you use to improve security?
  * What are good security settings for MySQL?
* What does Compliance mean for you?
  * Any useful tools?
  * What are good compliance settings for MySQL?
* Resolving production issues in a secure and compliant way
  * Do you have to change some ways your defenses and tools work for security/compliance?
  * How do you empower developers to debug production issues in a compliant and secure way?

You can check out the event page at https://plus.google.com/events/c8fnre676jji3dfvpenod3e7mj4 on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/lh_QNKjCoSI" frameborder="0" allowfullscreen></iframe>


<a href='#show-notes' id='show-notes'>Show Notes</a>
==========

## What does security mean for you?
* Visibility
  * what happens
  * when it happene
  * where it happened
* Controlling Access
* Security and standards

### Common tools, settings you use, and gotchas
* [Center for Internet Security toolkit](http://benchmarks.cisecurity.org/downloads/show-single/?file=mysql56.100) for MySQL
* Nessus toolkit
  * walks through parts of infrastructure to find compliance violations
* Setup automated user management
  * When you GRANT privileges, do you use wildcard for the host (e.g. `GRANT USAGE on *.* TO 'someUser'@'%'`) or do you put an IP range
  * in newer versions of mysql the username length is increased to 32 characters
  * Password rotations still aren't atomic unfortunately
    * typically create a new account, migrate your applications to it, the remove the old account
* Watch for new CVEs for MySQL
  * Making mysql upgrades easier so CVEs are easy to handle
* What about for companies that are still small but growing into a larger environment?
  * For a lot of places, security starts at the network layer to protect the environment
  * You may not have a security team
* Could consider setting up SSL for your MySQL connections
* Secrets managements
  * https://square.github.io/keywhiz/
  * Locked down config files
  * Custom encryption/salting of passwords in puppet!

## Managing schema migrations securely
* How do you protect against accidental DROP statements (on columns, fields, etc.)
  * Disallow destructive migrations
  * Ensure destructive migrations are rolled out over time
    * Verify applications don't need the table/object anymore
    * Rename the table/object to be removed
    * After a few days, remove the table

## MySQL Upgrade process
* For larger environments
  * May have pools of database servers. Can afford to take a subset of the infrastructure out to upgrade.
* Policy-wise
  * Upgrading for a security bug typically means bringing other upgrade changes in too
  * Need to validate performance of a new version
  * Upgrading several thousand servers can be challenging with different workloads
* How do you make sure a new version is safe?
  * Run in dev or sandbox environments first
  * Grab query logs and run them through pt-log-player (or pt-playback) against the new version of MySQL to identify if the queries perform better or worse
  * Throw new version in a customer read-only path for a little bit. Promote to master afterwards.

## Links of interest!
* [CIS Oracle MySQL Community Server 5.6 Benchmark v1.0.](http://benchmarks.cisecurity.org/downloads/show-single/?file=mysql56.100)
* [OWASP Zed Attack Proxy Project](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project)
* [Percona Warning Suppres Options](https://www.percona.com/doc/percona-server/5.5/flexibility/log_warnings_suppress.html)
* [Keywhiz](https://square.github.io/keywhiz/) - a system for managing and distributing secrets.
