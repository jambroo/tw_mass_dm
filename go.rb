if !ENV.has_key?("TW_KEY") || !ENV.has_key?("TW_SECRET") || !ENV.has_key?("TW_USERNAME") || !ENV.has_key?("DM_TEXT")
  abort("ERROR: TW_KEY, TW_SECRET, TW_USERNAME and DM_TEXT environment variables are required.")
end

tw_key = ENV["TW_KEY"]
tw_secret = ENV["TW_SECRET"]
tw_username = ENV["TW_USERNAME"]

authorized = `twurl accounts`
if !authorized
  auth_result = system("twurl authorize --consumer-key %s --consumer-secret %s" % [tw_key, tw_secret])
  if !auth_result
    abort("ERROR: Auth handshake failed.")
  end
end

username_result = system("twurl set default %s" % tw_username)
if !username_result
  abort("ERROR: Supplied username not found.")
end

#followers
followers_result = `twurl /1.1/friends/list.json?cursor=1552369174870030800`
if !followers_result
  abort("ERROR: could not get friends list")
end

File.open("/tmp/no0", 'w') { |file| file.write(followers_result) }

screen_names = `cat /tmp/no0 | jq -r '.users[].screen_name'`.split("\n")
next_cursor = `cat /tmp/no0 | jq '.next_cursor'`

puts screen_names
puts next_cursor
