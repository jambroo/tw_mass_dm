require 'json'

if !ENV.has_key?("TW_KEY") || !ENV.has_key?("TW_SECRET") || !ENV.has_key?("TW_USERNAME") || !ENV.has_key?("DM_TEXT")
  abort("ERROR: TW_KEY, TW_SECRET, TW_USERNAME and DM_TEXT environment variables are required.")
end

tw_key = ENV["TW_KEY"]
tw_secret = ENV["TW_SECRET"]
tw_username = ENV["TW_USERNAME"]

CACHE_FILE = "/tw_mass_dm.cache.json"

def get_cache_entry(username, text, call)
  data_hash = JSON.parse(File.read(CACHE_FILE))
  if data_hash.has_key?(username) && data_hash[username].has_key?(text) && data_hash[username][text].has_key?(call)
    return data_hash[username][text][call]
  end
  return false
end

puts get_cache_entry("james", "test", "/1.1/friends/list.json")

#
# authorized = `twurl accounts`
# if authorized == ""
#   auth_result = system("twurl authorize --consumer-key %s --consumer-secret %s" % [tw_key, tw_secret])
#   if !auth_result
#     abort("ERROR: Auth handshake failed.")
#   end
# end
#
# username_result = system("twurl set default %s" % tw_username)
# if !username_result
#   abort("ERROR: Supplied username not found.")
# end
#
# def get_followers(cursor)
#   #followers
#   followers_result = `twurl /1.1/friends/list.json?cursor=#{cursor}`
#   if !followers_result
#     abort("ERROR: could not get friends list")
#   end
#
#   File.open("/tmp/result", 'w') { |file| file.write(followers_result) }
#
#   if `cat /tmp/result | jq '.errors | length'`.to_i > 0
#     abort("ERROR: rate limit reached")
#   end
#
#   screen_names = `cat /tmp/result | jq -r '.users[].screen_name'`.split("\n")
#   next_cursor = `cat /tmp/result | jq '.next_cursor'`
#
#   File.open("/tmp/followers.cache", 'a') { |file| file.write(screen_names.join("\n")) }
#
#   if next_cursor.to_i != 0
#     get_followers(next_cursor)
#   end
# end
#
# get_followers(-1)
