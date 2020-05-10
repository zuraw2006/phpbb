# Unofficial Docker Image for phpBB

## What is phpBB?

phpBB is a free open-source bulletin board written in PHP.

[www.phpbb.com](https://www.phpbb.com/)

## Quick use

### Docker Compose

```shell
$ git clone https://github.com/zuraw2006/phpbb.git
$ cd phpbb/example
$ docker-compose up -d
```

## About this image

This image is for **manual** forum phpBB installation with FastCGI implementation for PHP. So some kind of reverse proxy (such as NGINX, Apache, or other tool which speaks the FastCGI) will be required. I chose NGINX.

After installation, you **must** delete the ```install``` directory. Look at the ```example/after_install.sh``` file.

### phpBB version

```3.3.0```

## Docker Compose

Example ```docker-compose.yml```:

```shell
version: '3'

services:
  phpbb:
    depends_on: 
      - db
    image: zuraw2006/phpbb:3.3.0-php7.4-fpm
    restart: always
    volumes:
      - phpbb:/var/www/html
    networks:
      - app-network

  db:
    image: mariadb:10.4
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_USER: phpbb_user
      MYSQL_PASSWORD: example
      MYSQL_DATABASE: phpbb
    volumes: 
      - dbdata:/var/lib/mysql
    networks:
      - app-network

  webserver:
    depends_on:
      - phpbb
    image: nginx:1.17.10
    restart: always
    ports:
      - "80:80"
    volumes:
      - phpbb:/var/www/html
      - ./nginx-conf:/etc/nginx/conf.d
    networks:
      - app-network

volumes:
  phpbb:
  dbdata:

networks:
  app-network:
    driver: bridge  
```

Run ```docker-compose up -d```, wait for it to initialize completely and visit ```http://localhost```.

## LICENSE

[GNU General Public License v2](http://opensource.org/licenses/gpl-2.0.php)