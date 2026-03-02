# start-frt Package

Start pages frontend package for Universo Platformo Ruby.

## Overview

This package provides the start pages for the Universo Platformo application:
- Guest start page for non-authenticated users (landing page with hero section and product cards)
- Authenticated start page for logged-in users (onboarding wizard)

## Structure

```
base/
├── README.md           # Package documentation (EN)
└── README-RU.md        # Package documentation (RU)
```

The implementation code lives in the root Rails application:

| Root `app/` path | Description |
|------|---------|
| `app/controllers/start_controller.rb` | StartController (root redirect + pages) |
| `app/views/start/guest.html.erb` | Guest landing page ERB template |
| `app/views/start/authenticated.html.erb` | Authenticated onboarding wizard ERB template |

## Pages

### Guest Start Page (`/start/guest`)
Displayed for non-authenticated users. Shows:
- Navigation with sign-in/sign-up links
- Hero section with title and call-to-action button
- 4 product cards (Universo ecosystem)
- Footer with contact information

### Authenticated Start Page (`/start/authenticated`)
Displayed for authenticated users. Shows:
- Navigation with user email and sign-out button
- Multi-step onboarding wizard (Welcome → Interests → Completion)
- Footer with contact information

## Routes

```ruby
root "start#index"                          # Redirects based on auth status

get :guest, controller: :start, as: :start_guest
get :authenticated, controller: :start, as: :start_authenticated
```

## Dependencies

- Ruby on Rails 7.1+
- tailwindcss-rails for styling
- i18n with en/ru locale files

## Testing

```bash
bundle exec rspec spec/requests/start_spec.rb
```

## Contributing

Follow the main repository guidelines for contributing.

## License

MIT
