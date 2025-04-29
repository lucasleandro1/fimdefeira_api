# syntax=docker/dockerfile:1

# Use a imagem oficial do Ruby
FROM ruby:3.2.2

# Define o diretório padrão no container
WORKDIR /app

# Instala dependências do sistema
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs yarn sqlite3

# Copia os arquivos de Gemfile e instala as gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia o restante da aplicação
COPY . .

# Expõe a porta usada pelo Rails
EXPOSE 3000

# Comando padrão para iniciar o servidor Rails
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p 3000"]
