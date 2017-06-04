if !ENV.has_key?("TW_KEY")
  abort("TW_KEY, TW_SECRET, TW_USERNAME and DM_TEXT environment variables are required.")
end
