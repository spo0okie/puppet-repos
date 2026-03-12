# Установка puppet теперь происходит в Dockerfile!
# Этот код оставлен на случай, если понадобится для отладки

require 'beaker-puppet'

def provision_puppet()
  # Puppet теперь устанавливается в Dockerfile, этот метод пустой
  # Оставлен для обратной совместимости
  hosts.each do |host|
    on host, 'echo "Puppet already installed in Docker image"'
  end
end

