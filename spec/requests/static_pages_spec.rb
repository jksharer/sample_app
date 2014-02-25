require 'spec_helper'

describe "Static pages" do
  
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe "Home page" do

    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Home')
    end
	it "should have the right title" do
	  visit '/static_pages/home'
	  expect(page).to have_title("Ruby on Rails Tutorial Sample App | Home")
	end
  end
  
  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
	it "should have the right title" do
	  visit '/static_pages/help'
	  expect(page).to have_title("Ruby on Rails Tutorial Sample App | Help")
	end
  end
  
  describe "About page" do

    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end
	it "should have the right title" do
	  visit '/static_pages/about'
	  expect(page).to have_title("Ruby on Rails Tutorial Sample App | About")
	end
  end
  
  describe "contact page" do

    it "should have the content 'About Us'" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')
    end
	it "should have the right title" do
	  visit '/static_pages/contact'
	  expect(page).to have_title("Ruby on Rails Tutorial Sample App | Contact")
	end
  end  
	
end
