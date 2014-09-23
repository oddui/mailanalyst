require "rubygems"
require "bundler/setup"

require "eventmachine"

require_relative "mailanalyst/smtp"

EM.run do
  trap 'INT'  do EM.stop end
  trap 'TERM' do EM.stop end

  MailAnalyst::Smtp.start('127.0.0.1', 25001)
end