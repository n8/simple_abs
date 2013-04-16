# SimpleAbs

A super super simple way to do AB tests in Rails. 

I made this because everything else seemed overly complicated. You don't need to install Redis or anything like that. 

Definitely inspired by other AB testing libraris like AB Bingo from patio11. 


## Installation

Add this line to your application's Gemfile:

    gem 'simple_abs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_abs

Create the migration to install the Alternatives table: 

    rails g simple_abs

Run the migrations: 

    rake db:migrate


## Usage

You can use simple_abs to figure out an "alternative" to show your users. You can get ahold of an alternative from a View or from a Controller. 

Here's an example where I might have a short and long version of a buy page. simple_abs will randomly pick which version this user should see.

    def buy
      @buy_page = ab_test("buy_page", ["short", "long"])

      render template: 'site/buy', layout: 'write'
    end

If they've already seen one of the alternatives, simple_abs figures that out from the permanent cookies of the user. 

Once your user converts you can call: 

    converted!("buy_page")

You can also force someone to a specific alternative of your page by using the query paramater "test_value" in your url: 

    http://draftin.com/buy_things?test_value=long


When you get some data you can go to this page: 

    http://www.usereffect.com/split-test-calculator

To check the winner. 

    Visitors  = simple_abs' participants
    Goals     = simple_abs' conversions    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
