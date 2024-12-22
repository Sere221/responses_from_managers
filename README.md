# responses_from_managers
У вас есть доступ к базе данных Отдела продаж (PostgreSQL), куда загружаются данные об ответах менеджеров в сделках в amoCRM. Диалог с каждым клиентом ведётся внутри своей сделки.

### Задание: 
1. Написать SQL-запрос, который будет рассчитывать среднее время ответа для каждого менеджера/пары менеджеров. 
Расчёт должен учитывать следующее: 
• если в диалоге идут несколько сообщений подряд от клиента или менеджера, то при расчёте времени ответа надо учитывать только первое сообщение из каждого блока; 
• менеджеры работают с `09:30` до `00:00`, поэтому нерабочее время не должно учитываться в расчёте среднего времени ответа, т.е. если клиент написал в 23:59, а менеджер ответил в `09:30` – время ответа равно одной минуте; 
• ответы на сообщения, пришедшие ночью также нужно учитывать.

2. На основе базы данных из первого задания построить дашборд в `DataLens` с данными о среднем времени ответа менеджеров. Виды визуализаций и структура отчёта произвольные, однако необходима возможность фильтровать данные по дням, менеджерам и начальникам отделов продаж.

3. Решить первое задание при помощи `Python` и библиотеки `pandas`

### Решение:
1. [https://datalens.yandex/7tg5wwtwjswat] или [sql_answer.sql]
2. [https://datalens.yandex/cyltm033e680y]
3. 

