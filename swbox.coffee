wd = require 'wd'

# The swbox module.
exports.setup = (done) ->
  user = process.env.SWBOX_USER
  password = process.env.SWBOX_PASSWORD

  # Both things need to be set.
  if not user or not password
      message = 'Please set $SWBOX_USER and $SWBOX_PASSWORD (in your .profile?)'
      return done Error(message)

  done Error('NOT IMPLEMENTED')

exports.browser = browser = wd.remote()
