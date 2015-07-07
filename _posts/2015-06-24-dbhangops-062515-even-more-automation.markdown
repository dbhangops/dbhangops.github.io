---
layout: post
title: '#DBHangOps 06/25/15 -- Even More Automation!'
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
\#DBHangOps 06/25/15 -- Even More Automation!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **June, 25, 2015 at 11:00am pacific (19:00 GMT)**, to participate in the discussion about:

* What's the last script you wrote? Why?
* What's the last tool you wrote? Why?
* What's your most valuable or most used tool/script that you've developed?
* What's the first script/tool you get or build at a new job?

You can check out the event page at https://plus.google.com/events/c47c6h7c1jgl3ifptev1pnmrf5s on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/WZvrGVfXWGw" frameborder="0" allowfullscreen></iframe>


<a href='#show-notes' id='show-notes'>Show Notes</a>
==========
## What's the last script you wrote? Why?
* Shlomi wrote a script that checks that event scheduler is running correctly on DBs
* Geoff wrote a script to supply tab-completion to tools for connecting to various MySQL instances in his environment
* Pim wrote a script to do a quick analysis of databases in his environment
* Silvia wrote an updated cookbook to manage a new cluster in her environment
  * There's an in-house cookbook for setting up various OS-level settings for MySQL nodes
  * Schemas are packaged into RPMs and deployed to machines. There's a tool to load the schema into a MySQL
  * Chef cookbooks simply install this package and can load them

## Schema management and automation
* Acquia runs a lot of Drupal, so schemas are handled by the Drupal package already
* Box has a schema migrator tool that's tied to their application and will help a DBA deploy the schema changes. `pt-online-schema-change` is still hand-run by DBAs to apply some schema changes.

## Script lifecycle
* How does script promotion work? Is it done after you've written it or does it get rewritten?
  * At Box, the DBAs have their own code framework that's well-tested and provides components for programmatically accessing the MySQL infrastructure.
    * Various shell scripts are written and may wrap some of these tools. These stay and might be converted into a more well-tested program in the code framework as issues are discovered or features are requested.
  * At SendGrid there's a hand-off of some tools from the DBA to the engineers based on how much testing and iteration is required.  For the most part, a lot of things are automated in chef and scripts
  * For Shlomi, he's more development focused right now than operationally focused.
    * Once a script reaches a big enough size, it needs to be promoted to "engineering-grade" code.
    * If the script gets beyond "if-else-then" work it's usually time to move to more managed language to test and validate it
* A challenge with turning over scripts to development teams is that a DBA may no longer have ownership of the code
  * This can make it more challenging to patch bugs or add new features to the program

## What's the first script/tool you get or build at a new job?
* get stats from everything in yoru environment
* setup your dotfiles and base configs
* generate CLI graphs using gnuplot

