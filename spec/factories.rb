FactoryGirl.define do
  factory :user do
    # name      "zhangkai"
    # email     "zhangkai@163.com"
    # password  "123456"
    # password_confirmation  "123456"
    
    sequence(:name) { |n| "Person #{ n }" }
    sequence(:email) { |n| "Person-#{ n }@163.com" }
    password "123456"
    password_confirmation "123456"
    
    factory :admin do
      admin true
    end
  end
  
  
end