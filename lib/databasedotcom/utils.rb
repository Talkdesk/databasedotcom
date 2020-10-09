module Databasedotcom
  module Utils
    def self.emoji_safe_json_parse(data)
      JSON.parse(data)
    rescue JSON::ParserError => e
      raise e unless e.message.include? 'incomplete surrogate pair'

      matches = data.scan(/(?:\\u[0-9|a-f|A-F]{4})+"/)

      puts matches

      matches.each do |match|
        puts match
        next if ((match.length - 1) % 12).zero?

        puts "Will remove invalid unicode"
        fixed_match = match[0...-7]
        puts fixed_match
        data.sub!(match, fixed_match + '"')
      end

      JSON.parse(data)
    end
  end
end
