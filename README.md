# github-notify-mush - Sinatra application for notifying MU*s about Github commits
## By Tim Krajcar - allegro@conmolto.org

This is a simple, easy-to-deploy Sinatra application that is designed to take post-push notifications from [Github](http://www.github.com/)
and log on to a MU* (designed for PennMUSH, but easily adapted to others) and notify a channel about the commit(s) that have been pushed.

Sample output:

![example](http://i.imgur.com/d2S5C.jpg)

## Installation Steps
1.  [Install Ruby](http://www.ruby-lang.org/en/downloads/).
2.  Install bundler via `gem install bundler` if you don't already have it.
3.  Download the latest package from https://github.com/tkrajcar/wcnh_gitnotify/downloads and extract it somewhere.
4.  In that extracted directory, run `bundle install` to install Sinatra and dependencies.
5.  Set up the MUSH-side player to login to - `@pcreate Gitbot=mypass`, `@power *gitbot=cemit hide`, etc.
6.  Set up the MUSH-side channel - `@chan/add Git`, `@chan/on git=me gitbot`
7.  Copy `config.rb.dist` to `config.rb`, and edit it to have the correct parameters that you just set up.
8.  Test and make sure everything's working by running the web app locally: run `rackup -p 9292 config.ru` and,
    in another window, run `ruby test.rb` (edit `test.rb` if you change ports or for some reason aren't running it on localhost
    first!) If everything is working, the bot should log in and @cemit a few sample commit notices. If you don't see this, check the window you ran `rackup` in
    and look for exceptions, check your MUSH log files to see if it tried to connect, etc.
9.  Deploy the Sinatra application to whatever webserver you want to use it on, run `test.rb` against the 'live' URL to make sure it works, and then log into Github,
    go to the repository you want to report commits to, go to 'Admin', go to 'Service Hooks', select 'Post-Receive URLs', and add your live URL. Hit 'Test Hook' and you should get notified!
    You can have multiple repositories hitting the same URL - the bot reports the repository name as part of its process.

## Deploying on Heroku
This app works just fine on Heroku (that's where I run it). Since Heroku doesn't support non-Gitted files, you can't use config.rb, but the code looks for Heroku
environment variables if present and uses those instead.

So, run this:
`heroku config:add GITHUB_NOTIFY_HOST=mymush.com GITHUB_NOTIFY_PORT=4201 GITHUB_NOTIFY_CONNECT_STRING="ch Github mypass" GITHUB_NOTIFY_CHANNEL=Git`

Then check with `heroku config` and make sure everything's set.

## Support
I'm Eratl @ `M*U*S*H` and can be reached by email as well, and will be happy to help as time and energy allows if you have issues.

## License
Copyright (c) 2011 Tim Krajcar - allegro@conmolto.org

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.