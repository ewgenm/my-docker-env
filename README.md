Клонируем \n
  git clone https://github.com/ewgenm/my-docker-env.git
переходим в папку
  cd my-docker-env
Запустим
  docker-compose up -d
Проверьте есть ли папка projects. Если нет, то создайте. В эту папку можно положить папки с проектами. 
Создайте папку, /test/, она будет доступна по адресу http:\\test.test, после того как пропишете в .hosts - 127.0.0.1 test.test
Для доступа к postgres - localhost:5432/laravel_user/laravel_password
Для доступа к консоли
 docker compose exec web bash  
