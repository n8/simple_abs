require "simple_abs/version"

module SimpleAbs

  def is_bot?
    agent = request.env["HTTP_USER_AGENT"]
    matches = nil
    matches = agent.match(/(facebook|postrank|voyager|twitterbot|googlebot|slurp|butterfly|pycurl|tweetmemebot|metauri|evrinid|reddit|digg)/mi) if agent
    if (agent.nil? or matches)
      return true
    else
      return false
    end
  end
  
  def ab_test(name, tests)
    
    if is_bot?
      test_value = tests[rand(tests.size)]
      return test_value
    end
    
    if params[:test_value]
      return params[:test_value]
    end
    
    test_value = cookies[name]
    
    if test_value.blank? || !tests.include?(test_value)
      test_value = tests[rand(tests.size)]
      cookies.permanent[name] = test_value
      
      Alternative.find_or_create_by_experiment_and_which(name, test_value).increment!(:participants)
    end
    
    return test_value
  end
  
  def converted!(name)
  
    if !is_bot?
      test_value = cookies[name]
      if test_value && cookies[name.to_s + "_converted"].blank?
        Alternative.find_or_create_by_experiment_and_which(name, test_value).increment!(:conversions)
        cookies.permanent[name.to_s + "_converted"] = true
      end
    end
  end


  class Railtie < Rails::Railtie
    initializer "simple_abs.initialize" do 
      ActionView::Base.send :include, SimpleAbs
      ActionController::Base.send :include, SimpleAbs
    end
  end

  class Alternative < ActiveRecord::Base

  end


end
