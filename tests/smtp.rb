require_relative "test_helper"
require_relative "../mailanalyst/smtp"

describe MailAnalyst::Smtp do
  it "should receive message" do
    host = "127.0.0.1"
    port = 25000

    EM.run do
      p 'starting new server'
      MailAnalyst::Smtp.start(host, port)
      EM::Timer.new(10) {EM.stop}

      assert MailAnalyst::Smtp.running?

      EM::P::SmtpClient.send host: host,
        port: port,
        domain: "bogus",
        auth: {type: :plain, username: "tid=UA-XXXX-Y&el=test"},
        from: "me@example.com",
        to: "you@example.com",
        header: {"Subject" => "Subject line", "CC" => "myboss@example.com"},
        body:"Hello"
    end
  end
end
