require 'socket'
require 'openssl'
class Application < Rhoconnect::Base
  class << self
    def authenticate(username,password,session)
       #assuming pem file has certificate and then private key below in pem format
        pem_arr = pem.split("-----END CERTIFICATE-----")
        pem_arr[0] << "-----END CERTIFICATE-----"

        socket = TCPSocket.new('my.secureserver.com', 4567)

        ssl_context = OpenSSL::SSL::SSLContext.new

        ssl_context.cert = OpenSSL::X509::Certificate.new(pem_arr[0].strip)
        ssl_context.key = OpenSSL::PKey::RSA.new(pem_arr[1].strip)

        ssl_socket = OpenSSL::SSL::SSLSocket.new(socket, ssl_context)
        ssl_socket.sync_close = true

        ca_cert = OpenSSL::X509::Certificate.new(File.open("CA.crt"))

        if ssl_socket.connect
          puts "socket connected correctly"
          return true
        else
          puts "socket failed to connnect"
          return false
        end
    end

    def ans_authenticate(username,password)
      true # optionally handle rhoconnect push authentication...
    end
    
    # Add hooks for application startup here
    # Don't forget to call super at the end!
    def initializer(path)
      super
    end
    
    # Calling super here returns rack tempfile path:
    # i.e. /var/folders/J4/J4wGJ-r6H7S313GEZ-Xx5E+++TI
    # Note: This tempfile is removed when server stops or crashes...
    # See http://rack.rubyforge.org/doc/Multipart.html for more info
    # 
    # Override this by creating a copy of the file somewhere
    # and returning the path to that file (then don't call super!):
    # i.e. /mnt/myimages/soccer.png
    def store_blob(object,field_name,blob)
      super #=> returns blob[:tempfile]
    end
  end
end

Application.initializer(ROOT_PATH)

# Support passenger smart spawning/fork mode:
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      # We're in smart spawning mode.
      Store.db.client.reconnect
    else
      # We're in conservative spawning mode. We don't need to do anything.
    end
  end
end
