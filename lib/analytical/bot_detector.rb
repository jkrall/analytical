module Analytical
  module BotDetector

    def analytical_is_robot?(user_agent, whitelist = [])
      whitelist = Array(whitelist)

      unless user_agent.blank?
        user_agent = user_agent.to_s.downcase

        # We mark something as a bot if it contains any of the $bot_indicators
        # or if it does not contain one of the $browser_indicators. In addition,
        # if the user-agent string contains "mozilla" we make sure it has version
        # information. Finally anything that starts with a word in the $whitelist
        # is never considered a bot.

        whitelist.concat %w(w3m dillo links elinks lynx)
        whitelist.each do |word|
          return false if user_agent.index(word) == 0
        end

        bot_indicators = %w(bot spider search jeeves crawl seek heritrix slurp thumbnails capture ferret webinator scan retriever accelerator upload digg extractor grub scrub)
        bot_indicators.each do |word|
          return true if user_agent.index word
        end

        browser_indicators = %w(mozilla browser iphone lynx mobile opera icab)
        has_browser_indicator = false

        browser_indicators.each do |word|
          if user_agent.index word
            has_browser_indicator = true
            break
          end
        end

        return true if not has_browser_indicator

        # Check for mozilla version information
        if user_agent.include? "mozilla"
          return true if not user_agent.include? "("
          return true if user_agent !~ /mozilla\/\d+/i
        end
      end
      return false
    end

  end
end
