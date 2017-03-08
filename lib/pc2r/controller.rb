require_relative 'player'

module Pc2r
  class Controller
    # @param client [TCPSocket]
    def initialize(client)
      @client = client
    end

    # @param user [String]
    def connexion(user)
      if Player.exist? user
        @client.puts 'REFUS/'
      else
        @player = Player.new(@client, user)
        @player.puts "BIENVENUE/#{user}/"
        @player.broadcast "CONNECTE/#{user}/"
      end
    end

    # @param user [String]
    def sort(user)
      if @player.name == user
        @player.broadcast "DECONNEXION/#{user}/"
        @player.destroy
        Thread.current.exit
      end
    end

    def authenticated?
      !@player.nil?
    end

  end
end
