# auth-frt Package

Authentication frontend package for Universo Platformo Ruby.

## Overview

This package provides authentication pages for the Universo Platformo application
with Supabase integration via the Rails backend:
- Sign-in page (login form)
- Sign-up page (registration form)

## Structure

```
base/
├── README.md           # Package documentation (EN)
└── README-RU.md        # Package documentation (RU)
```

The implementation code lives in the root Rails application:

| Root `app/` path | Description |
|------|---------|
| `app/controllers/auth/sessions_controller.rb` | Auth::SessionsController (HTML forms) |
| `app/controllers/api/v1/auth_controller.rb` | JSON API for authentication |
| `app/services/supabase_auth_service.rb` | SupabaseAuthService backend integration |
| `app/views/auth/sessions/new.html.erb` | Sign-in form ERB template |
| `app/views/auth/sessions/sign_up.html.erb` | Sign-up form ERB template |

## Pages

### Sign In Page (`/auth/sign-in`)
Login form with email/password fields.
- Validates credentials via SupabaseAuthService
- Stores session on success
- Shows error messages on failure

### Sign Up Page (`/auth/sign-up`)
Registration form with email, password, and confirmation fields.
- Creates new account via SupabaseAuthService
- Handles email confirmation flow
- Shows error messages on failure

## Authentication Flow

```
User → Auth Form → Auth::SessionsController
                 → SupabaseAuthService (HTTP → Supabase REST API)
                 → Session stored server-side
                 → Redirect to start page
```

## Routes

```ruby
get  "auth/sign-in",  to: "auth/sessions#new"
post "auth/sign-in",  to: "auth/sessions#create"
get  "auth/sign-up",  to: "auth/sessions#sign_up"
post "auth/sign-up",  to: "auth/sessions#register"
delete "auth/sign-out", to: "auth/sessions#destroy"
```

## API Endpoints (JSON)

```
GET    /api/v1/auth/csrf      - CSRF token
GET    /api/v1/auth/me        - Current user info
POST   /api/v1/auth/sign-in   - Login
POST   /api/v1/auth/sign-up   - Register
DELETE /api/v1/auth/sign-out  - Logout
```

## Configuration

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key
```

## Dependencies

- Ruby on Rails 7.1+
- Supabase project with Auth enabled
- tailwindcss-rails for styling
- i18n with en/ru locale files

## Testing

```bash
bundle exec rspec spec/requests/auth_spec.rb
bundle exec rspec spec/services/supabase_auth_service_spec.rb
```

## Contributing

Follow the main repository guidelines for contributing.

## License

MIT
