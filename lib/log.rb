require 'sinatra'
require 'logger'
require 'email'

class Logger
  def error exception, detail = ''
    if exception.kind_of? Exception
      log ERROR, "#{exception.message} - #{detail}\n" + exception.backtrace.join("\n")
    else
      log ERROR, "#{exception} - #{detail}"
    end
  end
end

configure :test do
  Log = Logger.new STDOUT
  CashstarLog = Logger.new STDOUT
  StripeLog = Logger.new STDOUT
  Log.level = Logger::FATAL
  CashstarLog.level = Logger::FATAL
  StripeLog.level = Logger::FATAL
end

configure :development do
  Log = Logger.new STDOUT
  CashstarLog = Logger.new 'cashstar.log', 'weekly'
  StripeLog = Logger.new 'stripe.log', 'weekly'
end

configure :staging do
  Log = Logger.new '/var/log/cardthings/application.log', 'weekly'
  CashstarLog = Logger.new '/var/log/cardthings/cashstar.log', 'weekly'
  StripeLog = Logger.new '/var/log/cardthings/stripe.log', 'weekly'
end

configure :production do
  Log = Logger.new '/var/log/cardthings/application.log', 'weekly'
  CashstarLog = Logger.new '/var/log/cardthings/cashstar.log', 'weekly'
  StripeLog = Logger.new '/var/log/cardthings/stripe.log', 'weekly'

  def Log.error exception, detail = ''
    super
    send_alert 'GENERAL ERROR!', exception, detail
  end

  def StripeLog.error exception, detail = ''
    super
    send_alert 'STRIPE ERROR!', exception, detail
  end

  def CashstarLog.error exception, detail = ''
    super
    send_alert 'CASHSTAR ERROR!', exception, detail
  end

  def send_alert subject, exception, detail
    if exception.kind_of? Exception
      message = "<h2>#{exception.message}</h2><h3>#{detail}</h3>" + exception.backtrace.join("<br/>")
    else
      message = "#{exception} - #{detail}"
    end
    Skeleton::Email.new(:subject => subject, :plain_body => message, :from => settings.cardthings_email).deliver settings.cardthings_email
  end
end

Log.info "Configured logging for #{settings.environment}"
