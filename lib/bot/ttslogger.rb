require 'discordrb'
require './lib/db.rb'


class TtsLogger
  Dotenv.load
  BOT_TOKEN = ENV['BOT_TOKEN'].freeze
  INSERT_COLS = "channel_name, message_id, user_id, content, timestamp"
  TABLE = 'message'

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
      event.message.channel.name.dump,
      event.message.id,
      event.message.user.id,
      event.message.content.dump,
      Time.now.strftime('%Y-%m-%d %H:%M:%S').dump
    ].join(', ')
  end
end