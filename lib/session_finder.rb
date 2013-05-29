require 'em-http'
require 'faye/websocket'
require 'json'
require 'session_finder/network_event_data'
require "session_finder/version"


module SessionFinder

  class Command

    def self.instance
      @__instance__ ||= new
    end

    attr_reader :config

    def initialize
    end

    def hash_to_lc src_hash
      dst_hash = {}
      src_hash.each_pair do |k,v|
         if v.is_a?(Hash)
           dst_hash[k.downcase] = hash_to_lc v
         else
           dst_hash[k.downcase] = v
         end
      end
      dst_hash
    end

    def run config, command, args
      @target = command
      @config = config
      @debug = @config['debug']
      @network_data = hash_to_lc @config['network_data']
      system('"' + @config['chrome'] + '" --remote-debugging-port=' + "#{@config['chrome_port']}" + ' --user-data-dir="' + @config['chrome_dir'] + '" & ' )

      sleep 5

EM.run do
  # Chrome runs an HTTP handler listing available tabs
  conn = EM::HttpRequest.new('http://localhost:9222/json').get
  conn.errback { p 'Error connecting EventMachine'; EM.stop }
  conn.callback do
    session_status = 'Websocket.connect'
    resp = JSON.parse(conn.response)
    # connect to first tab via the WS debug URL
    ws = Faye::WebSocket::Client.new(resp.first['webSocketDebuggerUrl'])

    ws.on :open do |event|
      # once connected, enable network tracking
      ws.send JSON.dump({id: 1, method: 'Network.enable'})
      session_status = 'Network.enable'
    end

    ws.on :error do |event|
      p [:error, "#{event.data}"]
    end

    ws.on :message do |event|
      event_message = JSON.parse(event.data)
      case session_status
      when 'Network.enable'
        ws.send JSON.dump({
          id: 2,
          method: 'Network.setCacheDisabled',
          params: {cacheDisabled: true}
        })
        session_status = 'Network.setCacheDisabled'

      when 'Network.setCacheDisabled'
        ws.send JSON.dump({
          id: 3,
          method: 'Page.navigate',
          params: {url: @target}
        })
        session_status = 'Page.navigate'
        ned = NetworkEventData.new({'params' => nil}, @network_data)
        puts ned.csv_head

      else
        if event_message["method"]
          case event_message["method"]
          when "Inspector.detached"
            exit
          when "Network.dataReceived"
          when "Network.loadingFinished"
          when "Network.requestWillBeSent"
            nil
          else
            event_message_lc = hash_to_lc event_message
            ned = NetworkEventData.new(event_message_lc, @network_data, "")
            puts ned.csv
          end
        end
      end
    end
  end
end

    end

  end

end
