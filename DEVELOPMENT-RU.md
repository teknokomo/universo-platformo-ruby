# Руководство по разработке

Это руководство содержит подробные инструкции по настройке и разработке Universo Platformo Ruby.

## Требования

### Необходимое программное обеспечение

- **Ruby**: 3.2.3 или выше
  - Проверка версии: `ruby --version`
  - Установка через [rbenv](https://github.com/rbenv/rbenv) или [rvm](https://rvm.io/)
- **PostgreSQL**: 14 или выше (через Supabase)
- **Bundler**: Последняя версия
  - Установка: `gem install bundler`
- **Node.js**: 18 или выше (для компиляции ресурсов)
  - Проверка версии: `node --version`
- **Git**: Последняя версия

### Опциональное программное обеспечение

- **Redis**: Для фоновых задач и ActionCable
- **Docker**: Для контейнеризованной разработки

## Первоначальная настройка

### 1. Клонирование и переход

```bash
git clone https://github.com/teknokomo/universo-platformo-ruby.git
cd universo-platformo-ruby
```

### 2. Установка зависимостей Ruby

```bash
# Установите bundler, если ещё не установлен
gem install bundler

# Установите зависимости проекта
bundle install
```

### 3. Настройка переменных окружения

```bash
# Скопируйте файл примера окружения
cp .env.example .env

# Отредактируйте .env с вашими реальными значениями
# Вам понадобятся учётные данные Supabase с https://supabase.com
```

Обязательные переменные окружения:
- `SUPABASE_URL`: URL вашего проекта Supabase
- `SUPABASE_KEY`: Ваш публичный/anon ключ Supabase
- `DATABASE_URL`: Строка подключения PostgreSQL из Supabase
- `SECRET_KEY_BASE`: Сгенерируйте с помощью `rails secret`

### 4. Настройка базы данных

```bash
# Создайте базу данных
rails db:create

# Запустите миграции
rails db:migrate

# Загрузите начальные данные (опционально)
rails db:seed
```

### 5. Запуск приложения

```bash
# Запустите сервер Rails
rails server

# Или используйте короткую форму
rails s
```

Откройте `http://localhost:3000` в браузере.

## Процесс разработки

### Создание новой функции

1. **Создайте Issue**
   - Следуйте рекомендациям в `.github/instructions/github-issues.md`
   - Включите описание на английском с переводом на русский в спойлере
   - Примените соответствующие метки

2. **Создайте feature branch**
   ```bash
   git checkout -b feature/название-вашей-функции
   ```

3. **Разработка**
   - Пишите код, следуя соглашениям Rails
   - Добавьте тесты для новой функциональности
   - Обновите документацию

4. **Тестирование**
   ```bash
   # Запустите все тесты
   bundle exec rspec
   
   # Запустите конкретный файл теста
   bundle exec rspec spec/models/cluster_spec.rb
   
   # Запустите с покрытием
   COVERAGE=true bundle exec rspec
   ```

5. **Проверки качества кода**
   ```bash
   # Запустите линтер
   bundle exec rubocop
   
   # Автоматическое исправление проблем
   bundle exec rubocop -A
   
   # Проверка безопасности
   bundle exec brakeman
   
   # Аудит зависимостей
   bundle exec bundle-audit check --update
   ```

6. **Фиксация и отправка**
   ```bash
   git add .
   git commit -m "Add feature: описание"
   git push origin feature/название-вашей-функции
   ```

7. **Создайте Pull Request**
   - Следуйте рекомендациям в `.github/instructions/github-pr.md`
   - Включите описание на английском с переводом на русский
   - Свяжите с соответствующим Issue

### Создание нового пакета

Пакеты следуют структуре монорепозитория с суффиксами `-frt` (фронтенд) и `-srv` (сервер).

```bash
# Создайте структуру пакета
mkdir -p packages/название-функции-srv/base
mkdir -p packages/название-функции-frt/base

# Создайте файлы README пакета
touch packages/название-функции-srv/README.md
touch packages/название-функции-srv/README-RU.md
touch packages/название-функции-frt/README.md
touch packages/название-функции-frt/README-RU.md
```

Для Rails engines:

```bash
# Создайте новый engine
cd packages
rails plugin new название-функции-srv --mountable
cd ..
```

## Тестирование

### Запуск тестов

```bash
# Все тесты
bundle exec rspec

# Конкретная директория
bundle exec rspec spec/models

# Конкретный файл
bundle exec rspec spec/models/cluster_spec.rb

# Конкретный тест
bundle exec rspec spec/models/cluster_spec.rb:15

# С форматом документации
bundle exec rspec --format documentation

# С отчётом о покрытии
COVERAGE=true bundle exec rspec
```

### Написание тестов

Следуйте лучшим практикам RSpec:

```ruby
# spec/models/cluster_spec.rb
require 'rails_helper'

RSpec.describe Cluster, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:domains).dependent(:destroy) }
  end

  describe '#active?' do
    it 'returns true when cluster is active' do
      cluster = create(:cluster, status: 'active')
      expect(cluster.active?).to be true
    end
  end
end
```

## Качество кода

### Конфигурация RuboCop

RuboCop настроен в `.rubocop.yml`. Ключевые правила:

- Следуйте руководству по стилю Ruby
- Максимальная длина строки: 120 символов
- Используйте двойные кавычки для строк
- Предпочитайте функциональные методы

### Запуск RuboCop

```bash
# Проверьте все файлы
bundle exec rubocop

# Автоматическое исправление безопасных проблем
bundle exec rubocop -A

# Автоматическое исправление всех проблем (используйте с осторожностью)
bundle exec rubocop -a

# Проверьте конкретный файл
bundle exec rubocop app/models/cluster.rb
```

### Проверки безопасности

```bash
# Brakeman - статический анализ безопасности
bundle exec brakeman

# Bundle Audit - проверка уязвимых зависимостей
bundle exec bundle-audit check --update
```

## Управление базой данных

### Миграции

```bash
# Создайте новую миграцию
rails generate migration AddFieldToModel field:type

# Запустите ожидающие миграции
rails db:migrate

# Откатите последнюю миграцию
rails db:rollback

# Сброс базы данных (ВНИМАНИЕ: деструктивно)
rails db:reset

# Проверьте статус миграций
rails db:migrate:status
```

### Seeds

```bash
# Загрузите начальные данные
rails db:seed

# Сброс и загрузка начальных данных
rails db:reset
```

## Интернационализация

### Добавление переводов

1. Добавьте ключи в файлы локалей:

```yaml
# config/locales/en.yml
en:
  clusters:
    title: "Clusters"
    create: "Create Cluster"
```

```yaml
# config/locales/ru.yml
ru:
  clusters:
    title: "Кластеры"
    create: "Создать кластер"
```

2. Используйте в представлениях:

```erb
<h1><%= t('clusters.title') %></h1>
<%= link_to t('clusters.create'), new_cluster_path %>
```

### Переводы документации

- Всегда обновляйте как README.md, так и README-RU.md
- Поддерживайте идентичное количество строк
- Следуйте рекомендациям в `.github/instructions/i18n-docs.md`

## Типичные задачи

### Консоль

```bash
# Откройте консоль Rails
rails console

# Или используйте короткую форму
rails c

# Консоль production (используйте с осторожностью)
RAILS_ENV=production rails console
```

### Маршруты

```bash
# Список всех маршрутов
rails routes

# Поиск маршрутов
rails routes | grep cluster

# Расширенная информация о маршрутах
rails routes --expanded
```

### Фоновые задачи

```bash
# Запустите Sidekiq
bundle exec sidekiq

# С конкретной очередью
bundle exec sidekiq -q default -q mailers
```

## Устранение неполадок

### Частые проблемы

1. **Неудача Bundle Install**
   ```bash
   # Обновите bundler
   gem install bundler
   
   # Очистите и переустановите
   bundle clean --force
   bundle install
   ```

2. **Проблемы с подключением к базе данных**
   - Проверьте DATABASE_URL в .env
   - Убедитесь, что проект Supabase запущен
   - Проверьте сетевое подключение

3. **Проблемы с компиляцией ресурсов**
   ```bash
   # Очистите кэш ресурсов
   rails assets:clobber
   
   # Прекомпилируйте ресурсы
   rails assets:precompile
   ```

4. **Сбои тестов**
   ```bash
   # Сбросьте тестовую базу данных
   RAILS_ENV=test rails db:reset
   
   # Очистите тестовый кэш
   rails tmp:clear
   ```

### Получение помощи

- Проверьте [Конституцию](/.specify/memory/constitution.md) для архитектурных решений
- Просмотрите [Спецификации](/specs/) для деталей функций
- Обратитесь к [Инструкциям GitHub](/.github/instructions/) для workflows
- Откройте Issue для багов или запросов функций

## Лучшие практики

### Организация кода

- Строго следуйте паттерну MVC
- Используйте сервисные объекты для сложной бизнес-логики
- Держите контроллеры тонкими
- Используйте concerns для общего поведения
- Организуйте код по функциям (пакеты)

### Git Workflow

- Создавайте feature branches из main
- Пишите чёткие сообщения коммитов
- Сжимайте коммиты перед слиянием
- Держите коммиты сфокусированными и атомарными

### Документация

- Обновляйте файлы README при добавлении функций
- Документируйте публичные API
- Добавляйте комментарии к коду для сложной логики
- Поддерживайте версии как на английском, так и на русском

### Производительность

- Добавляйте индексы базы данных для часто запрашиваемых столбцов
- Используйте eager loading, чтобы избежать запросов N+1
- Кэшируйте дорогие операции
- Отслеживайте с помощью rack-mini-profiler в разработке

## Дополнительные ресурсы

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [RSpec Documentation](https://rspec.info/)
- [Supabase Documentation](https://supabase.com/docs)
- [ViewComponent Guide](https://viewcomponent.org/)
- [Tailwind CSS Documentation](https://tailwindcss.com/)
