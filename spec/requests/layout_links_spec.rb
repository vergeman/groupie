require 'spec_helper'

describe "LayoutLinks" do

  #Home page test
  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  #About page test
  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  #Contact page test
  it "should have an Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  #How it Works page test
  it "should have an How it works page at '/howitworks'" do
    get '/howitworks'
    response.should have_selector('title', :content => "How it works")
  end

  #Footer link tests
  it "should have the right links on the footer" do 
    visit root_path

    click_link "How it works"
    response.should have_selector('title', :content => "How it works")

    click_link "About"
    response.should have_selector('title', :content => "About")

    click_link "Contact"
    response.should have_selector('title', :content => "Contact")

  end

end
