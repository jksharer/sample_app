require 'spec_helper'

describe "User pages" do
  subject { page }
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it { should have_content(user.name) }
    it { should have_title(user.name)}
  end
  
  describe "signup page" do
    
    before { visit signup_path }
    
    it { should have_content('Sign up') }
    it { should have_title(full_title("Sign up")) }    
  end
  
  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name",         with: "zhang"
        fill_in "Email",        with: "zhang@163.com"
        fill_in "Password",     with: "123456"
        fill_in "Confirmation", with: "123456"
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'zhang@163.com') }
        
        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome')}
      end
    end
  end   
     
  describe "Sign in" do
    before { visit signin_path }
    describe "with valid information" do
      let(:user) { User.create(name: "zhangkai", email: "zhangkai@163.com", 
                               password: "123456", password_confirmation: "123456") }
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button 'Sign in'
      end
      describe "should create a new session" do
        it { should have_link('Sign out') }
      end
      describe "followed by signout" do
        before { click_link 'Sign out' }
        it { should have_link('Sign in') }
      end
    end
  end
  
end