require "rubygems"
require "bundler/setup"

require "eventmachine"

require_relative "mailanalyst/smtp"

MailAnalyst::Smtp.parms = {verbose: true, auth: :plain}

EM.run do
  trap 'INT'  do EM.stop end
  trap 'TERM' do EM.stop end

  MailAnalyst::Smtp.start('0.0.0.0', 25001)
end
