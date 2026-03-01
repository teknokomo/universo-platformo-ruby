# Universo Platformo Ruby

Реализация Universo Platformo на Ruby on Rails — модульная платформа для метавселенных, кластеров и цифровых ресурсов.

## Статус проекта

🚀 **Активная разработка** — Стартовые страницы и аутентификация через Supabase реализованы.

В этом релизе реализованы: гостевая посадочная страница, страница онбординга для авторизованных  
пользователей и полный поток аутентификации через Supabase, работающий только через Rails-бэкенд.

## Принцип интеграции с Supabase

**Фронтенд никогда не обращается к Supabase напрямую.** Все вызовы аутентификации идут через бэкенд:

```
Браузер → Rails (SessionsController / Api::V1::AuthController) → Supabase Auth API
```

`SupabaseAuthService` выполняет все запросы к REST API Supabase через встроенный `Net::HTTP`.  
Учётные данные (`SUPABASE_URL`, `SUPABASE_KEY`) хранятся только на сервере.

## Архитектура

### Структура пакетов

Код функций размещается в директории `packages/` по структуре монорепозитория:

```
packages/
├── start-frt/base/   # Гостевая и аутентифицированная стартовые страницы
└── auth-frt/base/    # UI аутентификации (вход / регистрация)
```

### Слой приложения (корневой `app/`)

| Путь | Назначение |
|------|-----------|
| `app/controllers/start_controller.rb` | Маршрутизирует `/` на гостевую или аутентифицированную страницу |
| `app/controllers/auth/sessions_controller.rb` | HTML-формы входа, регистрации, выхода |
| `app/controllers/api/v1/auth_controller.rb` | JSON API для аутентификации |
| `app/services/supabase_auth_service.rb` | HTTP-клиент Supabase (только бэкенд) |
| `app/views/start/guest.html.erb` | Посадочная страница для гостей |
| `app/views/start/authenticated.html.erb` | Мастер онбординга для авторизованных пользователей |
| `app/views/auth/sessions/new.html.erb` | Форма входа |
| `app/views/auth/sessions/sign_up.html.erb` | Форма регистрации |

## Страницы

| URL | Авторизация | Описание |
|-----|------------|---------|
| `GET /` | Нет | Редирект на `/start/guest` или `/start/authenticated` |
| `GET /start/guest` | Нет | Секция hero + 4 карточки продуктов + footer |
| `GET /start/authenticated` | Да | Многошаговый мастер онбординга |
| `GET /auth/sign-in` | Нет | Форма входа |
| `GET /auth/sign-up` | Нет | Форма регистрации |
| `POST /auth/sign-in` | Нет | Обработка входа |
| `POST /auth/sign-up` | Нет | Обработка регистрации |
| `DELETE /auth/sign-out` | Да | Выход |
| `GET /api/v1/auth/csrf` | Нет | CSRF-токен для JSON-клиентов |
| `GET /api/v1/auth/me` | Нет | Информация о текущем пользователе (JSON) |

## Технологический стек

- **Среда выполнения**: Ruby 3.2+
- **Фреймворк**: Ruby on Rails 7.1
- **База данных**: PostgreSQL (Supabase)
- **Аутентификация**: Supabase Auth (через `Net::HTTP`, без SDK)
- **Фронтенд**: Tailwind CSS, Turbo, Stimulus, Importmap
- **Тестирование**: RSpec, WebMock, Shoulda Matchers
- **Качество кода**: RuboCop, Brakeman, Bundler Audit
- **i18n**: Локали английского и русского (`config/locales/en.yml`, `ru.yml`)

## Быстрый старт

### 1. Клонирование репозитория

```bash
git clone https://github.com/teknokomo/universo-platformo-ruby.git
cd universo-platformo-ruby
```

### 2. Установка зависимостей

```bash
bundle install
```

### 3. Настройка окружения

```bash
cp .env.example .env
```

Отредактируйте `.env` и укажите данные вашего проекта Supabase:

```dotenv
SUPABASE_URL=https://<your-project-ref>.supabase.co
SUPABASE_KEY=<ваш-supabase-anon-key>
DATABASE_URL=postgresql://postgres:<пароль>@db.<project-ref>.supabase.co:5432/postgres
SECRET_KEY_BASE=<выполните: bundle exec rails secret>
```

### 4. Сборка CSS и запуск сервера

```bash
bundle exec rails tailwindcss:build
bundle exec rails server
```

Откройте `http://localhost:3000` в браузере.

## Разработка

### Запуск тестов

```bash
# Все тесты
bundle exec rspec

# Конкретный файл
bundle exec rspec spec/requests/auth_spec.rb

# С покрытием кода
COVERAGE=true bundle exec rspec
```

### Качество кода

```bash
bundle exec rubocop                        # Линтер
bundle exec brakeman                       # Сканер безопасности
bundle exec bundle-audit check --update    # Аудит зависимостей
```

## Безопасность

- **Защита CSRF**: `protect_from_forgery with: :exception` для всех запросов.  
  JSON-клиенты получают токен через `GET /api/v1/auth/csrf` и передают `X-CSRF-Token`.
- **Защита от фиксации сессии**: `reset_session` вызывается перед записью новых  
  учётных данных при каждом успешном входе или регистрации.
- **Секреты не уходят в браузер**: Учётные данные и токены Supabase хранятся только  
  в переменных окружения сервера и сессии — никогда не попадают в HTML или JavaScript.
- **Проверка SSL**: `OpenSSL::SSL::VERIFY_PEER` принудительно применяется при обращениях к Supabase.

## Интернационализация

Текст UI использует Rails I18n. Файлы локалей находятся в `config/locales/`:

- `en.yml` — английский (по умолчанию)
- `ru.yml` — русский

## Участие в проекте

1. Прочитайте рекомендации в `.github/instructions/`
2. Создайте Issue по предоставленным шаблонам
3. Создайте feature-ветку из вашего Issue
4. Отправьте Pull Request согласно рекомендациям
5. Убедитесь, что все тесты проходят и проверки качества кода успешны

## Референсная реализация

Этот проект вдохновлён [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react)  
и воспроизводит его архитектуру средствами чистого Ruby on Rails.

## Лицензия

Лицензия MIT — подробности в файле `LICENSE`.

## Ссылки

- **Референс React**: [universo-platformo-react](https://github.com/teknokomo/universo-platformo-react)
- **Документация**: [docs.universo.pro](https://docs.universo.pro) *(скоро)*
- **Сайт**: [universo.pro](https://universo.pro) *(скоро)*
