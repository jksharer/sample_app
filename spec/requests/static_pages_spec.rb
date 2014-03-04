require 'spec_helper'

describe "Static pages" do
  
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  
  subject { page }
  
  describe "Home page" do
    before { visit root_path }
    it {should have_content('Sample App')}
    it {should have_title(full_title(''))}
  end
  
  describe "Help page" do
    before { visit help_path }
    it {should have_content('Help')}
    it {should have_title(full_title("Help"))}
  end
  
  describe "About page" do
    before { visit about_path }
    it {should have_content('About Us')}
    it {should have_title(full_title("About Us"))}
  end
  
  describe "contact page" do
    before { visit contact_path }
    it {should have_content('Contact')}
    it {should have_title(full_title("Contact"))}
  end  
  
  describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    end
end
