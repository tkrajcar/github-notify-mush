require 'sinatra'
require 'json'
require 'net/telnet'

set :mush_host, ENV['GITHUB_NOTIFY_HOST']
set :mush_port, ENV['GITHUB_NOTIFY_PORT']
set :mush_connect_string, ENV['GITHUB_NOTIFY_CONNECT_STRING']
set :mush_channel, ENV['GITHUB_NOTIFY_CHANNEL']
set :mush_ismux, ENV['GITHUB_NOTIFY_ISMUX'] == "true"

if(File.exists?("config.rb"))
  $LOAD_PATH.push File.expand_path(".")
  require 'config.rb'
end

cemit_with_prefix_cmd = settings.mush_ismux ? "@cemit" : "@cemit/noisy"
cemit_without_prefix_cmd = settings.mush_ismux ? "@cemit/noheader" : "@cemit"

get '/' do
  "Yay, the Github notifier is set up and running properly and will connect to #{settings.mush_host} #{settings.mush_port}. Edit test.rb and set base_url to #{request.url} and then run ruby test.rb. If everything works, you're ready to add #{request.url} to Github."
end

post '/' do
  parse = JSON.parse(params[:payload])
  messages = []
  repository = parse["repository"]
  parse["commits"].each do |commit|
    messages.push "#{cemit_with_prefix_cmd} #{settings.mush_channel}=[ansi(hy,#{commit['author']["name"]})] pushed [ansi(h,#{commit['id'][0..9]})] to [ansi(hy,#{repository['name']})]/[ansi(y,#{parse["ref"].split('/').last})]:%r[align(5 73,,lit(#{commit['message']}))]"
    if !commit["added"].nil? && commit["added"].length > 0
      messages.push "#{cemit_without_prefix_cmd} #{settings.mush_channel}=[align(5 12 60,,ansi(hg,Added:),ansi(g,lit(#{commit['added'].to_sentence})))]"
    end
    if !commit["modified"].nil? && commit["modified"].length > 0
      messages.push "#{cemit_without_prefix_cmd} #{settings.mush_channel}=[align(5 12 60,,ansi(hc,Modified:),ansi(c,lit(#{commit['modified'].to_sentence})))]"
    end
    if !commit["removed"].nil? && commit["removed"].length > 0
      messages.push "#{cemit_without_prefix_cmd} #{settings.mush_channel}=[align(5 12 60,,ansi(hr,Removed:),ansi(r,lit(#{commit['removed'].to_sentence})))]"
    end
  end

  tn = Net::Telnet.new('Host' => settings.mush_host, 'Port' => settings.mush_port)
  tn.write settings.mush_connect_string + "\n"
  messages.each do |msg|
    tn.write "#{msg}\n"
  end
  tn.write "QUIT\n"
  tn.close

  return 200
end

# Cheerfully stolen from Rails.
# http://apidock.com/rails/ActiveSupport/CoreExtensions/Array/Conversions/to_sentence
class Array
  def to_sentence()
    words_connector     = ", "
    two_words_connector = " and "
    last_word_connector = ", and "

    case length
      when 0
        ""
      when 1
        self[0].to_s
      when 2
        "#{self[0]}#{two_words_connector}#{self[1]}"
      else
        "#{self[0...-1].join(words_connector)}#{last_word_connector}#{self[-1]}"
    end
  end
end