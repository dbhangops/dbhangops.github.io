---
layout: post
title: '#DBHangOps 06/11/15 -- DBA Expectations and Automation'
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
\#DBHangOps 06/11/15 -- DBA Expectations and Automation
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **June, 11, 2015 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* What does being a DBA mean to you?
  * What are your expectations of a DBA?
* What's the last thing you automated and why?

You can check out the event page at https://plus.google.com/events/ctmk6ua93affd01jnfmm73i68fo on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/7-NEM31NKwQ" frameborder="0" allowfullscreen></iframe>


<a id="show-notes">Show Notes</a>
==========

## DBA Expectations
* What's the role of a DBA at your company?
  * Managing the infrastructure
  * Interacting with engineers and developers on good access patterns with the databases layer
  * In the case of a shared hosting environment, DBAs are also responsible for interfacing with customers and their database-related issues.
  * It also really depends on the size of a team and infrastructure
    * Larger teams may have more specialization on various aspects such as: query tuning, performance, system administration, networking, etc.
* Are you responsible for researching new data stores? Should you become an expert in them?
  * "Do not be in the cave" as a DBA. You need to be open to hearing about new technologies and solutions. What else is out there besides MySQL.
    * While MySQL may have the largest footprint in some shops, you need to be familiar with and comfortable with other datastores for different use cases
  * It's hard to carve out time for looking into new datastores, but you need to.
  * DBAs ask the questions around:
    * How does it scale?
    * For what types of data and access patterns is this best suited for?
    * How do you do backups?
    * How do you manage user access?
    * How do you secure it?
  * If you have a larger team, individuals in the group can specialize or research new solutions.
  * Engagement of your development group also influences this.  Perhaps your engineering organization is comfortable treating MySQL as a simple key-value store and building the application around that assumption.
* What tactics do you take to be involved is decisions for new datastores?
  * Engage in roadmap meetings with stakeholders across your organization
  * Write up blog posts reflecting on new technologies learned about at conferences (E.g. Percona, MySQLConnect)
  * Perhaps embed yourself with your dev teams and meet with them regularly
  * A lot of communication! Meet regularly with team leads to stay in sync and let them know if you've been blindsided by a new datastore you weren't ready for
  * Don't be dismissive of questions about datastores.  These systems will find their way into production.
    * be proactive in providing answers and solutions to questions about storing different types of data.
    * It's important to explain the "Why" for preferring certain datastores over others

## Automation!
* What's the last thing you automated or last bit of automation you setup?
  * For Silvia Botros
    * [Orchestrator](https://github.com/outbrain/orchestrator)!
    * Creating Chef recipes to bootstrap MySQL and orchestrator
    * Silvia also blogged about her experience [Learning Configuration Management as a DBA](https://sendgrid.com/blog/learning-configuration-management-as-a-dba/)
  * For Phil Hildebrand
    * Backups for [Rethink](http://rethinkdb.com/)
      * All backups are done by schema. Needed to write tools to verify that each schema was backed up and restorable
  * For Pim van der Wal
    * A better MySQL upgrade tool
      * Previously, MySQL was upgraded by changing a setting in puppet and having new packages installed.
      * Now having Master<->Master setup, there's a desire for more control in the upgrade process.
  * From Mark Leith's perspective
    * a lot of automation exists for validating, installing, and testing changes in MySQL
      * How does internal Oracle testing automate issues with auto.cnf, user setup, and so on?
    * Most recent automation was: installing the SYS schema by default in new versions of MySQL
  * Automating user management
    * Can easily build something from scratch for this, but curious about other solutions
    * Geoffrey Anderson built a tool to reconcile grants on an instance of MySQL based on a file of grant statements
      * if differences are identified, it can add missing grants, remove accounts that have invalid grants, or both.
      * The grant files are generated using cluster membership information fed from puppet facts
        * Puppet manifests dictate roles for privileges and user membership in the roles
      * LDAP plugins didn't seem to solve the problem well enough which is why this was the path forward
    * Some other places simply have output from `pt-show-grants` that's fed into new instances as they come up.
    * Silvia Botros has a Chef recipe at the moment that defines users and privileges on infrastructure and environment influences which password hashes are used
      * output from `pt-show-grants` is used to validate the unit tests for each environment.
      * This still feels brittle at times so more granluar privileges like column-level privileges are curently avoided
      * Need to verify that schemas all properly exist before creating table and schema level privileges as well.
      * The [database cookbook](https://github.com/opscode-cookbooks/database) has some providers for the interactions in creating the accounts
* Legacy issues that cause some challenges with MySQL automation
  * E.g. mysql_install_db script writes to the binary log by default or mysqldump not dumping user information by default
  * Bootstrapping new MySQL setups across various platforms (Linux, Windows, etc.).
    * Some changes to mysql_install_db have been made to further improve automation of MySQL bootstrapping
    * Challenges in needing a basic password to connect to a fresh instance in order to change the default passwords
  * About a year ago, Oracle focused on improving the RPM/DEB packages and dogfooding it internally
    * Issues and semantics around the various mysql scripts are improving
    * What's challenging is that other distributions of MySQL (e.g. Percona) have different semantics with their packaging
      * E.g. percona packages run mysql_install_db as part of their post install scripts
* Containerizing / Abstraction / Encapsulation of MySQLs
  * Oracle is also starting to provide Docker images.
    * These are used for testing internally at Oracle
    * Interesting learnings around multiple Docker images stacking up on test environments because of port availability
    * Oracle has configured Jenkins to bootstrap a docker image, run all unit tests in the docker image, and then return results to the devs.
      * Much nicer environment isolation with this
    * It's become much easier to "trick" the software in containers since the software assumes it's in its own machine
      * Testing replication has been interesting here, too
      * Can bootstrap multiple Docker images and hook up replication between all the MySQLs in them
      * MySQL Sandbox is also used heavily since you can define a replication topology in a dot file
  * Running MySQL tasks through Apache Mesos is also gaining traction for some companies (e.g. Moz)
    * Definitely some interest in hearing about running stateful daemons via Mesos to see how things will work and having state maintained.
      * Twitter recently open sourced [Mysos](https://github.com/twitter/mysos) for running MySQL on Mesos
    * Easiest method presently is to use local disk and just accept that the workers need to live on the same physical machines
    * Other methods might include mounting a remote network volume or plugging into shared storage. These may have problems with I/O however.

