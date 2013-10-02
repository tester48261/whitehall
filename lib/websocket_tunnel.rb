require 'em-hiredis'
require 'em-websocket'

class WebsocketTunnel
  def initialize(options = {})
    @sockets = Hash.new { |hash, key| hash[key] = [] }
    @socketMap = {}
    @redis_options = options.delete(:redis)
    @websocket_options = options
  end

  def start
    EM.next_tick do
      redis = EM::Hiredis.connect(@redis_options)

      subscribe_to_redis(redis.pubsub)
      listen_for_websockets(@websocket_options)
    end
  end

protected

  def listen_for_websockets(options)
    Thread.new do
      EM::WebSocket.run(options) do |socket|
        socket.onopen do |request|
          if request.path =~ %r{^/imports/(\d+)$}
            import_id = $1

            unless @sockets[import_id].include?(socket)
              @sockets[import_id] << socket
              @socketMap[socket] = import_id
            end
          end
        end

        socket.onclose do
          import_id = @socketMap.delete(socket)
          @sockets[import_id].delete(socket)
        end
      end
    end
  end

  def subscribe_to_redis(pubsub)
    pubsub.psubscribe("imports:*")
    pubsub.on(:pmessage) do |_, channel, msg|
      import_id = channel.split(':').last
      p [3, import_id, @sockets[import_id], @sockets]
      @sockets[import_id].each { |s| s.send(msg) }
    end
  end
end
