# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_beemailing_session',
  :secret      => '9a3bdf1b109f4b9018865c8367bf98f5172671f1d399aa780a74d9bf4fe6f41f1b720813f9e461c2f40684f45d8d395df2eef226fe0fbf669dc2e713af2c86d2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
