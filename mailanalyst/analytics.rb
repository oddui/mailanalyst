require 'eventmachine'
require 'em-http'

module MailAnalyst

  class Analytics
    attr_accessor :parameters, :host

    def initialize(host=nil, parameters={})
      self.host = host ? host : "http://www.google-analytics.com/collect"

      self.parameters = {
        v:  "1",
        tid:"",
        cid:"mailanalyst",
        t:  "event",
        ec: "motion",
        ea: "detect",
        el: "default"
      }.merge(parameters||{})
    end

    def send
      http = EventMachine::HttpRequest.new(host).post({
        head: {"user-agent" => "MailAnalyst"},
        body: parameters
      })

      http.errback { p "host is down! terminate?" }
    end

  end

end
