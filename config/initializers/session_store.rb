# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_curry_session',
  :secret      => '6ebaa1a94ca26670895ee99079169cb2c68f6b4fec2f8e181e6f715bcc9bc52d3db02162d9bb75929f72a7caa6b04231519f01960c85b6cb439f3848b0f0530d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
