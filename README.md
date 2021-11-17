# mega_api

## Информация для разработчиков

### Шаги по использованию

- Установить docker.io, docker-compose, migrate и dart.
- Создать .env файл и присвоить DBPASSWORD переменную с паролем от базы данных (По умолчанию файл добавлен в .gitignore)
- ```make build```
- ```make migrate_up``` (Применить миграции)
- ```dart run bin/main.dart```

### Так же понадобится 
- ```make migration_down``` (Откатить миграции)
- ```make log``` (Красивый git log)

### Вы можете использовать официальную SDK для своих проектов
https://github.com/meg4cyberc4t/megasdkdart

### Документация

#### Возможные http коды
```
200 - Всё хорошо
403 - Метод не реализован (Сервер не может выполнить запрос, проверьте правильность введённых данных)
422 - Данные уже используются (Когда вы пытаетесь создать пользователя с login, который уже задействован в системе)
```

#### Авторизация
Токен авторизации - auth_token
Токен перезагрузки - refresh_token
Авторизация в свою очередь проходит через JWT токены. При авторизации пользователя вы получите пару токенов: ```auth_token``` и ```refresh_token```.</br>
Токен авторизации имеет срок жизни в 15 минут, с помощью него сервер вас идентифицирует и позволяет получить данные. При каждом запросе, кроме авторизации, вы должны добавлять его в заголовок запроса _Authorization_. </br>
Как только токен авторизации закончится, вам надо его перезагрузить, используя метод ```/auth/reload-token``` и передавая токен перезагрузки в тело запроса. </br>
**Важно!** Токен перезагрузки тоже имеет своё время жизни (примерно 15 дней), а так же лишь одну возможность перезагрузить токен (при перезагрузке вы получаете новую пару токенов). Если вы не будете своевременно перезагружать токены, в один момент вам предстоит залогинить пользователя заново.

### Метод регистрации: 
#### Path
```/auth/sign-up```
#### Method
```POST```
#### Body example
```json
{
  "first_name": "yourfistname",
  "last_name": "yourfavoritecolor",
  "login": "yourloginhere",
  "password": "yourpasswordhere",
  "color": 0
}
```
#### Answer example
```json
{
  "id": 12345678,
  "auth_token": "yourauthtoken",
  "refresh_token":  "yourrefreshtoken"
}
```
##### **Важно!** передавайте в color HEX число вашего любимого цвета в десятичном формате. (0 <= color <= 16777215)
---
### Метод авторизации: 
#### Path
```/auth/sign-in```
#### Method
```POST```
#### Body example
```json
{
  "login": "yourloginhere",
  "password": "yourpasswordhere"
}
```
#### Answer example
```json
{
  "id": 12345678,
  "auth_token": "yourauthtoken",
  "refresh_token":  "yourrefreshtoken"   
}
```
---
### Метод перезагрузки токенов: 
#### Path
```/auth/reload-token```
#### Method
```POST```
#### Body example
```json
{
  "refresh_token": "yourlongrefreshtoken"
}
```
#### Answer example
```json
{
  "id": 12345678,
  "auth_token": "yourauthtoken",
  "refresh_token":  "yourrefreshtoken"    
}
```
---
