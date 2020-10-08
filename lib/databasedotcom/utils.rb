module Databasedotcom
  module Utils
    def self.emoji_safe_json_parse(data)
      JSON.parse(data)
    rescue JSON::ParserError => e
      raise e unless e.message.include? 'incomplete surrogate pair'

      matches = data.scan(/(\\u[0-9|a-f|A-F]{4})+/)

      matches.each do |match|
        next if (match.length % 12).zero?

        fixed_match = match[0...-6]
        data.gsub!(match + '"', fixed_match + '"')
      end

      JSON.parse(data)
    end
  end
end
