require_relative "test_helper"
require_relative "../mailanalyst/smtp"

describe MailAnalyst::Smtp do
  it "should receive message" do
    host = "127.0.0.1"
    port = 25
    MailAnalyst::Smtp.parms = {verbose: true}

    EM.run do
      MailAnalyst::Smtp.start(host, port)
      EM::Timer.new(2) {EM.stop}

      assert MailAnalyst::Smtp.running?

      EM::P::SmtpClient.send host: host,
        port: port,
        domain: "mailanalyst.local",
        auth: {type: :plain, username: "tid=UA-XXXX-Y&el=test"},
        from: "me@example.com",
        to: "you@example.com",
        header: {"Subject" => "Subject line", "CC" => "myboss@example.com"},
        body:"Hello"
    end
  end
end
