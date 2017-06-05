require 'json'

if !ENV.has_key?("TW_KEY") || !ENV.has_key?("TW_SECRET") || !ENV.has_key?("TW_USERNAME") || !ENV.has_key?("DM_TEXT")
  abort("ERROR: TW_KEY, TW_SECRET, TW_USERNAME and DM_TEXT environment variables are required.")
end

$tw_key = ENV["TW_KEY"]
$tw_secret = ENV["TW_SECRET"]
$tw_username = ENV["TW_USERNAME"]
$dm_text = ENV["DM_TEXT"]

CACHE_FILE = "/tw_mass_dm.cache.json"

def get_cache_entry(call)
  username = $tw_username
  text = $dm_text

  data_hash = JSON.parse(File.read(CACHE_FILE))
  if data_hash.has_key?(username) && data_hash[username].has_key?(text) && data_hash[username][text].has_key?(call)
    return data_hash[username][text][call]
  end
  return false
end

def set_cache_entry(call, result)
  username = $tw_username
  text = $dm_text

  data_hash = JSON.parse(File.read(CACHE_FILE))

  if !data_hash.has_key?(username)
    data_hash[username] = {}
  end

  if !data_hash[username].has_key?(text)
    data_hash[username][text] = {}
  end

  data_hash[username][text][call] = result

  File.open(CACHE_FILE, 'w') { |file| file.write(data_hash.to_json) }

  return true
end

def twurl(call)
  result = get_cache_entry(call)
  if !result
    result = `twurl #{call}`
    set_cache_entry(call, result)
  end
  return JSON.parse(result)
end

authorized = `twurl accounts`
if authorized == ""
  auth_result = system("twurl authorize --consumer-key %s --consumer-secret %s" % [$tw_key, $tw_secret])
  if !auth_result
    abort("ERROR: Auth handshake failed.")
  end
end

username_result = system("twurl set default %s" % $tw_username)
if !username_result
  abort("ERROR: Supplied username not found.")
end

def get_followers(cursor)
  #followers
  followers_result = twurl("/1.1/friends/list.json?cursor=#{cursor}")
  if !followers_result
    abort("ERROR: could not get friends list")
  end

  if followers_result.has_key?("errors")
    abort(followers_result["errors"].to_s)
  end

  screen_names = followers_result["users"].map { |k| k["screen_name"] }
  next_cursor = followers_result["next_cursor"]

  puts screen_names
  puts next_cursor

  if next_cursor.to_i != 0
    get_followers(next_cursor)
  end
end

get_followers(-1)
