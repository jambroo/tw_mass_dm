if !ENV.has_key?("TW_KEY") || !ENV.has_key?("TW_SECRET") || !ENV.has_key?("TW_USERNAME") || !ENV.has_key?("DM_TEXT")
  abort("ERROR: TW_KEY, TW_SECRET, TW_USERNAME and DM_TEXT environment variables are required.")
end

tw_key = ENV["TW_KEY"]
tw_secret = ENV["TW_SECRET"]
tw_username = ENV["TW_USERNAME"]

result = system("twurl authorize --consumer-key %s --consumer-secret %s" % [tw_key, tw_secret])
if !result
  abort("ERROR: Auth handshake failed.")
end

result = system("twurl set default %s" % [tw_username])
if !result
  abort("ERROR: Supplied username not found.")
end
