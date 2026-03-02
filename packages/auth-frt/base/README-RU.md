# Пакет auth-frt

Пакет фронтенда аутентификации для Universo Platformo Ruby.

## Обзор

Этот пакет предоставляет страницы аутентификации для приложения Universo Platformo
с интеграцией Supabase через Rails бэкенд:
- Страница входа (форма авторизации)
- Страница регистрации (форма создания аккаунта)

## Структура

```
base/
├── README.md           # Документация пакета (EN)
└── README-RU.md        # Документация пакета (RU)
```

Код реализации находится в корневом Rails-приложении:

| Путь в корневом `app/` | Описание |
|------|---------|
| `app/controllers/auth/sessions_controller.rb` | Auth::SessionsController (HTML-формы) |
| `app/controllers/api/v1/auth_controller.rb` | JSON API для аутентификации |
| `app/services/supabase_auth_service.rb` | SupabaseAuthService интеграция с бэкендом |
| `app/views/auth/sessions/new.html.erb` | ERB шаблон формы входа |
| `app/views/auth/sessions/sign_up.html.erb` | ERB шаблон формы регистрации |

## Страницы

### Страница входа (`/auth/sign-in`)
Форма входа с полями email/пароль.
- Проверяет учётные данные через SupabaseAuthService
- Сохраняет сессию при успехе
- Показывает сообщения об ошибках при сбое

### Страница регистрации (`/auth/sign-up`)
Форма регистрации с полями email, пароль и подтверждение пароля.
- Создаёт новый аккаунт через SupabaseAuthService
- Обрабатывает процесс подтверждения email
- Показывает сообщения об ошибках при сбое

## Процесс аутентификации

```
Пользователь → Форма авторизации → Auth::SessionsController
                                  → SupabaseAuthService (HTTP → Supabase REST API)
                                  → Сессия сохранена на сервере
                                  → Перенаправление на стартовую страницу
```

## Маршруты

```ruby
get  "auth/sign-in",  to: "auth/sessions#new"
post "auth/sign-in",  to: "auth/sessions#create"
get  "auth/sign-up",  to: "auth/sessions#sign_up"
post "auth/sign-up",  to: "auth/sessions#register"
delete "auth/sign-out", to: "auth/sessions#destroy"
```

## API Эндпоинты (JSON)

```
GET    /api/v1/auth/csrf      - CSRF токен
GET    /api/v1/auth/me        - Информация о текущем пользователе
POST   /api/v1/auth/sign-in   - Вход
POST   /api/v1/auth/sign-up   - Регистрация
DELETE /api/v1/auth/sign-out  - Выход
```

## Конфигурация

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key
```

## Зависимости

- Ruby on Rails 7.1+
- Проект Supabase с включённой аутентификацией
- tailwindcss-rails для стилизации
- i18n с файлами локализации en/ru

## Тестирование

```bash
bundle exec rspec spec/requests/auth_spec.rb
bundle exec rspec spec/services/supabase_auth_service_spec.rb
```

## Вклад в разработку

Следуйте основным правилам репозитория для внесения вклада.

## Лицензия

MIT
