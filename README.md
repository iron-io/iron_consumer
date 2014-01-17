This is a special way to make a worker that runs for a while and pulls off IronMQ.

Benefits:

- no load times so faster and cheaper
- can run locally and remote in the same way
- HUD could have easy editor (usersetup and usercode text boxes)

Can use with scheduler or alerts.

## Usage

First thing is to get things running locally.

To do that, make three files, `iron.json`, `usersetup.rb` and
`usercode.rb`. OR to make this all faster, go git clone this repository and just modify the files:
https://github.com/iron-io/iron_consumer_starter

### iron.json

This is a normal Iron.io config file and should contain your project id and token (you can download this from
HUD if you want).

```json
{
    "token": "X",
    "project_id": "Y"
}
```

### usersetup.rb

Put all your stuff in here to setup the worker such as making database connections, api clients, etc. Put them
into the special hash called `connections` (todo: should that have a more generic name?). For example:

```ruby
require 'mongo'
require 'twilio-ruby'

db = Mongo::MongoClient.from_uri("mongodb://username:pass@x.mongolab.com:12345/tester")
# Put this into the special connections map
IronConsumer.connections['mymongo'] = db.db()
```

### usercode.rb

This is where you'll write the code that actually does the work. The message will be available with
`IronConsumer.message` and this will be a normal IronMQ message from the iron_mq gem.

Typically you'll parse the message body and then do your thing. For example:

```ruby
puts "Got message"
puts IronConsumer.message.body

# transform body or generate something or do whatever
username = "Travis" # Would normally get this from database for user
body = IronConsumer.message.body.gsub("#NAME#", username)

# Now post this new stuff into the database.
IronConsumer.connections["mymongo"].collection('msgs').insert({'body' => body})

# And/or send email, post to social media, send notifications to mobile phone, etc.
```

## Running locally

Just create a simple file called `local.rb` and put this in it:

```ruby
require 'iron_consumer'
IronConsumer.run('my_queue')
```

Once you've got it working, just upload it to IronWorker.

## Upload to IronWorker

Run `iron_worker upload consumer` to get your code onto the IronWorker system.

## Now queue up messages from wherever.

```ruby
require 'iron_mq'

mq = IronMQ::Client.new()
# Same queue name you are reading from
qname = "testq"
queue = mq.queue(qname)
msg = {
    "mystring" => "Hello #NAME#!"
}
queue.post(msg.to_json)
```



