# Rails AB Testing - Simple Abs

I recently turned on paid subscriptions to [Draft, the writing software](https://draftin.com) I've created. And I wanted a really simple way to test a few alternatives of the payment page in Rails without needing to use a separate service.
 
But the solutions out there get too complicated. Even the "simplest" ones require things like Redis. They do that because somewhere the AB testing library needs to remember what variation of a test a user has already seen, so it knows what to show them on subsequent visits. 

But I don't want to install Redis just to have my AB tests be performant. That's still an extra network call to Redis for this simple operation, not to mention the added complexity of adding Redis to my software stack when I don't need it right now. 

Why can't the AB testing library just store what variation a user has already seen in the user's cookies? 

That's what SimpleAbs does. 

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

Use simple_abs to figure out an "alternative" to show your users. You can get ahold of an alternative from either a Rails View or a Controller. 

```ruby
ab_test(experiment name, [variation name 1, variation name 2, etc.])
```

Here's an example where I might have three different versions of a buy page. simple_abs will randomly pick which version this user should see.

```ruby
def buy
  @buy_page = ab_test("buy_page", ["short", "medium", "long"])

  render action: 'buy'
end
```

Then, in your template, you can use an if statement to show them that version of the @buy_page:

```erb
<% if @buy_page == "long" %>
  Lots of extra information
<% end %>
```

If they've already seen one of the alternatives, simple_abs figures that out from the permanent cookies of the user. In other words, if on the first visit, this method:

```ruby
ab_test("buy_page", ["short", "long"])
```

Returns "short". On subsequent visits to the page from this same user, you will also get the value "short" from the ab_test method.

Once your user converts you can call "converted!(experiment name)" from a View or Controller: 

```ruby
converted!("buy_page")
```

You can also force someone to a specific alternative of your page by using the query paramater "test_value" in your url: 

    http://draftin.com/buy_things?test_value=long

When you get some data you can look at it from a Rails console. 

```ruby
irb(main):011:0> pp SimpleAbs::Alternative.where("experiment = 'buy_page'").all
  SimpleAbs::Alternative Load (55.1ms)  SELECT "alternatives".* FROM "alternatives" WHERE (experiment = 'buy_page')
[#<SimpleAbs::Alternative id: 2, which: "short", participants: 16, conversions: 1, experiment: "buy_page", created_at: "2013-04-16 05:14:13", updated_at: "2013-04-16 13:39:14">,
 #<SimpleAbs::Alternative id: 1, which: "long", participants: 20, conversions: 1, experiment: "buy_page", created_at: "2013-04-16 05:11:12", updated_at: "2013-04-16 14:30:01">]
```

And then you can plug the participants and conversions into a calculator like that found here: 

[http://tools.seobook.com/ppc-tools/calculators/split-test.html](http://tools.seobook.com/ppc-tools/calculators/split-test.html) 

    Trials        = simple_abs' participants
    Successes     = simple_abs' conversions    



Feedback
--------
[Source code available on Github](https://github.com/n8/simple_abs). Feedback and pull requests are greatly appreciated.  

Credit
--------
This library is very much inspired by the other AB testing libraries out there. Not the least of which is A/Bingo from [Patrick McKenzie](https://twitter.com/patio11). 



<hr/>

**P.S. [It would be awesome to meet you on Twitter](http://twitter.com/natekontny).**
<br/>
