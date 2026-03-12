# Beaker Docker Boxes

## Общее описание

Данные Dockerfile-ы предназначены для создания Docker-образов (beaker boxes), используемых для автоматизированного тестирования Puppet-модулей с помощью фреймворка [Beaker](https://github.com/puppetlabs/beaker).

Все Dockerfiles выполняют **один и тот же набор задач**, адаптированный под особенности конкретной операционной системы:

---

## Задачи, выполняемые во всех Dockerfile

### Настройка прокси

- Поддержка HTTP/HTTPS прокси через переменные сборки `ARG` и `ENV`
- Позволяет использовать образы в корпоративных сетях с прокси-сервером
- Для Debian копируется файл [`apt.conf`](apt.conf) с настройками прокси и ослабленными настройкми безопасности

### Настройка репозиториев

- Для дистрибутивов с истёкшим сроком поддержки (EOL) настраиваются архивные репозитории:
  - **CentOS 5/6/7** — используется локальный корпоративный репозиторий
  - **Debian 9/10** — используется `archive.debian.org`


### Установка базовых пакетов

Все образы устанавливают следующие пакеты:

| Пакет | Назначение |
|-------|------------|
| `openssh-server` | SSH-сервер для подключения Beaker к контейнеру |
| `openssh-client` | SSH-клиент для подключения к другим хостам |
| `curl` | Утилита для загрузки файлов по HTTP/HTTPS |
| `puppet-agent` | Агент Puppet для применения конфигурации (CentOS 5/6) |
| `ntpdate` / `ntpsec-ntpdate` | Синхронизация времени с NTP-сервером |
| `lsb-release` | Определение версии дистрибутива (для Puppet фактов) |
| `apt-transport-https` | Поддержка HTTPS для APT репозиториев (Debian) |
| `ca-certificates` | Корневые SSL-сертификаты для HTTPS |

### Настройка SSH

- **Генерация SSH host keys** (RSA, ECDSA, ED25519)
- **Установка пароля** `root:root` для SSH-аутентификации
- **Создание директории** `/root/.ssh` с правильными правами (700)
- **Настройка SSH config** для отключения проверки host keys:
  - `StrictHostKeyChecking no`
  - `UserKnownHostsFile /dev/null`
- **Настройка sshd_config** для тестового окружения:
  - `PermitRootLogin yes` — разрешение входа под root
  - `PasswordAuthentication yes` — аутентификация по паролю
  - `UseDNS no` — отключение DNS resolver для ускорения подключения
  - `UsePAM no` — отключение PAM для упрощения настройки
  - `MaxAuthTries 1000` — увеличенный лимит попыток аутентификации

### Патч PAM (только для Debian 10+)

- Модификация `pam_loginuid.so`: изменение `required` на `optional`
- Предотвращает ошибки `setuid: Operation not permitted` в контейнере

### Запуск SSH демона

- Контейнер запускает `sshd` в foreground-режиме (`-D`)
- Beaker подключается к контейнеру по SSH и выполняет Puppet-код

---

## Доступные образы

| Файл | Операционная система |
|------|---------------------|
| `Dockerfile.centos5` | CentOS 5.11 |
| `Dockerfile.centos6` | CentOS 6.10 |
| `Dockerfile.centos7` | CentOS 7.9.2009 |
| `Dockerfile.debian9` | Debian 9 (Stretch) |
| `Dockerfile.debian10` | Debian 10 (Buster) |
| `Dockerfile.debian11` | Debian 11 (Bullseye) |
| `Dockerfile.debian12` | Debian 12 (Bookworm) |
| `Dockerfile.debian13` | Debian 13 (Trixie) |
