---
layout: post
title: '#DBHangOps 09/03/15 -- Relax Ops and more!'
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
\#DBHangOps 09/03/15 -- Relax Ops and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **September, 03, 2015 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* How do Ops people reduce ops work?
* How is Ops/DevOps viewed in the workplace?
* "Relax Ops" -- how do you decompress when not working?

You can check out the event page at https://plus.google.com/events/chahiq5eu03e65m9fae2bfh6g70 on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/HLRuI1z2OQo" frameborder="0" allowfullscreen></iframe>

<a href="#show-notes" id="show-notes">Show Notes</a>
==========

## How do Ops people reduce ops work?
* "Automation" obviously...but what do you focus on first?
  * Config management (puppet/chef/etc)
  * finding ways to empower developers and other people you work with
    * Allow developers to make production changes and schema changes to move things along
    * If you can't give access for production changes, provide a method for people to read production data for debugging so you don't need to run queries all the time
  * Spinning up of new machines and databases
  * Orchestrator! Helps make replication changes very easy to make
    * Help provide easy insight into replication topologies for database clusters
* Documentation!
  * Write down answers to common questions
  * What's one of the first things you focus on documenting?
    * Site books
    * Any documents that make things better for DBA and other teams interacting with them
    * Runbooks for remediating alerts
      * If it isn't customer-facing, maybe it doesn't need to be immediately escalated!

## How is Ops/DevOps viewed in your workplace
* A lot of work for co-ownership of uptime and performance
* Empower developers to make config management changes (e.g. chef/puppet)
  * Spend a lot of time educating developers about maintainability, performance, and how to address manual operational tasks
* A lot of shops usually hire a DBA when they're database infrastructure starts to have problems
  * this doesn't necessarily lend itself to the database infrastructure being treated the same as the rest of the infrastructure
  * as much as possible, you should push to have your database environment as similar to other parts of the environments
  * Make if so that youre aren't a SPOF!
* At Booking.com:
  * Mostly all DevOps (though the application is a different team)
  * There's a lot of collaboration between the production and application teams
* At Okta:
  * Mostly a DevOps team
  * Since DBA was initially a contracted role, there's been an evolution to DevOps over time
    * A lot of the SysAdmins are DevOps engineers
  * Figuring out where automation breaks down and how to make the databases more resilient to manual work
  * Is there more about AWS or Chef to be learned to help automate further

## RelaxOps
* how do you decompress? How do you manage your time with the rest of your team/organization?
  * Set your hours and stick to them
  * Turn off e-mail notifications when you're not in the office
  * Work with your team to set boundaries for when you get escalated to
  * Turn off work chat if you're not working! :)
* Different timezones can be challening (but helpful for on-call rotations sometimes!)
* Working remotely can be really challenging
  * You miss out on in-office conversations and chats. This can be stressful.
  * Get a remote presence setup!
    * Get a fancy remote presence robot
    * Setup a persistent Google Hangout
  * Get a dedicated room to be your office so work can stay behind a closed door when you're done
* Manage your time!
* Silvia wrote a blog post about identifying burnout -- http://dbsmasher.com/2015/07/29/on-burnout/
  * Do you find yourself heavily context switching?
  * Are you working late in the evenings or overworking because of timezone differences?
  * Are you taking enough vacation?
* Set an expectation around managing burnout with your team
  * work to remove SPOFs in your organization so people can take breaks
  * Set a cultural expectation to take breaks
* Unlimited time off can be a blessing and a curse
  * Make sure you have expectations around taking your time off
  * If you have unlimited PTO, it's easy to fall into a trap where you don't go on vacation
* Burnout
  * It's okay to be a workaholic as long as your workplace doesn't expect it of you
    * Not all work you do is burn out work. If there's a very engaging 
  * Make sure your work doesn't burn you out
  * Acknowledge your own respsonbilities to help avoid it and make sure other folks can help
  * Working 
* Commiserating with others in your field
  * Sometimes you just need to rant about a crappy thing at work to other people that understand. It's okay! (Just make sure to get back to being productive once it's out of your system)
* Presenting at conferences
  * Share your experiences
  * Find other people who are interested in your solution or experience
  * Help make things better for everyone by sharing knowledge
* Side projects
  * Having time to focus on side projects are a nice decompressor
  * Regular Hackathons to work on fun projects on company time
  * Being able to contribute to open source sometimes
  * Finding overlap in side projects and work projects
* What do you do besides all this to decompress?
  * Spend time with family going outside, watching movies, and more!
  * Dancing!
  * Music festivals and concerts!
  * SLEEP!
  * If you work at home -- anything that gets you out of the house or away from the work computer!
  * Eating a lot of fried food!
  * Go hiking with your dog!
  * Go to meetups with other dogs!
  * Make wine!

## Links of supreme interest!
* Silvia's blog post on burnout -- http://dbsmasher.com/2015/07/29/on-burnout/
* https://vimeo.com/131484322
