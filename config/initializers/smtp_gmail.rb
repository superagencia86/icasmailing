if Rails.env.development?
  ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true,
    :user_name => APP.gmail.username,
    :password => APP.gmail.password
  }
end
