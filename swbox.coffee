fs = require 'fs'
wd = require 'wd'
{wd40, browser} = require 'wd40'


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


loginSlowly = (username, password, done) ->
  """Login and visit the landing page for the box."""

  browser.get 'https://scraperwiki.com/login', ->
    wd40.fill '#username', username, (err) ->
      if err
        return done err
      wd40.fill '#password', password, (err) ->
        if err
          return done err
        wd40.click '#login', ->
          wd40.waitForMatchingURL /scraperwiki\.com\/?$/, done


login = (username, password, done) ->
  """Login using an XMLHTTP POST request, then visit a dataset page."""
  """This doesn't currently work."""

  loginJavaScript = """xhr = new XMLHttpRequest();
cb = arguments[0];
xhr.open('POST', 'https://scraperwiki.com/login');
xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
xhr.onreadystatechange = function() { if(xhr.readyState == 4) { cb('xxx' + xhr.responseText); } }
xhr.send('username=' + encodeURIComponent('#{username}') + '&password=' + encodeURIComponent('#{password}'));"""

  browser.setAsyncScriptTimeout 8000, ->
    browser.executeAsync loginJavaScript, (err, responseText) ->
      console.log err, responseText
      browser.get 'https://scraperwiki.com', done


# The swbox module.
exports.setup = (done) ->
  username = process.env.SWBOX_USER
  password = process.env.SWBOX_PASSWORD
  dotswbox = nearest '.swbox'
  swbox = JSON.parse fs.readFileSync dotswbox
  box = swbox.boxName

  # Both things need to be set.
  if not username or not password
      message = 'Please set $SWBOX_USER and $SWBOX_PASSWORD (in your .profile?)'
      return done Error(message)

  wd40.init ->
    loginSlowly username, password, ->
      # get dataset (tool) page
      browser.get "https://scraperwiki.com/dataset/#{box}/settings", ->
        # wait for dataset tool content to load
        browser.waitForElementByCss 'iframe', 8000, ->
          # focus on the dataset tool content so user's tests can run
          wd40.switchToBottomFrame done


exports.browser = browser
