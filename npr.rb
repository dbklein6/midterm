require 'pry'
require 'rest-client'

# Get data from NPR API
url = "http://api.npr.org/query?id=10001&fields=title,teaser,audio,artist&requiredAssets=audio&dateType=story&sort=dateDesc&output=JSON&numResults=20&apiKey=MDE4ODc1MDMwMDE0MjkxNDI3MDc0NTgzNg001"

response = RestClient.get(url)
parsed_response = JSON.parse(response)

stories = parsed_response["list"]["story"]

# Make arrays of all story titles and audio files

titles = stories.map do |story|
  story["title"]["$text"]
end

audios = stories.map do |story|
  story["audio"].first["format"]["mp3"].first["$text"]
end

# Start user experience

puts "Welcome to the NPR Music Latest & Greatest"
puts "This program shows the last 20 stories on NPR Music with audio available for download, and lets you quickly download any of them."
puts
puts "Here are the 20 most recent stories:"
puts

# Display the list of recent stories
1.upto(titles.size) do |n|
  puts "#{n}. #{titles[n-1]}"
  n +=1
end

puts

# Let the user pick what file to download or end the program
download = ''
until download == 0
  puts
  puts "Enter the number of the audio file you'd like to download, or enter 0 to leave the program."
  download = gets.strip.to_i

  if download > 0
    system('open', audios[download - 1])
  else
    puts "Thanks for using NPR Music Latest & Greatest."
  end
end