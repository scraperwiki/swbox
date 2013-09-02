fs = require 'fs'

wd = require 'wd'
{wd40, browser} = require 'wd40'

LOGIN_URL = "https://scraperwiki.com/login"

# :todo:(drj) Move "nearest" into an npmjs module.
nearestDir = (filename) ->
  dir = process.cwd()
  walkUp = ->
    dir = dir.split('/')[..-2].join '/'
  walkUp() until ( dir == '' or fs.existsSync "#{dir}/#{filename}" )
  return dir

nearest = (filename) ->
  dir = nearestDir filename
  if dir
    return "#{dir}/#{filename}"
  else
    return dir

login = (done) ->
  """Login and visit the landing page for the box."""
  username = process.env.SWBOX_USER
  password = process.env.SWBOX_PASSWORD
  dotswbox = nearest '.swbox'
  swbox = JSON.parse fs.readFileSync dotswbox
  box = swbox.boxName
  browser.get LOGIN_URL, ->
    wd40.fill '#username', username, (err) ->
      if err
        return done err
      wd40.fill '#password', password, (err) ->
        if err
          return done err
        wd40.click '#login', ->
          wd40.waitForMatchingURL /scraperwiki\.com\/?$/, done

# The swbox module.
exports.setup = (done) ->
  user = process.env.SWBOX_USER
  password = process.env.SWBOX_PASSWORD

  # Both things need to be set.
  if not user or not password
      message = 'Please set $SWBOX_USER and $SWBOX_PASSWORD (in your .profile?)'
      return done Error(message)

  login done

exports.browser = browser
