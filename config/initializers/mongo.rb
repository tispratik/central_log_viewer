module Mongo
  class << self
    def db
      @db ||= configure
    end

    def collection
      @collection
    end

    def configure
      config_file = Rails.root.join("config", "database.yml")
      config = YAML.load(ERB.new(config_file.read).result)[Rails.env]
      config = { 'host' => 'localhost',
                 'port' => '27017' }.merge(config)
      @collection = config["collection"]
      db = Mongo::Connection.new(config['host'], config['port'], :auto_reconnect => true).db(config['database'])

      if config['username'] && config['password']
        # the driver stores credentials in case reconnection is required
        db.authenticate(config['username'], config['password'])
      end
      db
    end
  end
end

