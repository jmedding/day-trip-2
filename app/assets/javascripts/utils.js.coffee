@Utils = {
  get_cookies : (find_key) -> 
    cookies = document.cookie.split(";")
    values = {}
    for cookie in cookies
      temp = cookie.split("=")
      key =     decodeURIComponent(temp[0].replace(" ", ""))
      value =   decodeURIComponent(temp[1].replace(" ", ""))
      if find_key? 
        if (find_key == key)
          values[key] = value 
      else
        values[key] = value
        
    #console.log(values)
    return values
    
  get_cookie : (key) ->
    value = @get_cookies()[key]
      
  show_cookies: (key) ->
    alert(@get_cookies(key))
    
  delete_cookies: (keys...) ->
    #Usage: Utils.delete_cookies( "key1", "key2"...)
    for key in keys
      document.cookie = encodeURIComponent(key) + '=; expires=Thu, 01-Jan-70 00:00:01 GMT;';
  
  set_cookie : (key, value, duration) ->
    #duration can be a string 'max' or a number (days) or nothing
    #if duration is nothing, then the cookie will last just for the current session
    
    try
      throw "Invalid KEY" unless key? or key.length is 0  
      sDuration = ""
      if duration?
        if isNaN(duration)
            #it's not a number, so it better be 'max'
            console.log(typeof(duration))
            console.log(duration is "max")
            if duration is "max"
              console.log("it's 'max'")
              sDuration = "; max-age=#{1000 * 24 * 3600}"
            else              
             throw "unknown value '#{duration}' used for cookie '#{key}'"
        else
            #It must be a number...
            sDuration = ";max-age=#{duration * 24 * 3600}}"    
            console.log(typeof duration)
          
      sKey = encodeURIComponent(key)
      sValue = encodeURIComponent(value)
      console.log("#{sKey}=#{sValue}#{sDuration}")
      document.cookie = "#{sKey}=#{sValue}#{sDuration}"
      #console.log(document.cookie)
    catch e
        console.log ("Utils.set_cookie error: #{e}")

}
