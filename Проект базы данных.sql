
SET SEARCH_path TO pesoc;

drop table nationality_language cascade

-- Проектируем базу данных, содержащую три справочника:
--· язык (английский, французский и т. п.);
--· народность (славяне, англосаксы и т. п.);
--· страны (Россия, Германия и т. п.).
--Две таблицы со связями: язык-народность и народность-страна, отношения многие ко многим. Пример таблицы со связями — film_actor.
--Требования к таблицам-справочникам:
--· наличие ограничений первичных ключей.
--· идентификатору сущности должен присваиваться автоинкрементом;
--· наименования сущностей не должны содержать null-значения, не должны допускаться --дубликаты в названиях сущностей.
--Требования к таблицам со связями:
--· наличие ограничений первичных и внешних ключей.

 
SET SEARCH_path TO denegina;


--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ
create table language(
language_id serial primary key unique not null, language varchar(20) unique not null, last_update timestamp not null default current_timestamp);


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ
insert into language (language)
values ('Русский'), ('Английский'), ('Румынский'), ('Иврит'), ('Гагаузский'), ('Белоруский'), ('Эскимосский')

select *
from language


--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ
create table nationality(
nationality_id serial primary key unique not null, nationality varchar(50) not null, last_update timestamp not null default current_timestamp );


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ
insert into nationality (nationality)
values ('Славянин'), ('Англосакс'), ('Цыган'), ('Еврей'), ('Гагауз'), ('Белорус'), ('Эскимос')

select *
from nationality


--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ
create table country(
country_id serial primary key unique not null, country varchar(20) unique not null, last_update timestamp not null default current_timestamp)


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ
insert into country (country)
values ('Россия'), ('Англия'), ('Румыния'), ('Израиль'), ('США'), ('Норвегия'), ('Япония')

select *
from nationality_language


--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ


create table nationality_language(
nationality_id serial not null, language_id serial not null)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert into nationality_language (nationality_id, language_id) 
values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7)


ALTER TABLE nationality_language ADD CONSTRAINT nationality_id_pkey FOREIGN KEY (nationality_id)
 REFERENCES nationality(nationality_id)
 
ALTER TABLE nationality_language drop CONSTRAINT nationality_id_pkey

ALTER TABLE nationality_language ADD CONSTRAINT nationality_id_fkey FOREIGN KEY (nationality_id)
 REFERENCES nationality(nationality_id)
 
 
-- Эта конструкция из трех "альтер тейблов" единая для добавления ключа.
 
 
ALTER TABLE nationality_language ADD CONSTRAINT language_id_pkey FOREIGN KEY (language_id)
 REFERENCES language(language_id)
 
ALTER TABLE nationality_language drop CONSTRAINT language_id_pkey

ALTER TABLE nationality_language ADD CONSTRAINT language_id_fkey FOREIGN KEY (language_id)
 REFERENCES language(language_id)

ALTER TABLE nationality_language
ADD CONSTRAINT pk_my_nationality_language PRIMARY KEY (nationality_id, language_id); 
 

--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

create table nationality_country(
nationality_id serial not null, country_id serial not null)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert into nationality_country (nationality_id, country_id) 
values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7)
 
ALTER TABLE nationality_country ADD CONSTRAINT nationality_id_pkey FOREIGN KEY (nationality_id)
 REFERENCES nationality(nationality_id)
 
ALTER TABLE nationality_country drop CONSTRAINT nationality_id_pkey

ALTER TABLE nationality_country ADD CONSTRAINT nationality_id_fkey FOREIGN KEY (nationality_id)
 REFERENCES nationality(nationality_id)


 ALTER TABLE nationality_country ADD CONSTRAINT country_id_pkey FOREIGN KEY (country_id)
 REFERENCES country(country_id)
 
ALTER TABLE nationality_country drop CONSTRAINT country_id_pkey

ALTER TABLE nationality_country ADD CONSTRAINT country_id_fkey FOREIGN KEY (country_id) references country(country_id)
 
ALTER TABLE nationality_country
ADD CONSTRAINT pk_my_nationality_country PRIMARY KEY (nationality_id, country_id);


select *
from nationality_country



--Создадим новую таблицу film_new со следующими полями:
--·   	film_name - название фильма - тип данных varchar(255) и ограничение not null
--·   	film_year - год выпуска фильма - тип данных integer, условие, что значение должно быть больше 0
--·   	film_rental_rate - стоимость аренды фильма - тип данных numeric(4,2), значение по умолчанию 0.99
--·   	film_duration - длительность фильма в минутах - тип данных integer, ограничение not null и условие, что значение должно быть больше 0

create table film_new (
 film_name varchar(255)not null,
 film_year integer not null check (film_year>0),
 film_rental_rate numeric(4,2) default 0.99,
 film_duration integer not null check (film_duration>0)
 )

--Заполним таблицу film_new данными с помощью SQL-запроса, где колонкам соответствуют массивы данных:
--·       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--·       film_year - array[1994, 1999, 1985, 1994, 1993]
--·       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--·   	  film_duration - array[142, 189, 116, 142, 195]

 insert into film_new (film_name, film_year,film_rental_rate, film_duration )
values 
('The Shawshank Redemption', '1994', '2.99', '142'),
('The Green Mile', '1999', '0.99', '189'),
('Back to the Future', '1985', '1.99', '116'),
('Forrest Gump', '1994', '2.99', '142'),
('Schindlers List', '1993', '3.99', '195')

select *
from film_new

--Обновим стоимость аренды фильмов в таблице film_new с учетом информации, 
--что стоимость аренды всех фильмов поднялась на 1.41

update film_new
set film_rental_rate = (film_rental_rate+1.41)
where film_rental_rate>=0.99


--Фильм с названием "Back to the Future" был снят с проката, 
--удалите строку с этим фильмом из таблицы film_new

delete from film_new
where film_name='Back to the Future'

select *
from film_new


--Добавьте в таблицу film_new запись о новом фильме

insert into film_new (film_name, film_year,film_rental_rate, film_duration )
values 
('The Godfather', '1972', '1.99', '194')


--Выведем все колонки из таблицы film_new, создаем колонку, заполняем ее данными, расчитем часы и выведем данные.

alter table film_new add column film_duration_hors numeric

update film_new 
set film_duration_hors=film_duration
where film_duration_hors is null 

update film_new 
set film_duration_hors = (film_duration_hors / 60)
where film_duration_hors>=100


select film_name, film_year, film_rental_rate, film_duration, (select round (film_duration_hors, 2) as film_duration_hors)
FROM film_new 


--Удалим таблицу film_new

drop table film_new
