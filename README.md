lighthouse_cli
===============

A quick command line interface to lighthouse. The goal is to reduce overhead of tracking tickets inline with normal workflow. The effect is achieved by setting conventions.

Install
--------

Add github to gem sources unless you've done that before

  sudo gem sources -a http://gems.github.com
  sudo gem install maxim-lighthouse_cli


Usage
------

1. Create Lhcfile in your project with the following yaml content (either user/pass or token, no need for both):
  
        account:
          example_account
        project:
          example_project
        # username:
        #   foo
        # password:
        #   bar
        # token:
        #   baz

2. Add Lhcfile to .gitignore (avoid committing your token/password).
3. Run lh help to get started.

Contact/Contribute
-------------------

If you'd like to comment on something -- I'm [@hakunin](http://twitter.com/hakunin) on twitter.
My [blog](http://mediumexposure.com) has more ways to reach me. 
For contributions simply fork, change, commit, send me pull requests.

Copyright
----------

Copyright (c) 2009 Maxim Chernyak. See LICENSE for details.
