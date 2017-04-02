require 'concurrent/array'
require_relative 'session'

module Pc2r
  class Player

    @@players = Concurrent::Array.new
    attr_reader :socket, :name
    attr_accessor :score

    # @param socket [TCPSocket]
    # @param name [String]
    def initialize(socket, name)
      @socket = socket
      @name = name
      @score = 0
      @@players << self
    end

    # @param msg [String]
    def broadcast(msg)
      @@players.each { |player| player.puts msg unless player == self }
    end

    def puts (obj='', *arg)
      @socket.puts(obj, arg)
    end

    def destroy
      @@players.delete self
      @socket.close
      Thread.current.kill
    end

    def alone?
      @@players.count == 1 && @@players.include?(self)
    end

    class << self
      # @param msg [String]
      def broadcast(msg)
        @@players.each { |player| player.puts msg}
      end

      # @return [Array]
      def all
        @@players
      end

      # @return [String]
      def scores
        io = StringIO.new
        io.print Session.instance.tour
        @@players.each do |player|
          io.print "*#{player.name}*#{player.score}"
        end
        io.string
    end

      # @param user [String]
      def exist?(user)
        @@players.each { |player| return true if player.name == user }
        false
      end

      # @param user [String]
      # @return [Player]
      def find(user)
        @@players.find { |player| player.name == user }
      end
    end
  end
end
