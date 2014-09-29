require "rubygems"
require "bundler/setup"

require 'ostruct'
require "optparse"
require "eventmachine"

require_relative "mailanalyst/smtp"

options = OpenStruct.new

OptionParser.new do |opts|
  opts.banner = "Usage: mailanalyst.rb [options]"

  opts.on("--ip IP", "Set the ip address of the smtp server") do |ip|
    options.ip = ip
  end
  opts.on("--port PORT", "Set the port of the smtp server") do |port|
    options.port = port
  end
  opts.on('-v', '--verbose', 'Run verbosely') do |v|
    options.verbose = v
  end
  opts.on('-h', '--help', 'Show this help information') do
    puts opts
    exit
  end
end.parse!(ARGV)

MailAnalyst::Smtp.parms = {verbose: options.verbose || false, auth: :plain}

EM.run do
  trap 'INT'  do EM.stop end
  trap 'TERM' do EM.stop end

  MailAnalyst::Smtp.start(options.ip || "0.0.0.0", options.port || 2500)
end
