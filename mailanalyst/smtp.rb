require "eventmachine"
require "pony"
require_relative "analytics"

module MailAnalyst

  class Smtp < EM::P::SmtpServer
    # use the username as the ua tracking params
    # and always return true for authenication
    # eg. tid=UA-123456-1&cid=5555
    def receive_plain_auth(user, pass)
      current.parameters ||= {}
      user.split(/&|;/).each do |pair|
        key, value = pair.split('=')
        current.parameters[key.to_sym] = value
      end

      true
    end

    def get_server_domain
      "mailanalyst.local"
    end

    def get_server_greeting
      "MailAnalyst SMTP Server"
    end

    def receive_sender(sender)
      current.sender = sender
      true
    end

    def receive_recipient(recipient)
      current.recipients ||= []
      current.recipients << recipient
      true
    end

    def receive_message
      @@parms[:verbose] and $>.puts "Received complete message"

      current.received = true
      current.completed_at = Time.now

      p [:received_email, current]

      # analytics
      MailAnalyst::Analytics.new(nil, current.parameters).send

      # sendmail
      Pony.mail(to: current.recipients, from: current.sender, subject: "Hello") if false

      @current = OpenStruct.new
      true
    end

    def receive_ehlo_domain(domain)
      @ehlo_domain = domain
      true
    end

    def receive_data_command
      current.data = ""
      true
    end

    def receive_data_chunk(data)
      current.data << data.join("\n")
      true
    end

    def receive_transaction
      if @ehlo_domain
        current.ehlo_domain = @ehlo_domain
        @ehlo_domain = nil
      end
      true
    end

    def current
      @current ||= OpenStruct.new
    end

    def self.start(host = 'localhost', port = 2500)
      require 'ostruct'
      @server = EM.start_server host, port, self
    end

    def self.stop
      if @server
        EM.stop_server @server
        @server = nil
      end
    end

    def self.running?
      !!@server
    end
  end

end
