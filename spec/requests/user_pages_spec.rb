require 'spec_helper'

describe "User pages" do
  subject { page }
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "zhangkai say hello") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "liuchang say hello") }
    
    before { visit user_path(user) }
    
    it { should have_content(user.name) }
    it { should have_title(user.name)}
    
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) } #count 方法会直接在数据库层中统计用户的微博数量。
    end
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
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
    sign_in user
    visit edit_user_path(user)
    end  
     
    
    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails')}
    end 
    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content("error") }
    end
    
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      # it { should have_link('Sign out', href: signout_path) }
      # it { should have_link('Settings', href: edit_user_path(user)) }
      # it { should have_content(user.name) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }    
    end
    
  end
  
  describe "index" do
    # before do
      # sign_in FactoryGirl.create(:user)
      # FactoryGirl.create(:user, name:"Bob", email: "Bob@163.com")
      # FactoryGirl.create(:user, name:"Ben", email: "Ben@163.com")
      # visit users_path
    # end
    # it { should have_title("All users") }
    # it { should have_content("All users") }
    # it "should list each user" do
      # User.all.each do |user|
        # expect(page).to have_selector('li', text: user.name)
      # end
    # end
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end
    it { should have_title("All users") }
    it { should have_content("All users") }
    
    describe "pagination" do   #检测页面中是否包含正确的 div 元素，以及是否显示了正确的用户。
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }
      
      it { should have_selector('div.pagination') } 
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)   
        end
      end
    end
    
    describe "delete links" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin
        visit users_path
      end
      it { should have_link('delete', href: user_path(User.first)) }
      it "should be able to delete another user" do
        expect do
          click_link('delete', match: :first)  
        end.to change(User, :count).by(-1)
      end
      it { should_not have_link('delete', href: user_path(admin)) }
      
    end
  end
end