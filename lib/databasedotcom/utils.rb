module Databasedotcom
  module Utils
    def self.emoji_safe_json_parse(data)
      JSON.parse(data)
    rescue JSON::ParserError => e
      raise e unless e.message.include? 'incomplete surrogate pair'

      matches = find_unicode_sequences(data)

      matches.each do |match|
        next if valid_unicode_sequence?(match)

        fixed_match = remove_incomplete_surrogate_pair(match)
        data.sub!(match, fixed_match + '"')
      end

      JSON.parse(data)
    end

    def find_unicode_sequences(data)
      data.scan(/(?:\\u[0-9|a-f|A-F]{4})+"/)
    end

    def valid_unicode_sequence?(match)
      ((match.length - 1) % 12).zero?
    end

    def remove_incomplete_surrogate_pair(match)
      match[0...-7]
    end
  end
end
