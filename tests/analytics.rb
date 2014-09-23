require_relative "test_helper"
require_relative "../mailanalyst/analytics"

describe MailAnalyst::Analytics do
  it "should send request" do
    EM.run do
      d = MailAnalyst::Analytics.new(nil, {
        tid:"UA-XXXX-Y",
        el: "A Label"
      }).send
      d.callback do |http|
        assert http.state == :finished
        assert http.req.method == "POST"
        assert http.req.host == "www.google-analytics.com"
        assert http.req.port == 80
        assert http.req.body.fetch(:v) == "1"
        assert http.req.body.fetch(:el) == "A Label"
        assert http.req.body.fetch(:tid) == "UA-XXXX-Y"

        EM.stop
      end
    end
  end
end
