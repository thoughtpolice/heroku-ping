# heroku-ping: keep your heroku websites alive

Like some people, I use heroku to keep my homepage
alive. Unfortunately, the heroku dynos are powered down if they don't
get requests in a certain amount of time, meaning visitors to your
site often experience a nasty delay.

This is a heroku application that pings a URL every 20 minutes to fix
that. No more, no less.

# Usage

Clone the repo, create an app.

```bash
$ git clone https://github.com/thoughtpolice/heroku-ping.git
$ cd heroku-ping
$ heroku create ping-MYAPP
Creating ping-MYAPP... done, stack is cedar
http://ping-MYAPP.herokuapp.com/ | git@heroku.com:ping-MYAPP.git
Git remote heroku added
```

Now add the URL of the heroku application you want to ping using the
`PING_URL` environment variable.

```bash
$ heroku config:add PING_URL=http://MYAPP.herokuapp.com
Setting config vars and restarting ping-MYAPP... done, v3
PING_URL: http://MYAPP.herokuapp.com
```

Now push, and scale the worker to 1 instance.

```bash
$ git push heroku master
...
-----> Ruby app detected
-----> Installing dependencies using Bundler version 1.3.0.pre.5
...
-----> Discovering process types
       Procfile declares types -> worker
       Default types for Ruby  -> console, rake
-----> Compiled slug size: 688K
-----> Launching... done, v5
       http://ping-aseipp.herokuapp.com deployed to Heroku
...
$ heroku ps:scale worker=1
Scaling worker processes... done, now running 1
```

You're done. Now your web application will be kept alive! You can make
sure it's working by checking `heroku logs`.

# Join in

Be sure to read the [contributing guidelines][contribute]. File bugs
in the GitHub [issue tracker][].

Master [git repository][gh]:

* `git clone https://github.com/thoughtpolice/heroku-ping.git`

There's also a [BitBucket mirror][bb]:

* `git clone https://bitbucket.org/thoughtpolice/heroku-ping.git`

# Authors

See [AUTHORS.txt](https://raw.github.com/thoughtpolice/heroku-ping/master/AUTHORS.txt).

# License

MIT. See
[LICENSE.txt](https://raw.github.com/thoughtpolice/heroku-ping/master/LICENSE.txt)
for terms of copyright and redistribution.

[contribute]: https://github.com/thoughtpolice/heroku-ping/blob/master/CONTRIBUTING.md
[issue tracker]: http://github.com/thoughtpolice/heroku-ping/issues
[gh]: http://github.com/thoughtpolice/heroku-ping
[bb]: http://bitbucket.org/thoughtpolice/heroku-ping
