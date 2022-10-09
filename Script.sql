-- CREATE-запросы
CREATE TABLE IF NOT EXISTS FIO_person (
	ID SERIAL PRIMARY KEY,
	FIO VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS Salary (
	ID SERIAL PRIMARY KEY,
	Person_ID INTEGER UNIQUE NOT NULL REFERENCES FIO_person(ID),
	Value INTEGER NOT NULL
); 

CREATE TABLE IF NOT EXISTS JobPosition (
	Position_ID SERIAL PRIMARY KEY,
	Person_ID INTEGER NOT NULL REFERENCES FIO_person(ID),
	NamePosition VARCHAR(100) NOT NULL,
	Duration INTEGER NOT NULL CONSTRAINT job_duration CHECK (Duration > -1)
);

-- INSERT-запросы
INSERT INTO fio_person (FIO)
VALUES 
	('Петров Максим Егорович'),
	('Петров Максим Игоревич'),
	('Иванов Иван Сергеевич'),
	('Иванова Анна Витальнвна'),
	('Синицына Наталья Владимировна');

INSERT INTO Salary (Person_ID, Value)
VALUES 
	(1, 5000),
	(2, 9999),
	(3, 10000),
	(4, 10001),
	(5, 20000);

INSERT INTO JobPosition (Person_ID, NamePosition, Duration)
VALUES 
	(1, 'Разработчик', 0),
	(2, 'Тестировщик', 1),
	(3, 'Маркетолог', 5),
	(4, 'Директор', 11),
	(5, 'Разработчик', 10);
	
-- SELECT-запросы
-- Получить список всех сотрудников с ФИО "Петров Максим Егорович".
SELECT * FROM FIO_person
WHERE FIO = 'Петров Максим Егорович'; 

-- Получить список всех сотрудников по имени Иван.
SELECT * FROM FIO_person
WHERE FIO LIKE '% Иван %';

-- Получить список всех ФИО сотрудников по должности «Разработчик» с зарплатой больше 10 000 рублей.
SELECT FIO FROM  FIO_person AS fio
LEFT JOIN JobPosition AS jp ON jp.person_id = fio.id 
LEFT JOIN salary AS s ON s.person_id = fio.id 
WHERE jp.NamePosition = 'Разработчик' AND s.Value > 10000;

-- Получить отсортированный в алфавитном порядке список всех существующих должностей в компании.
SELECT DISTINCT NamePosition FROM JobPosition
ORDER BY NamePosition;

-- Вывести список, содержащий ФИО, ЗП, должность и кол-во лет в должности для сотрудников, которые проработали от 1 до 10 лет (если имеется в виду ВКЛЮЧИТЕЛЬНО 1-10 лет).
SELECT fio.FIO, s.Value, jp.NamePosition, jp.Duration FROM FIO_person AS fio
LEFT JOIN Salary AS s ON s.person_id = fio.id 
LEFT JOIN JobPosition AS jp ON jp.person_id = fio.id 
WHERE Duration BETWEEN 1 AND 10;