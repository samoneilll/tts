require 'dotenv'
require 'mysql2'

class TtsDb
  ENV = Dotenv.load('./.env').freeze
  DB_HOST = "#{ENV['CONTAINER_NAME']}-db".freeze
  DB_PASS = ENV['MYSQL_PASSWORD'].freeze
  DB_USER = 'root'.freeze
  
  def initialize
    seed_db     
  end

  def client
    @client ||= Mysql2::Client.new(:host => DB_HOST, :username => DB_USER, :password => DB_PASS)
  end

  def insert(table_name, columns, values)
    puts "INSERT INTO #{table_name} (#{columns}) VALUES (#{values});"
    @client.query("INSERT INTO #{table_name} (#{columns}) VALUES (#{values});")
  end
  
  private
  
  def seed_db
    create_db('tts')
    create_table('
      message', {
        'channel_name': 'TEXT',
        'message_id': 'BIGINT',
        'user_id': 'BIGINT',        
        'content': 'TEXT',
        'timestamp': 'TIMESTAMP'
      }
    )    
  end

  def create_db(db_name)
    client.query("CREATE DATABASE IF NOT EXISTS #{db_name};")
    client.query("USE #{db_name};")
  end

  def create_table(table_name, columns)
    column_query = columns.map { |k,v| [k.to_s, v].join(' ')}    
    client.query("CREATE TABLE IF NOT EXISTS #{table_name} (Id INT PRIMARY KEY AUTO_INCREMENT, #{column_query.join(', ')});")
  end
end