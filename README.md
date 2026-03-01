# Universo Platformo Ruby

Ruby on Rails implementation of Universo Platformo — a modular platform for metaverses, clusters, and digital resources.

## Project Status

🚀 **Active Development** — Start pages and Supabase authentication are implemented.

This release delivers the guest landing page, the authenticated onboarding page, and a complete  
Supabase authentication flow that runs entirely through the Rails backend.

## How Supabase Integration Works

**The frontend never talks to Supabase directly.** All authentication calls go through the Rails backend:

```
Browser → Rails (SessionsController / Api::V1::AuthController) → Supabase Auth API
```

`SupabaseAuthService` handles all communication with the Supabase REST API using Ruby's  
built-in `Net::HTTP`. Credentials (`SUPABASE_URL`, `SUPABASE_KEY`) live only on the server.

## Architecture

### Package Structure

Feature code lives in the `packages/` directory following a monorepo layout:

```
packages/
├── start-frt/base/   # Guest and authenticated start pages
└── auth-frt/base/    # Authentication UI (sign-in / sign-up)
```

### Application Layer (root `app/`)

| Path | Purpose |
|------|---------|
| `app/controllers/start_controller.rb` | Routes `/` to guest or authenticated page |
| `app/controllers/auth/sessions_controller.rb` | HTML form sign-in, sign-up, sign-out |
| `app/controllers/api/v1/auth_controller.rb` | JSON API for authentication |
| `app/services/supabase_auth_service.rb` | Supabase HTTP client (backend only) |
| `app/views/start/guest.html.erb` | Landing page for unauthenticated visitors |
| `app/views/start/authenticated.html.erb` | Onboarding wizard for signed-in users |
| `app/views/auth/sessions/new.html.erb` | Sign-in form |
| `app/views/auth/sessions/sign_up.html.erb` | Sign-up form |

## Pages

| URL | Auth required | Description |
|-----|--------------|-------------|
| `GET /` | No | Redirects to `/start/guest` or `/start/authenticated` |
| `GET /start/guest` | No | Hero section + 4 product cards + footer |
| `GET /start/authenticated` | Yes | Multi-step onboarding wizard |
| `GET /auth/sign-in` | No | Sign-in form |
| `GET /auth/sign-up` | No | Sign-up / registration form |
| `POST /auth/sign-in` | No | Process sign-in |
| `POST /auth/sign-up` | No | Process registration |
| `DELETE /auth/sign-out` | Yes | Sign-out |
| `GET /api/v1/auth/csrf` | No | CSRF token for JSON clients |
| `GET /api/v1/auth/me` | No | Current user info (JSON) |

## Technology Stack

- **Runtime**: Ruby 3.2+
- **Framework**: Ruby on Rails 7.1
- **Database**: PostgreSQL (Supabase)
- **Authentication**: Supabase Auth (via `Net::HTTP`, no SDK)
- **Frontend**: Tailwind CSS, Turbo, Stimulus, Importmap
- **Testing**: RSpec, WebMock, Shoulda Matchers
- **Code quality**: RuboCop, Brakeman, Bundler Audit
- **i18n**: English and Russian locales (`config/locales/en.yml`, `ru.yml`)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/teknokomo/universo-platformo-ruby.git
cd universo-platformo-ruby
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Configure Environment

```bash
cp .env.example .env
```

Edit `.env` and fill in your Supabase project values:

```dotenv
SUPABASE_URL=https://<your-project-ref>.supabase.co
SUPABASE_KEY=<your-supabase-anon-key>
DATABASE_URL=postgresql://postgres:<password>@db.<project-ref>.supabase.co:5432/postgres
SECRET_KEY_BASE=<run: bundle exec rails secret>
```

### 4. Build CSS and Start the Server

```bash
bundle exec rails tailwindcss:build
bundle exec rails server
```

Open `http://localhost:3000` in your browser.

## Development

### Running Tests

```bash
# All tests
bundle exec rspec

# Specific file
bundle exec rspec spec/requests/auth_spec.rb

# With coverage
COVERAGE=true bundle exec rspec
```

### Code Quality

```bash
bundle exec rubocop                        # Linter
bundle exec brakeman                       # Security scanner
bundle exec bundle-audit check --update    # Dependency audit
```

## Security Notes

- **CSRF protection**: `protect_from_forgery with: :exception` for all requests.  
  JSON clients must obtain a token via `GET /api/v1/auth/csrf` and send `X-CSRF-Token`.
- **Session fixation**: `reset_session` is called before storing new credentials  
  on every successful sign-in or sign-up.
- **No secrets in browser**: Supabase credentials and tokens exist only in server  
  environment variables and session storage — never rendered into HTML or JavaScript.
- **SSL verification**: `OpenSSL::SSL::VERIFY_PEER` is enforced for Supabase calls.

## Internationalization

UI text uses Rails I18n. Locale files are in `config/locales/`:

- `en.yml` — English (default)
- `ru.yml` — Russian

## Contributing

1. Read the guidelines in `.github/instructions/`
2. Create an Issue using the provided templates
3. Create a feature branch from your Issue
4. Submit a Pull Request following the PR guidelines
5. Ensure all tests pass and code quality checks succeed

## Reference Implementation

This project is inspired by [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react)  
and replicates its architecture using pure Ruby on Rails best practices.

## License

MIT License — see `LICENSE` file for details.

## Links

- **React reference**: [universo-platformo-react](https://github.com/teknokomo/universo-platformo-react)
- **Documentation**: [docs.universo.pro](https://docs.universo.pro) *(coming soon)*
- **Website**: [universo.pro](https://universo.pro) *(coming soon)*
