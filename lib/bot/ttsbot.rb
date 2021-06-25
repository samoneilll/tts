require 'discordrb'
require './lib/db.rb'

ENV = Dotenv.load('./.env').freeze
BOT_TOKEN = ENV['BOT_TOKEN'].freeze
BOT_CLIENT = ENV['BOT_CLIENT'].freeze
INSERT_COLS = "channel_name, message_id, user_id, content, timestamp"
TABLE = 'message'

class TtsBot
  def initialize
    @bot = Discordrb::Bot.new token: BOT_TOKEN, client_id: ''
  end

  def listen    
    @bot.message do |event|
      database.insert(TABLE, INSERT_COLS, parse_message(event))
    end
    @bot.run
  end

  private

  def database
    @database ||= TtsDb.new
  end

  def parse_message(event)
    [  
      "\"#{event.message.channel.name}\"",
      event.message.id,
      event.message.user.id,
      "\"#{event.message.content}\"",
      "\"#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}\""
    ].join(', ')
  end
end