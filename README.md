# Eet
[![Build Status](https://travis-ci.org/ucetnictvi-on-line/eet.svg?branch=master)](https://travis-ci.org/ucetnictvi-on-line/eet)

Hi everybody! This is Ruby wrapper for [Czech registration of sales system - EET](http://www.etrzby.cz/cs/index)

If you want to help Czech republic avoid bankruptcy please register all your cash registers and have fun!

## Installation

You know how to install a gem right? Ok..

## Usage

Let's see some demo first. Fire up your console and type:

```ruby
require 'eet'

puts Eet.test_playground.body
```
You should see something like this:
```shell
=> {:odpoved=>{:hlavicka=>{:@uuid_zpravy=>"e21047f2-185d-4f58-a3ca-52679f8c3cb2", :@bkp=>"677503F4-58C5AE1E-0101736A-450F4D7C-31ABAED9", :@dat_prij=>"2017-03-14T21:45:27+01:00"}, :potvrzeni=>{:@fik=>"00dc6277-be9d-4bbb-9824-9fad513168ea-ff", :@test=>"true"}},
 :"@wsu:id"=>"Body-b64214c0-cf1c-42e1-91ec-495c34c27e65"}
```

**Cool right!? You just sended your first message to EET playground and got back some fik!** That means it's not that hard and you can do it. Now follow me:

### Real usage

#### using Eet::Client

##### using #submit

```ruby
require 'eet'

data = { celk_trzba: '0.00',
         dic_popl: 'CZ00000019',
         id_pokl: 'p1',
         id_provoz: '11',
         porad_cis: '1' }

certificate = OpenSSL::PKCS12.new(File.open('EET_CA1_Playground-CZ00000019.p12'), 'eet') # (substitute your path and password)

client = Eet::Client.new(certificate, data)
client.submit(:playground) # or :production
```

##### using #prepare_message and #register

```ruby
require 'eet'

data = { celk_trzba: '0.00',
         dic_popl: 'CZ00000019',
         id_pokl: 'p1',
         id_provoz: '11',
         porad_cis: '1' }

certificate = OpenSSL::PKCS12.new(File.open('EET_CA1_Playground-CZ00000019.p12'), 'eet') # (substitute your path and password)

client = Eet::Client.new(certificate, data)
client.prepare_message

client.message.pkp
client.message.bkp

client.register(:playground)
```

Always make sure to call prepare_message before register. Calling register
before prepare_message raises MessageNotPrepared exception.

#### using individual classes directly

First you of all you need to create a EET message:


```ruby
require 'eet'

message = Eet::Message.new

# Now to set message attributes use classic:
message.celk_trzba = '100.00'
message.dic_popl = 'CZ00000019'
message.id_pokl = 'p1'
message.id_provoz = '11'
message.porad_cis = '1'

# or pass a hash to #new method as you would do with ActiveModel model:
message = Eet::Message.new({ celk_trzba: '0.00',
                             dic_popl: 'CZ00000019',
                             id_pokl: 'p1',
                             id_provoz: '11',
                             porad_cis: '1' })
```

Attributes above are the basic ones you always need to provide to form valid message. Without these the message won't be valid and you won't get any fik back. Setting other attributes works the same. Visit [official EET documentation](http://www.etrzby.cz/cs/technicka-specifikace) for theirs full list.

To create and set security codes(pkp & bkp) use Utils module:
```ruby
certificate = Eet.playground_certificate

message.pkp = Eet::Utils.create_pkp(message, certificate)
message.bkp = Eet::Utils.create_bkp(message.pkp)
```

To sign the message:
```ruby
signed_message = Eet::Utils.sign(message.to_xml, certificate)
```

And finally, to send a message:
```ruby
sender = Eet::Sender.new
response = sender.send_to_playground(signed_message)
```

And that's it! This is the same code used inside of `Eet.test_playground` method. Now inspect response body to get your fik!

When you are ready to switch to production just use the `::send_to_production` method:
```ruby
sender = Eet::Sender.new
response = sender.send_to_production(signed_message)
```
But you will need to create security codes and sign the message with your own certificate. Certificate has to be `OpenSS::PKCS12` instance which you can initialize like this:
```ruby
OpenSSL::PKCS12.new(File.open('EET_CA1_Playground-CZ00000019.p12'), 'eet') # (substitute your path and password)
```

#### Default values

`Message` sets few default values for some of required attributes. These are:

* `uuid_zpravy` - `SecureRandom.uuid`
* `dat_odesl` - `Time.now` formatted to proper eet date format
* `prvni_zaslani` - `true`
* `rezim` - `0`
* `dat_trzby` - `Time.now` formatted to proper eet date format

Overwrite them at will.

#### Message XML

Want to get the message xml? Call `#to_xml` on the message at any time. It returns classic `Nokogiri` document

## Read the official docs please

We urge everybody to read the official EET docs before implementing any service connected to it. Sometimes the case can get tricky. After all there are 27 settable attributes for the message! And this is just a dumb API wrapper which let's you send anything you want...

**http://www.etrzby.cz/cs/technicka-specifikace**
