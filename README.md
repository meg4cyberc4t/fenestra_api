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
201 - Всё хорошо, но нет информации, которую серверу надо вернуть (aka. Правильный запрос с пустым ответом)
202 - Принято
401 - Без авторизации (Перезагрузите auth_token или снова выполните авторизацию пользователя)
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
```/auth/signUp```
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
```/auth/signIn```
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
```/auth/reloadToken```
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
### Метод перезагрузки токенов: 
#### Path
```/auth/checkCorrectLogin```
#### Method
```POST```
#### Body example
```json
{
  "login": "yourtestlogin"
}
```
---
#### Пользователи
Mega представляет из себя единую систему авторизации для всех сервисов. Любой, кто пользуется сервисами системы, будет записан в базу данных и о нём можно получить информацию. </br>
Структура пользователя представляет из себя:
```dart
  int id; // id пользователя (Уникальное значение)
  String firstName; // Имя пользователя
  String lastName; // Фамилия пользователя
  String login; // Логин (Уникальное значение)
  int color; // Цвет пользователя
```
! Пользователи становятся коллегами, только когда взаимноподпишутся !

### Метод получения информации о авторизированном пользователе: 
#### Path
```/users/```
#### Method
```GET```
#### Answer example
```json
{
  "id": 1,
  "first_name": "yourfirstname",
  "last_name": "yourlastname",
  "login": "login",
  "color": 0
}
```
---
### Метод получения информации о любом пользователе от его id: 
#### Path
```/users/2```
#### Method
```GET```
#### Answer example
```json
{
  "id": 2,
  "first_name": "yourfirstname2",
  "last_name": "yourlastname2",
  "login": "login2",
  "colleagues": [2, 4, 5],
  "subscribers": [6, 7, 8],
  "subscriptions": [9, 10, 11],
  "color": 1
}
```
---
### Метод редактирования информации о пользователе: 
#### Path
```/users/```
#### Method
```PATCH```
#### Body example
```json
{
  "first_name": "yournewfirstname",
  "last_name": "yournewlastname",
  "login": "yournewlogin",
  "password": "yournewpassword",
  "color": 2
}
```
! **Важно:** При смене пароля произойдёт отключение всех перезагрузочных токенов. Не забудьте заново авторизироваться по новому паролю. !
#### Answer example
```json
{
  "id": 2,
  "first_name": "yournewfirstname",
  "last_name": "yournewlastname",
  "login": "yournewlogin",
  "color": 2
}
```
---
### Метод объявления связи с другим пользователем: 
#### Path
```/users/2/relation```
#### Method
```GET``` </br>
Если между вами и пользователем не обнаружено никакой связи -> Вы станете у него в подписчиках, а он в у вас в подписках </br>
Если пользователь на ваш уже подписан -> Вы станете коллегами. </br>
Если вы коллеги -> Связь разрывается, пользователь становится подписанным на вас. </br>
Если вы были подписаны -> Вы отписываетесь. </br>

---

## Notify 
Notify - представляет из себя подразделение сервера с методами для работы с одноименным приложением Notify. </br>
Каждый пользователь может создавать напоминания, менять их, а так же делиться ими между своими коллегами. </br>
Так же пользователь может создавать папки для классификации своих напоминаний, а так же приглашать в эти папки коллег. </br>

### Структура напоминания
```dart
int id; // id напоминания (Уникальное значение)
String title; // Название напоминания
String? description; // Описание напомнания (Может быть null)
int owner; // id создателя напомнания 
int? deadline; // Время дедлайна в timestamp (milliseconds after epoch, может быть null)
int? repeat; // Повторяется ли напоминание (число 0 до 127 включительно, может быть null)
int? folder;  // id папки напоминаний (Может быть null)
```
---
### Метод создания нового напоминания:
#### Path
```/notify/notifications/```
#### Method
```POST```
#### Body example
```json
{
  "title": "title"
  "description": "desc",
  "deadline": 1637154816,
  "repeat" 124,
}
```
! repeat - десятичное отображение повторений. Значение 124 -> в десятичную систему 1111100 -> повторение по будним дням (начало недели с понедельника)!
#### Answer example
```json
{
    "id": 1
}
```
---
### Метод получения напоминания по id:
#### Path
```/notify/notifications/132904669```
#### Method
```GET```
#### Body example
```json
{
    "id": 132904669,
    "title": "yourtitle",
    "description": null,
    "owner": 484911188,
    "deadline": 1637154816,
    "repeat": null,
    "folder": null,
    "invited": []
}
```
---
### Метод получения всех напоминаний:
#### Path
```/notify/notifications/```
#### Method
```GET```
#### Body example
```json
[
    {
        "id": 546433423,
        "title": "yourtitle",
        "description": null,
        "owner": 484911188,
        "deadline": null,
        "repeat": null,
        "folder": null,
    },
]
```
---
### Метод получения всех напоминаний в определённой папке:
#### Path
```/notify/byFolder/1```
#### Method
```GET```
#### Body example
```json
[
    {
        "id": 546433423,
        "title": "yourtitle",
        "description": null,
        "owner": 484911188,
        "deadline": null,
        "repeat": null,
        "folder": null,
    },
]
```
---
### Метод редактирования напоминания:
#### Path
```/notify/notifications/```
#### Method
```PATCH```
#### Body example
```json
{
  "title": "title"
  "description": "desc",
  "deadline": 1637154816,
  "repeat" 124
}
```
! repeat - десятичное отображение повторений. Значение 124 -> в десятичную систему 1111100 -> повторение по будним дням (начало недели с понедельника)!
#### Answer example
```json
{
    "id": 132904669,
    "title": "title",
    "description": "desc",
    "owner": 484911188,
    "deadline": 1637154816,
    "repeat": 124,
    "folder": null,
}
```
---
### Метод удаления напоминания:
#### Path
```/notify/notifications/2```
#### Method
```DELETE```
---
### Метод для того, чтоб поделиться напоминани:
#### Path
```/notify/notifications/1/relation```
#### Method
```POST```
#### Body example
```json
{
  "id": 12345678
}
```
---
### Структура Папки
```dart
int? id; // id папки (уникальное значение)
int owner; // id создателя папки
String title; // Название папки
String? description; // Описание папки
int priority; // Приоритет папки (число от 1 до 3)
```
---
### Метод создания новой папки:
#### Path
```/notify/folders/```
#### Method
```POST```
#### Body example
```json
{
  "title": "title"
  "description": "desc",
  "priority": 1
}
```
#### Answer example
```json
{
    "id": 1
}
```
---
### Метод получения папки по id:
#### Path
```/notify/folders/132904669```
#### Method
```GET```
#### Body example
```json
{
    "id": 1936269559,
    "owner": 484911188,
    "title": "title",
    "description": "desc",
    "priority": 0
}
```
---
### Метод редактирования папки:
#### Path
```/notify/folders/1```
#### Method
```PATCH```
#### Body example
```json
{
  "title": "title",
  "description": "desc",
  "priority": 1
}
```
#### Answer example
```json
{
    "id": 1936269559,
    "owner": 484911188,
    "title": "title",
    "description": "desc",
    "priority": 1
}
```
---
### Метод удаления папки:
#### Path
```/notify/folders/2```
#### Method
```DELETE```
---
### Метод для того, чтоб пригласить пользователя в папку или удалить из неё:
#### Path
```/notify/folders/1/relation```
#### Method
```POST```
#### Body example
```json
{
  "id": 12345678
}
```