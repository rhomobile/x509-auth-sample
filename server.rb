require 'rubygems'
require 'socket'
require 'openssl'

socket = TCPServer.new('my.secureserver.com', 4567)

ssl_context = OpenSSL::SSL::SSLContext.new()
ssl_context.cert = OpenSSL::X509::Certificate.new(File.open("server.crt"))
ssl_context.key = OpenSSL::PKey::RSA.new(File.open("server.key"))

ca_cert = OpenSSL::X509::Certificate.new(File.open("CA.crt"))

ssl_socket = OpenSSL::SSL::SSLServer.new(socket, ssl_context)


loop do
  connection = ssl_socket.accept
  Thread.new {
    begin
      #do something
    rescue
      $stderr.puts $!
    end
  }
end
