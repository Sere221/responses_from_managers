-- В задании написано вывести менеджеров и его среднее время ответа
SELECT q6.name_mop,
	   ROUND(EXTRACT(HOUR from q5.avg_time_diff) * 60 + EXTRACT(MINUTE from q5.avg_time_diff) + EXTRACT(SECOND FROM q5.avg_time_diff) / 60, 1) AS avg_minutes_for_answer -- Среднее время будет извлечен в минутах
FROM (
	-- Подзапрос для вычисления ср. времени ответа на исх. сообщения
	SELECT q4.created_by, AVG(q4.time_diff) AS avg_time_diff
	FROM (
		-- Подзапрос для вычисления времени между сообщениями
		SELECT * FROM (
			SELECT q2.message_id, q2.type, q2.entity_id, q2.created_by, q2.created_at_datetime, q2.prev_datetime,
	        (CASE 
			-- Условие для расчета времени с учетом рабочего времени
	   	    WHEN (q2.prev_datetime::time BETWEEN '00:00:00' AND '09:30:00') AND q2.created_at_datetime::time >= '09:30:00'
			-- Если предыдущее сообщение было до 9:30, вычитаем 9:30
			THEN q2.created_at_datetime::time - '09:30:00'
    			WHEN q2.prev_datetime < date_trunc('day', q2.created_at_datetime) AND q2.created_at_datetime >= date_trunc('day', q2.created_at_datetime) + INTERVAL '09:30:00'
				-- Если предыдущее сообщение было до начала рабочего дня, вычитаем 9:30
				THEN (q2.created_at_datetime - q2.prev_datetime - INTERVAL '09:30:00')
				-- Иначе просто вычитаем время из предыдущего сообщения
    			ELSE (q2.created_at_datetime - q2.prev_datetime)
	            END) AS time_diff -- Разница во времени между сообщениями
            FROM(
				-- Подзапрос для извлечения данных о сообщениях
				SELECT q1.message_id, q1.type, q1.entity_id, q1.created_by, q1.created_at_datetime,
	            (CASE
				-- Определение времени предыдущего сообщения
	   	        WHEN q1.type != LAG(q1.type)
					OVER (PARTITION BY q1.entity_id ORDER BY q1.created_at_datetime) AND q1.type = 'outgoing_chat_message'
				-- Получаем время предыдущего сообщения
				THEN LAG(q1.created_at_datetime)
					OVER (PARTITION BY q1.entity_id ORDER BY q1.created_at_datetime)
				-- Если тип сообщения не изменился или сообщение не исходящее, вернуть NULL
	   	        ELSE null END) AS prev_datetime 
                FROM (
					-- Подзапрос для извлечения данных о сообщениях
					SELECT message_id,
       	                (CASE 
						-- Если сообщение от пользователя, то сообщение входящее
       	   		        WHEN created_by = 0
						THEN 'incoming_chat_message' 
       	   	            ELSE type END) AS type,
                        entity_id, created_by,
						TO_TIMESTAMP(created_at) AS created_at_datetime
                        FROM test.chat_messages) AS q1 -- Извлечение данных из таблицы сообщений
                ORDER BY q1.entity_id, q1.created_at_datetime) AS q2		  
		) AS q3 -- Отсортированная таблица по id и времени
    WHERE (q3.created_at_datetime::time NOT BETWEEN '00:00:00' AND '09:30:00')
	AND (q3.type = 'outgoing_chat_message')
	AND (q3.time_diff IS NOT NULL)) q4
	GROUP BY q4.created_by -- Группировка по ID менеджера
	ORDER BY avg_time_diff) AS q5 -- Сортировка по ср. времени ответа
RIGHT JOIN (
	-- Подзапрос для извлечение имена менеджеров
	SELECT mop_id, name_mop
	FROM test.managers) AS q6 -- Объединение с test.manager
ON q5.created_by = q6.mop_id
ORDER BY  avg_minutes_for_answer -- Сортировка по ср. времени ответа
