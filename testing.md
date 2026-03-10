# Тестирование Puppet модуля с Beaker в Docker

Документ описывает процесс провижна Docker контейнеров и запуска тестов Puppet модулей с использованием Beaker.

## Доступные хосты

### Debian
- Debian 9 (`hosts.yml.erb` - генерирует все версии)
- Debian 10
- Debian 11
- Debian 12
- Debian 13

### CentOS
- CentOS 5 (`hosts-centos5.yml.erb`)
- CentOS 6 (`hosts-centos6.yml.erb`)
- CentOS 7 (`hosts-centos7.yml.erb`)

## Предварительные требования

1. Установленный Docker
2. Установленный PDK (Puppet Development Kit)
3. Настроенные переменные окружения для прокси (при необходимости)

```bash
export HTTP_PROXY=http://klg-proxy.azimuth.holding.local:3128
export HTTPS_PROXY=http://klg-proxy.azimuth.holding.local:3128
export NO_PROXY=localhost,127.0.0.1
```

## Провижн всех боксов

### Провижн одного хоста (например, CentOS 7)

```bash
pdk bundle exec beaker --hosts ./hosts-centos7.yml.erb --provision
```

### Провижн всех хостов Debian (9-13)

```bash
pdk bundle exec beaker --hosts ./hosts.yml.erb --provision
```

### Провижн конкретной версии CentOS

```bash
# CentOS 5
pdk bundle exec beaker --hosts ./hosts-centos5.yml.erb --provision

# CentOS 6
pdk bundle exec beaker --hosts ./hosts-centos6.yml.erb --provision

# CentOS 7
pdk bundle exec beaker --hosts ./hosts-centos7.yml.erb --provision
```

## Провижн без уничтожения

Если контейнеры уже существуют и вы хотите их переиспользовать:

```bash
pdk bundle exec beaker --hosts ./hosts-centos7.yml.erb --provision --no-provision
```

## Запуск тестов Puppet модуля

### Тест на конкретном хосте

```bash
# CentOS 7
pdk bundle exec beaker --hosts ./hosts-centos7.yml.erb

# CentOS 6
pdk bundle exec beaker --hosts ./hosts-centos6.yml.erb
```

### Тест на всех хостах Debian

```bash
pdk bundle exec beaker --hosts ./hosts.yml.erb
```

## Структура команды Beaker

```bash
pdk bundle exec beaker \
  --hosts <hosts_file> \
  --provision \
  --destroy \
  <test_file>
```

### Основные опции

| Опция | Описание |
|-------|----------|
| `--hosts` | Путь к файлу конфигурации хостов (.yml.erb) |
| `--provision` | Создать/настроить хосты перед тестом |
| `--destroy` | Удалить хосты после теста |
| `--no-provision` | Пропустить провижн (использовать существующие хосты) |
| `--debug` | Вывод отладочной информации |
| `--log-level` | Уровень логирования (debug, info, warn, error) |

## Провижн и тестирование вручную

### 1. Создание Docker образа вручную

```bash
# CentOS 7
docker build -t centos7-test -f test/Dockerfile.centos7 .

# CentOS 6
docker build -t centos6-test -f test/Dockerfile.centos6 .

# CentOS 5
docker build -t centos5-test -f test/Dockerfile.centos5 .
```

### 2. Запуск контейнера

```bash
docker run -d --name test-centos7 centos7-test
```

### 3. Проверка SSH доступа

```bash
# Получить порт
docker port test-centos7 22

# Подключиться (пароль: root)
ssh root@localhost -p <port>
```

### 4. Остановка и удаление

```bash
docker stop test-centos7
docker rm test-centos7
```

## Удаление всех тестовых контейнеров

```bash
# Остановить все контейнеры beaker
docker ps -a --filter "name=beaker-" -q | xargs docker rm -f

# Удалить все тестовые образы
docker rmi centos7-test centos6-test centos5-test
```

## Примеры файлов hosts

### hosts-centos7.yml.erb

```yaml
---
HOSTS:
  centos7-x86_64:
    roles:
      - agent
    platform: centos-7-x86_64
    dockerfile: test/Dockerfile.centos7
    hypervisor: docker
    is_container: true
    use_systemd: false
    docker_preserve_image: true
    docker_cmd: ["/usr/sbin/sshd", "-D"]
    docker_env:
      - http_proxy=<%= ENV.fetch('HTTP_PROXY', '') %>
      - https_proxy=<%= ENV.fetch('HTTPS_PROXY', '') %>
      - no_proxy=<%= ENV.fetch('NO_PROXY', '') %>
    docker_buildargs:
      http_proxy: <%= ENV.fetch('HTTP_PROXY', '') %>
      https_proxy: <%= ENV.fetch('HTTPS_PROXY', '') %>
      no_proxy: <%= ENV.fetch('NO_PROXY', '') %>
CONFIG:
  type: aio
  log_level: debug
  ssh_service_name: ssh
  use_sudo: false
```

## Тестирование Puppet модуля

### С использованием spec-тестов

```bash
pdk bundle exec rake spec
```

### С использованием acceptance тестов (beaker)

```bash
# Тест на CentOS 7
pdk bundle exec beaker --hosts ./hosts-centos7.yml.erb

# Тест на CentOS 6
pdk bundle exec beaker --hosts ./hosts-centos6.yml.erb

# Тест на всех CentOS
for host in centos5 centos6 centos7; do
  pdk bundle exec beaker --hosts ./hosts-${host}.yml.erb
done

# Тест на всех Debian
pdk bundle exec beaker --hosts ./hosts.yml.erb
```

## Устранение проблем

### Контейнер не создаётся

Проверьте:
1. Доступность Docker: `docker ps`
2. Правильность пути к Dockerfile
3. Настройки прокси

### Ошибки сети

```bash
# Проверьте переменные окружения
env | grep -i proxy

# Установите прокси если нужно
export HTTP_PROXY=http://proxy.example.com:3128
export HTTPS_PROXY=http://proxy.example.com:3128
```

### Ошибки SSH

```bash
# Проверьте, что sshd запущен
docker exec <container> ps aux | grep sshd

# Проверьте порт
docker port <container>
```

## Ссылки

- [Beaker Documentation](https://github.com/puppetlabs/beaker)
- [PDK Documentation](https://puppet.com/docs/pdk)
