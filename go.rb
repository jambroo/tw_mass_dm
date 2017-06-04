if !ENV.has_key?("TW_KEY") || !ENV.has_key?("TW_SECRET") || !ENV.has_key?("TW_USERNAME") || !ENV.has_key?("DM_TEXT")
  abort("ERROR: TW_KEY, TW_SECRET, TW_USERNAME and DM_TEXT environment variables are required.")
end

tw_key = ENV["TW_KEY"]
tw_secret = ENV["TW_SECRET"]
tw_username = ENV["TW_USERNAME"]

authorized = `twurl accounts`
puts
puts ".."
if authorized == ""
  auth_result = system("twurl authorize --consumer-key %s --consumer-secret %s" % [tw_key, tw_secret])
  if !auth_result
    abort("ERROR: Auth handshake failed.")
  end
end

username_result = system("twurl set default %s" % tw_username)
if !username_result
  abort("ERROR: Supplied username not found.")
end

def get_followers(cursor)
  #followers
  followers_result = `twurl /1.1/friends/list.json?cursor=#{cursor}`
  if !followers_result
    abort("ERROR: could not get friends list")
  end

  File.open("/tmp/result", 'w') { |file| file.write(followers_result) }

  screen_names = `cat /tmp/result | jq -r '.users[].screen_name'`.split("\n")
  next_cursor = `cat /tmp/result | jq '.next_cursor'`

  File.open("/tmp/followers.cache", 'a') { |file| file.write(screen_names.join("\n")) }

  # confirm this condition works
  if next_cursor != 0
    get_followers(next_cursor)
  end
end

get_followers(1534795388399221800)
#get_followers(-1)
