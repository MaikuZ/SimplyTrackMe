drop schema simplytrackme cascade;
CREATE SCHEMA simplytrackme;

CREATE TABLE simplytrackme.groups (
	id_group             serial  NOT NULL,
	name                 varchar(32)  NOT NULL,
	private              bool  NOT NULL,
	CONSTRAINT pk_group PRIMARY KEY ( id_group )
 );

COMMENT ON COLUMN simplytrackme.groups.private IS 'determine whether the group ought be private or public';

CREATE TABLE simplytrackme.routes (
	name                 varchar(100)  NOT NULL,
	id_route             serial  NOT NULL,
	CONSTRAINT pk_route PRIMARY KEY ( id_route )
 );

CREATE TABLE simplytrackme.type_workouts (
	id_type              serial  NOT NULL,
	name                 varchar(100)  ,
	CONSTRAINT pk_typ_treningu UNIQUE ( id_type ) ,
	CONSTRAINT pk_typ_treningu_0 PRIMARY KEY ( id_type )
 );

CREATE TABLE simplytrackme.users (
	id_user              serial  NOT NULL,
	user_name            varchar(40)  NOT NULL,
	join_date            timestamp  ,
	weight               numeric(4,1) DEFAULT 80 NOT NULL,
	height               numeric(3) DEFAULT 160 NOT NULL,
	sex                  char(1) DEFAULT 'f' NOT NULL,
	age                  numeric(2) DEFAULT 18 NOT NULL,
	full_name            varchar(100)  ,
	CONSTRAINT pk_użytkownicy PRIMARY KEY ( id_user ),
	CONSTRAINT idx_users UNIQUE ( user_name )
 );

ALTER TABLE simplytrackme.users ADD CONSTRAINT ck_1 CHECK ( sex like 'f' or sex like 'm' );

CREATE TABLE simplytrackme.competitions (
	id_competition       serial  NOT NULL,
	name                 varchar(32)  NOT NULL,
	place                varchar(32)  NOT NULL,
	event_date           timestamp  NOT NULL,
	id_type              serial  ,
	distance             numeric(8,2)  NOT NULL,
	CONSTRAINT pk_competition PRIMARY KEY ( id_competition )
 );

CREATE INDEX idx_competition ON simplytrackme.competitions ( id_type );

CREATE TABLE simplytrackme.friends (
	id_friend_b          integer  NOT NULL,
	id_friend_a          integer  NOT NULL,
	CONSTRAINT pk_znajomi UNIQUE ( id_friend_b,id_friend_a )
 );

ALTER TABLE simplytrackme.friends ADD CONSTRAINT ck_0 CHECK ( id_friend_a < id_friend_b );

COMMENT ON CONSTRAINT ck_0 ON simplytrackme.friends IS 'don''t allow redundancy.
If a is friend with b, so is b with a.';

CREATE INDEX idx_znajomi ON simplytrackme.friends ( id_friend_a );

CREATE TABLE simplytrackme.group_members (
	id_user              integer  NOT NULL,
	id_group             integer  NOT NULL,
	CONSTRAINT idx_group_members PRIMARY KEY ( id_user, id_group )
 );

CREATE INDEX idx_group_members_0 ON simplytrackme.group_members ( id_group );

CREATE INDEX idx_group_members_1 ON simplytrackme.group_members ( id_user );

CREATE TABLE simplytrackme.participants (
	id_competition       integer  NOT NULL,
	id_user              integer  NOT NULL,
	time_result          numeric  NOT NULL,
	CONSTRAINT pkey_contestants PRIMARY KEY ( id_competition, id_user )
 );

CREATE INDEX idx_contestants ON simplytrackme.participants ( id_competition );

CREATE INDEX idx_contestants_0 ON simplytrackme.participants ( id_user );

CREATE TABLE simplytrackme.sessions (
	id_session           serial  NOT NULL,
	"type"               integer  NOT NULL,
	begin_time           timestamp  NOT NULL,
	end_time             timestamp  NOT NULL,
	distance             numeric(10,0) DEFAULT 0 NOT NULL,
	elevation            numeric(5,0)  NOT NULL,
	id_owner             integer  NOT NULL,
	id_route             integer  ,
	id_localsession      integer  NOT NULL,
	CONSTRAINT "pk_trening/sesja" PRIMARY KEY ( id_session ),
	CONSTRAINT idx_sessions UNIQUE ( id_owner, id_localsession )
 );

ALTER TABLE simplytrackme.sessions ADD CONSTRAINT ck_2 CHECK ( begin_time<end_time );

CREATE INDEX idx_trening_sesja ON simplytrackme.sessions ( "type" );

CREATE TABLE simplytrackme.type_heartrate_intervals (
	minimum_speed        numeric(4,1)  NOT NULL,
	maximum_speed        numeric(4,1)  ,
	id_type_heartrate    serial  NOT NULL,
	id_type              integer  NOT NULL,
	heartrate            numeric(3,0)  NOT NULL,
	CONSTRAINT pk_type_heartrate PRIMARY KEY ( id_type_heartrate )
 );

ALTER TABLE simplytrackme.type_heartrate_intervals ADD CONSTRAINT ck_3 CHECK ( maximum_speed>minimum_speed );

CREATE INDEX idx_type_heartrate ON simplytrackme.type_heartrate_intervals ( id_type );

CREATE TABLE simplytrackme.user_sessions (
	id_user              integer  NOT NULL,
	id_session           integer  NOT NULL,
	CONSTRAINT idx_user_sessions PRIMARY KEY ( id_user, id_session )
 );

CREATE TABLE simplytrackme.nodes (
	id_node              serial  NOT NULL,
	lat                  numeric(12,10)  NOT NULL,
	lon                  numeric(12,10)  NOT NULL,
	total_distance       numeric(10,0)  NOT NULL,
	duration             numeric(10,0)  NOT NULL,
	elevation            numeric(5,1) DEFAULT 0 NOT NULL,
	id_session           integer  NOT NULL,
	CONSTRAINT idx_nodes PRIMARY KEY ( id_node, id_session )
 );

CREATE INDEX idx_nodes_0 ON simplytrackme.nodes ( id_session );

COMMENT ON TABLE simplytrackme.nodes IS 'node';

COMMENT ON COLUMN simplytrackme.nodes.total_distance IS 'in meters';

COMMENT ON COLUMN simplytrackme.nodes.duration IS 'in seconds';

COMMENT ON COLUMN simplytrackme.nodes.elevation IS 'meters';

ALTER TABLE simplytrackme.friends ADD CONSTRAINT fk_friends FOREIGN KEY ( id_friend_a ) REFERENCES simplytrackme.users( id_user ) ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_friends ON simplytrackme.friends IS '';

ALTER TABLE simplytrackme.friends ADD CONSTRAINT fk_friends_0 FOREIGN KEY ( id_friend_b ) REFERENCES simplytrackme.users( id_user ) ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_friends_0 ON simplytrackme.friends IS '';

ALTER TABLE simplytrackme.group_members ADD CONSTRAINT fk_group_members FOREIGN KEY ( id_group ) REFERENCES simplytrackme.groups( id_group ) ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_group_members ON simplytrackme.group_members IS '';

ALTER TABLE simplytrackme.group_members ADD CONSTRAINT fk_group_members_0 FOREIGN KEY ( id_user ) REFERENCES simplytrackme.users( id_user ) ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_group_members_0 ON simplytrackme.group_members IS '';

ALTER TABLE simplytrackme.nodes ADD CONSTRAINT fk_nodes FOREIGN KEY ( id_session ) REFERENCES simplytrackme.sessions( id_session ) ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_nodes ON simplytrackme.nodes IS '';

ALTER TABLE simplytrackme.participants ADD CONSTRAINT fk_contestants FOREIGN KEY ( id_competition ) REFERENCES simplytrackme.competitions( id_competition ) ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_contestants ON simplytrackme.participants IS '';

ALTER TABLE simplytrackme.participants ADD CONSTRAINT fk_contestants_0 FOREIGN KEY ( id_user ) REFERENCES simplytrackme.users( id_user ) ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_contestants_0 ON simplytrackme.participants IS '';

ALTER TABLE simplytrackme.sessions ADD CONSTRAINT typ_treningu FOREIGN KEY ( "type" ) REFERENCES simplytrackme.type_workouts( id_type ) ON DELETE SET NULL;

COMMENT ON CONSTRAINT typ_treningu ON simplytrackme.sessions IS '';

ALTER TABLE simplytrackme.sessions ADD CONSTRAINT fk_sessions FOREIGN KEY ( id_owner ) REFERENCES simplytrackme.users( id_user ) ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_sessions ON simplytrackme.sessions IS '';

ALTER TABLE simplytrackme.sessions ADD CONSTRAINT fk_sessions_0 FOREIGN KEY ( id_route ) REFERENCES simplytrackme.routes( id_route );

COMMENT ON CONSTRAINT fk_sessions_0 ON simplytrackme.sessions IS '';

ALTER TABLE simplytrackme.type_heartrate_intervals ADD CONSTRAINT fk_type_heartrate FOREIGN KEY ( id_type ) REFERENCES simplytrackme.type_workouts( id_type ) ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_type_heartrate ON simplytrackme.type_heartrate_intervals IS '';

ALTER TABLE simplytrackme.user_sessions ADD CONSTRAINT fk_user_session FOREIGN KEY ( id_session ) REFERENCES simplytrackme.sessions( id_session ) ON DELETE CASCADE;

ALTER TABLE simplytrackme.user_sessions ADD CONSTRAINT fk_user_sessions FOREIGN KEY ( id_user ) REFERENCES simplytrackme.users( id_user ) ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_user_sessions ON simplytrackme.user_sessions IS '';

-- delete group members on delete to group
CREATE OR REPLACE FUNCTION check_if_empty_group()
  RETURNS TRIGGER AS
$$
DECLARE
  counter INTEGER;
BEGIN
  counter = (SELECT count(*)
             FROM simplytrackme.group_members
             WHERE id_group = old.id_group);
  IF counter = 0
  THEN
    DELETE FROM simplytrackme.groups
    WHERE id_group = old.id_group;
  END IF;
  RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER delete_group
  AFTER DELETE ON simplytrackme.group_members
  FOR EACH ROW
    EXECUTE PROCEDURE check_if_empty_group();
----

-- delete participants on delete to competition
CREATE OR REPLACE FUNCTION check_if_empty_competition()
  RETURNS TRIGGER AS
$$
DECLARE
  counter INTEGER;
BEGIN
  counter = (SELECT count(*)
             FROM simplytrackme.participants
             WHERE id_user = old.id_user);
  IF counter = 0
  THEN
    DELETE FROM simplytrackme.competitions
    WHERE id_competition = old.id_competition;
  END IF;
  RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER delete_competition
  AFTER DELETE ON simplytrackme.participants
  FOR EACH ROW
    EXECUTE PROCEDURE check_if_empty_competition();
----

-- delete session completly if owner decides to delete it
CREATE OR REPLACE FUNCTION delete_if_owner()
  RETURNS TRIGGER AS
$$
BEGIN
  IF (old.id_user = (SELECT id_owner FROM simplytrackme.sessions WHERE id_session = old.id_session)) THEN
    DELETE FROM simplytrackme.sessions WHERE id_session = old.id_session;
  END IF;
  return null;
END;
$$
LANGUAGE plpgsql;

CREATE trigger user_owner_delete after delete on simplytrackme.user_sessions
for each row execute procedure delete_if_owner();

-- don't allow adding session which happened before user joined
CREATE FUNCTION check_session_date() RETURNS trigger AS
$$
DECLARE
  time_1 TIMESTAMP;
  time_2 TIMESTAMP;
BEGIN
  time_1 = (SELECT join_date FROM simplytrackme.users WHERE id_user = NEW.id_user)::TIMESTAMP;
  time_2 = (SELECT begin_time FROM simplytrackme.sessions WHERE id_session = NEW.id_session)::TIMESTAMP;
  IF time_2 < time_1 THEN
    RAISE EXCEPTION 'Session timestamp must be greater than user join timestamp';
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER check_session_date BEFORE INSERT OR UPDATE ON simplytrackme.user_sessions
    FOR EACH ROW EXECUTE PROCEDURE check_session_date();
----

-- some checks
ALTER TABLE simplytrackme.users ADD CONSTRAINT join_date_not_null CHECK (join_date NOTNULL);


----

-- creating ranking of sum of distance run in the last (interval)
CREATE OR REPLACE FUNCTION person_distance(interval, _name VARCHAR)
  RETURNS numeric AS
$$
BEGIN
  RETURN (SELECT
    coalesce(sum(distance),0)
  FROM simplytrackme.users
    JOIN simplytrackme.user_sessions us ON simplytrackme.users.id_user = us.id_user
    JOIN simplytrackme.sessions s ON us.id_session = s.id_session
  WHERE current_date - s.begin_time <= $1 AND user_name = _name);
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ranking_distance(INTERVAL)
  RETURNS TABLE(
    _user_name VARCHAR,
    distance   NUMERIC
  ) AS
$$
BEGIN
  RETURN QUERY
  SELECT
    user_name,
    coalesce((SELECT person_distance($1, user_name)), 0)
  FROM simplytrackme.users
  order by 2 desc,1;
END;
$$
LANGUAGE plpgsql;
----

-- male
--Calories Burned = [(Age x 0.2017) — (Weight*0.09036) + (Heart Rate x 0.6309) — 55.0969] x Time / 4.184.

-- female
--Calories Burned = [(Age x 0.074) — (Weight x 0.45359237*0.05741) + (Heart Rate x 0.4472) — 20.4022] x Time / 4.184.

--source : Journal of Sports Sciences - 01-MAR-05 - Prediction of energy expenditure from heart rate monitoring during submaximal exercise.

CREATE OR REPLACE VIEW session_details AS
  SELECT
    user_sessions.id_user,
    users.age,
    users.sex,
    sessions.id_session,
    (users.weight * 2.20462)                                              AS weight,
    type_heartrate_intervals.heartrate                                    AS bpm,
    date_part('epoch' :: TEXT, (sessions.end_time - sessions.begin_time)) AS time_in_secs
  FROM ((((simplytrackme.user_sessions
    LEFT JOIN simplytrackme.users ON ((user_sessions.id_user = users.id_user)))
    LEFT JOIN simplytrackme.sessions ON ((user_sessions.id_session = sessions.id_session)))
    LEFT JOIN simplytrackme.type_workouts ON ((sessions.type = type_workouts.id_type)))
    LEFT JOIN simplytrackme.type_heartrate_intervals ON ((type_workouts.id_type = type_heartrate_intervals.id_type)))
  WHERE (((((3.6 * sessions.distance)) :: DOUBLE PRECISION /
           date_part('epoch', (sessions.end_time - sessions.begin_time)))
          >= (type_heartrate_intervals.minimum_speed) :: DOUBLE PRECISION) AND (
           (((3.6 * sessions.distance)) :: DOUBLE PRECISION /
            date_part('epoch', (sessions.end_time - sessions.begin_time)))
           <= (type_heartrate_intervals.maximum_speed) :: DOUBLE PRECISION));

CREATE OR REPLACE FUNCTION count_calories_woman(user_id INTEGER, session_id INTEGER)
  RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
  result   INTEGER;
  result_2 INTEGER;
BEGIN
  result = (SELECT (age * 0.074 - weight * 0.05741 + bpm * 0.4472 - 20.4022) * (time_in_secs / 60) / 4.184
            FROM session_details
            WHERE user_id = id_user AND id_session = session_id) :: INTEGER;
  result_2 = (SELECT 3 * time_in_secs / 60
              FROM session_details
              WHERE user_id = id_user AND id_session = session_id) :: INTEGER;
  RETURN greatest(result, result_2);
END;
$$;

CREATE OR REPLACE FUNCTION count_calories_man(user_id INTEGER, session_id INTEGER)
  RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
  result   INTEGER;
  result_2 INTEGER;
  DECLARE
BEGIN
  result = (SELECT (age * 0.074 - weight * 0.09036 + bpm * 0.6309 - 55.0969) * (time_in_secs / 60) / 4.184
            FROM session_details
            WHERE user_id = id_user AND id_session = session_id) :: INTEGER;
  result_2 = (SELECT 3 * time_in_secs / 60
              FROM session_details
              WHERE user_id = id_user AND id_session = session_id) :: INTEGER;
  RETURN greatest(result, result_2);
END;
$$;


CREATE OR REPLACE VIEW calories_burned AS
  SELECT
    id_user,
    id_session,
    CASE
    WHEN (sex = 'm')
      THEN count_calories_man(id_user, id_session)
    ELSE count_calories_man(id_user, id_session)
    END AS calories_burned
  FROM session_details;

-- wypelniam tabele type_workouts
insert into simplytrackme.type_workouts values(0,'jogging');
insert into simplytrackme.type_workouts values(1,'skiing');
insert into simplytrackme.type_workouts values(2,'rollerblading');
insert into simplytrackme.type_workouts values(3,'cycling');
insert into simplytrackme.type_workouts values(4,'swimming');

-- dodac check, ze hearthrate w przedziale (50,220)
-- dodac check, ze srednia predkosc biegania w przedziale (0,20)

-- wypelnianie dla biegania
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (0.0,5.0,0,70);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (5.0,6.0,0,80);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (6.0,7.0,0,90);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (7.0,8.0,0,100);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (8.0,9.0,0,110);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (9.0,10.0,0,130);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (10.0,11.0,0,150);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (11.0,12.0,0,160);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (12.0,13.0,0,170);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (13.5,14.0,0,180);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (14.0,14.5,0,185);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (14.5,20.0,0,190);

-- dodac check, ze srednia predkosc na rolkach jest w przedziale(0,45)

-- wypelnienie dla rolek
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (0.0,6.0,3,80);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (6.0,7.0,3,80);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (7.0,9.0,3,90);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (9.0,10.0,3,100);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (10.0,11.0,3,110);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (11.0,12.0,3,120);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (12.0,14.0,3,125);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (14.0,16.0,3,135);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (16.0,18.0,3,145);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (18.0,20.0,3,155);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (20.0,21.0,3,160);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (21.0,22.0,3,170);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (22.0,25.0,3,175);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (25.0,30.0,3,180);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (30.0,45.0,3,190);

-- dodac check, ze srednia predkosc dla rowerow jest w przedziale (0,50)

-- wypelnienie dla roweru
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (0.0,5.0,1,70)
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (5.0,10.0,1,80);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (10.0,13.0,1,90);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (13.0,15.0,1,100);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (15.0,18.0,1,110);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (18.0,20.0,1,120);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (20.0,21.0,1,130);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (21.0,23.0,1,140);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (23.0,25.0,1,150);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (25.0,27.0,1,160);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (27.0,29.0,1,170);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (29.0,31.0,1,175);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (31.0,33.0,1,180);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (33.0,34.0,1,185);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (34.0,35.0,1,190);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (35.0,50.0,1,195);

-- dodach check, ze srednia predkosc dla nart to max 120

insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (0.0,5.0,4,60);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (5.0,20.0,4,100);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (20.0,40.0,4,140);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (40.0,120.0,4,160);


-- plywanie dzieje bez komorki, wiec jest troche problem ze zdeterminowaniem predkosci
insert into simplytackme.type_heartrate_intervales (minimum_speed, maximum_speed, id_type, heartrate) values
(0.0,5.0,2,140);

INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Kornelia52_Czuba34',current_date,81,160,'f',78,'Kornelia Czuba');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Helena75_Szczęsny50',current_date,102,189,'f',10,'Helena Szczęsny');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Jakub94_Greń58',current_date,52,199,'m',28,'Jakub Greń');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Sebastian47_Kot2',current_date,63,171,'m',72,'Sebastian Kot');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Weronika18_Reguła75',current_date,94,176,'f',63,'Weronika Reguła');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Oliwier94_Józefiak86',current_date,77,193,'m',42,'Oliwier Józefiak');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Julia53_Olszak74',current_date,90,165,'f',79,'Julia Olszak');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Igor28_Karolczak64',current_date,41,162,'m',28,'Igor Karolczak');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Julian16_Łada63',current_date,87,165,'m',25,'Julian Łada');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Weronika62_Golonka53',current_date,105,171,'f',23,'Weronika Golonka');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Barbara62_Łach30',current_date,84,163,'f',81,'Barbara Łach');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Jan68_Rębisz66',current_date,97,185,'m',87,'Jan Rębisz');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Weronika47_Daniluk64',current_date,86,183,'f',36,'Weronika Daniluk');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Nina58_Buczak39',current_date,108,190,'f',90,'Nina Buczak');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Marcelina57_Wyrwa6',current_date,75,183,'f',60,'Marcelina Wyrwa');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Barbara52_Wrona77',current_date,100,180,'f',11,'Barbara Wrona');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Wojciech46_Konieczka72',current_date,59,193,'m',42,'Wojciech Konieczka');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Gabriel88_Stolarek22',current_date,91,191,'m',60,'Gabriel Stolarek');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Filip9_Kozieł93',current_date,106,187,'m',46,'Filip Kozieł');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Julian34_Małolepsza98',current_date,74,171,'m',61,'Julian Małolepsza');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Marcelina22_Pikul1',current_date,86,189,'f',30,'Marcelina Pikul');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Dawid30_Kijak31',current_date,53,170,'m',88,'Dawid Kijak');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Igor11_Kulak91',current_date,105,162,'m',74,'Igor Kulak');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Gabriel97_Plata38',current_date,51,187,'m',92,'Gabriel Plata');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Liliana35_Krawczuk42',current_date,55,187,'f',47,'Liliana Krawczuk');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Oliwia91_Bartosiewicz89',current_date,52,196,'f',98,'Oliwia Bartosiewicz');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Pola69_Gurgul69',current_date,103,163,'f',30,'Pola Gurgul');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Nikodem35_Kardasz80',current_date,98,175,'m',98,'Nikodem Kardasz');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Aleksander56_Szostek71',current_date,64,160,'m',94,'Aleksander Szostek');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Nikola29_Skoczylas46',current_date,43,196,'f',28,'Nikola Skoczylas');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Katarzyna58_Włodek49',current_date,107,181,'f',79,'Katarzyna Włodek');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Maksymilian41_Dopierała1',current_date,47,174,'m',49,'Maksymilian Dopierała');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Jan72_Konik86',current_date,68,160,'m',68,'Jan Konik');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Tymon72_Galus84',current_date,95,195,'m',72,'Tymon Galus');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Stanisław18_Dziedzic34',current_date,95,195,'m',41,'Stanisław Dziedzic');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Antonina38_Pasieka93',current_date,55,199,'f',63,'Antonina Pasieka');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Kaja15_Hołda57',current_date,43,163,'f',78,'Kaja Hołda');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Klaudia49_Kędzior37',current_date,96,166,'f',16,'Klaudia Kędzior');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Adam12_Królak82',current_date,98,165,'m',96,'Adam Królak');
INSERT INTO simplytrackme.users (user_name,join_date,weight,height,sex,age,full_name) values ('Maciej82_Karasiewicz57',current_date,44,186,'m',20,'Maciej Karasiewicz');

INSERT INTO simplytrackme.groups (name,private) values ('hotel_present',false);
INSERT INTO simplytrackme.groups (name,private) values ('horn,_horn,',false);
INSERT INTO simplytrackme.groups (name,private) values ('runners_habit',true);
INSERT INTO simplytrackme.groups (name,private) values ('hotel_preserve',false);
INSERT INTO simplytrackme.groups (name,private) values ('eternity_horn,',true);
INSERT INTO simplytrackme.groups (name,private) values ('hideous_habit',false);
INSERT INTO simplytrackme.groups (name,private) values ('smart_swimmers',false);
INSERT INTO simplytrackme.groups (name,private) values ('habit_horn,',false);
INSERT INTO simplytrackme.groups (name,private) values ('eternity_the_conquerer',true);
INSERT INTO simplytrackme.groups (name,private) values ('grit_runners',true);

INSERT INTO simplytrackme.group_members values (2,4);
INSERT INTO simplytrackme.group_members values (2,5);
INSERT INTO simplytrackme.group_members values (2,7);
INSERT INTO simplytrackme.group_members values (4,5);
INSERT INTO simplytrackme.group_members values (4,8);
INSERT INTO simplytrackme.group_members values (5,4);
INSERT INTO simplytrackme.group_members values (6,1);
INSERT INTO simplytrackme.group_members values (6,4);
INSERT INTO simplytrackme.group_members values (7,3);
INSERT INTO simplytrackme.group_members values (7,10);
INSERT INTO simplytrackme.group_members values (8,1);
INSERT INTO simplytrackme.group_members values (8,3);
INSERT INTO simplytrackme.group_members values (8,4);
INSERT INTO simplytrackme.group_members values (10,5);
INSERT INTO simplytrackme.group_members values (10,10);
INSERT INTO simplytrackme.group_members values (11,1);
INSERT INTO simplytrackme.group_members values (11,2);
INSERT INTO simplytrackme.group_members values (11,7);
INSERT INTO simplytrackme.group_members values (12,2);
INSERT INTO simplytrackme.group_members values (12,4);
INSERT INTO simplytrackme.group_members values (14,2);
INSERT INTO simplytrackme.group_members values (14,5);
INSERT INTO simplytrackme.group_members values (14,7);
INSERT INTO simplytrackme.group_members values (14,9);
INSERT INTO simplytrackme.group_members values (15,1);
INSERT INTO simplytrackme.group_members values (15,8);
INSERT INTO simplytrackme.group_members values (15,9);
INSERT INTO simplytrackme.group_members values (16,3);
INSERT INTO simplytrackme.group_members values (16,8);
INSERT INTO simplytrackme.group_members values (16,9);
INSERT INTO simplytrackme.group_members values (17,4);
INSERT INTO simplytrackme.group_members values (19,3);
INSERT INTO simplytrackme.group_members values (19,4);
INSERT INTO simplytrackme.group_members values (20,4);
INSERT INTO simplytrackme.group_members values (20,8);
INSERT INTO simplytrackme.group_members values (21,8);
INSERT INTO simplytrackme.group_members values (22,9);
INSERT INTO simplytrackme.group_members values (23,4);
INSERT INTO simplytrackme.group_members values (23,8);
INSERT INTO simplytrackme.group_members values (25,2);
INSERT INTO simplytrackme.group_members values (25,3);
INSERT INTO simplytrackme.group_members values (25,7);
INSERT INTO simplytrackme.group_members values (26,8);
INSERT INTO simplytrackme.group_members values (27,2);
INSERT INTO simplytrackme.group_members values (27,3);
INSERT INTO simplytrackme.group_members values (27,6);
INSERT INTO simplytrackme.group_members values (27,7);
INSERT INTO simplytrackme.group_members values (28,2);
INSERT INTO simplytrackme.group_members values (28,3);
INSERT INTO simplytrackme.group_members values (28,5);
INSERT INTO simplytrackme.group_members values (29,7);
INSERT INTO simplytrackme.group_members values (30,1);
INSERT INTO simplytrackme.group_members values (30,4);
INSERT INTO simplytrackme.group_members values (31,9);
INSERT INTO simplytrackme.group_members values (33,2);
INSERT INTO simplytrackme.group_members values (34,4);
INSERT INTO simplytrackme.group_members values (34,7);
INSERT INTO simplytrackme.group_members values (34,9);
INSERT INTO simplytrackme.group_members values (35,1);
INSERT INTO simplytrackme.group_members values (35,6);
INSERT INTO simplytrackme.group_members values (36,1);
INSERT INTO simplytrackme.group_members values (36,5);
INSERT INTO simplytrackme.group_members values (36,6);
INSERT INTO simplytrackme.group_members values (36,10);
INSERT INTO simplytrackme.group_members values (37,2);
INSERT INTO simplytrackme.group_members values (38,6);
INSERT INTO simplytrackme.group_members values (38,7);
INSERT INTO simplytrackme.group_members values (38,8);
INSERT INTO simplytrackme.group_members values (39,3);
INSERT INTO simplytrackme.group_members values (39,9);
INSERT INTO simplytrackme.group_members values (39,10);

INSERT INTO simplytrackme.friends values (6,1);
INSERT INTO simplytrackme.friends values (37,2);
INSERT INTO simplytrackme.friends values (21,3);
INSERT INTO simplytrackme.friends values (10,4);
INSERT INTO simplytrackme.friends values (24,5);
INSERT INTO simplytrackme.friends values (12,6);
INSERT INTO simplytrackme.friends values (19,7);
INSERT INTO simplytrackme.friends values (38,8);
INSERT INTO simplytrackme.friends values (16,9);
INSERT INTO simplytrackme.friends values (16,10);
INSERT INTO simplytrackme.friends values (18,11);
INSERT INTO simplytrackme.friends values (29,12);
INSERT INTO simplytrackme.friends values (39,13);
INSERT INTO simplytrackme.friends values (18,14);
INSERT INTO simplytrackme.friends values (39,15);
INSERT INTO simplytrackme.friends values (39,16);
INSERT INTO simplytrackme.friends values (19,17);
INSERT INTO simplytrackme.friends values (23,18);
INSERT INTO simplytrackme.friends values (36,19);
INSERT INTO simplytrackme.friends values (24,20);
INSERT INTO simplytrackme.friends values (32,21);
INSERT INTO simplytrackme.friends values (33,22);
INSERT INTO simplytrackme.friends values (28,23);
INSERT INTO simplytrackme.friends values (29,24);
INSERT INTO simplytrackme.friends values (30,25);
INSERT INTO simplytrackme.friends values (30,26);
INSERT INTO simplytrackme.friends values (29,27);
INSERT INTO simplytrackme.friends values (32,28);
INSERT INTO simplytrackme.friends values (33,29);
INSERT INTO simplytrackme.friends values (35,30);
INSERT INTO simplytrackme.friends values (33,31);
INSERT INTO simplytrackme.friends values (36,32);
INSERT INTO simplytrackme.friends values (34,33);
INSERT INTO simplytrackme.friends values (35,34);
INSERT INTO simplytrackme.friends values (39,35);
INSERT INTO simplytrackme.friends values (40,36);
INSERT INTO simplytrackme.friends values (39,37);
INSERT INTO simplytrackme.friends values (39,38);
INSERT INTO simplytrackme.friends values (40,39);

--./input/Aardenburg_Natuurwandeling_-_10_km_RT.gpx:id_user=7:id_type=0:minV12:maxV13
INSERT INTO simplytrackme.sessions (id_localsession,id_session,type,id_route, begin_time, end_time, distance, elevation, id_owner)VALUES ((SELECT max(id_localsession)+1 from simplytrackme.sessions where id_owner = 7 group by id_owner),coalesce((select max(id_session) from simplytrackme.sessions),0)+1,0, null,current_timestamp,current_timestamp + interval'2460 s',8654,0,7);
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(0,51.274238,3.450782,93,26,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(1,51.274674,3.452740,237,66,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(2,51.274245,3.452977,288,80,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(3,51.274198,3.454354,384,106,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(4,51.273968,3.454720,420,116,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(5,51.273441,3.457229,604,170,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(6,51.271961,3.455759,798,224,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(7,51.271304,3.459752,1085,307,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(8,51.270624,3.461018,1201,341,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(9,51.270511,3.460908,1216,345,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(10,51.269846,3.460887,1290,366,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(11,51.270939,3.451858,1929,545,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(12,51.271181,3.451724,1958,553,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(13,51.270331,3.451642,2053,580,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(14,51.270627,3.448606,2266,641,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(15,51.270599,3.448350,2284,646,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(16,51.270018,3.447515,2371,671,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(17,51.270026,3.447328,2384,674,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(18,51.270555,3.446140,2486,702,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(19,51.270223,3.445921,2526,713,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(20,51.270247,3.445866,2530,714,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(21,51.272464,3.447411,2799,793,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(22,51.272775,3.446515,2871,814,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(23,51.272798,3.446527,2873,814,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(24,51.272491,3.447427,2945,833,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(25,51.273804,3.448470,3108,879,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(26,51.272849,3.450327,3275,928,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(27,51.272163,3.448999,3395,961,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(28,51.271982,3.448858,3417,967,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(29,51.271328,3.447250,3550,1005,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(30,51.271434,3.446832,3582,1014,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(31,51.271359,3.446773,3591,1016,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(32,51.272678,3.440989,4019,1142,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(33,51.272041,3.436036,4371,1246,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(34,51.271993,3.435934,4380,1248,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(35,51.271842,3.435974,4397,1253,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(36,51.271670,3.434944,4471,1275,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(37,51.271018,3.435266,4547,1297,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(38,51.270651,3.434109,4637,1324,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(39,51.270506,3.434075,4654,1328,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(40,51.270502,3.433285,4709,1344,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(41,51.270812,3.432877,4753,1357,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(42,51.270511,3.431763,4838,1380,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(43,51.271475,3.430697,4968,1416,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(44,51.271579,3.430181,5006,1426,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(45,51.271329,3.429310,5072,1445,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(46,51.272100,3.428869,5163,1472,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(47,51.272377,3.428233,5217,1487,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(48,51.272585,3.428952,5272,1502,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(49,51.272338,3.429233,5306,1511,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(50,51.272437,3.430327,5383,1532,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(51,51.273327,3.430191,5482,1560,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(52,51.273322,3.429430,5535,1574,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(53,51.273264,3.429301,5546,1577,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(54,51.272904,3.429385,5587,1588,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(55,51.272930,3.429039,5611,1595,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(56,51.273313,3.428876,5655,1607,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(57,51.273435,3.428889,5669,1610,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(58,51.273736,3.430751,5803,1649,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(59,51.273709,3.431124,5829,1656,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(60,51.273578,3.431402,5853,1663,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(61,51.273363,3.431550,5879,1670,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(62,51.273201,3.431512,5897,1675,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(63,51.273174,3.430995,5933,1685,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(64,51.273408,3.430867,5961,1692,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(65,51.273420,3.430659,5975,1696,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(66,51.273337,3.430255,6005,1704,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(67,51.272872,3.430331,6057,1718,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(68,51.273385,3.441032,6803,1941,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(69,51.273744,3.441167,6844,1952,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(70,51.273987,3.444335,7066,2016,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(71,51.274462,3.444578,7122,2031,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(72,51.274674,3.444407,7148,2038,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(73,51.274738,3.443300,7226,2059,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(74,51.274708,3.442731,7265,2070,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(75,51.275110,3.442677,7310,2083,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(76,51.275135,3.442255,7340,2091,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(77,51.275344,3.441958,7371,2099,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(78,51.276419,3.441213,7501,2136,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(79,51.276599,3.441994,7559,2152,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(80,51.276565,3.442126,7569,2154,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(81,51.276604,3.442406,7589,2159,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(82,51.278759,3.443808,7848,2231,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(83,51.278752,3.444055,7865,2235,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(84,51.277828,3.445651,8016,2280,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(85,51.277549,3.445265,8057,2291,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(86,51.277099,3.446016,8129,2311,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(87,51.276204,3.445765,8230,2340,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(88,51.274299,3.447491,8474,2410,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(89,51.273595,3.449031,8607,2447,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(90,51.273946,3.449413,8654,2460,0,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));
INSERT INTO simplytrackme.user_sessions (id_user, id_session) VALUES (7,(SELECT id_session from simplytrackme.sessions where id_owner = 7 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 7 group by id_owner)));

--./input/Achterbroek_naar_De_Maatjes_-_13_km_TR.gpx:id_user=21:id_type=0:minV12:maxV13
INSERT INTO simplytrackme.sessions (id_localsession,id_session,type,id_route, begin_time, end_time, distance, elevation, id_owner)VALUES ((SELECT max(id_localsession)+1 from simplytrackme.sessions where id_owner = 21 group by id_owner),coalesce((select max(id_session) from simplytrackme.sessions),0)+1,0, null,current_timestamp,current_timestamp + interval'3840 s',13388,0,21);
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(0,51.397705,4.501452,68,19,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(1,51.398635,4.502678,202,58,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(2,51.404042,4.498472,870,245,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(3,51.405072,4.498043,989,278,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(4,51.405456,4.499259,1083,305,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(5,51.417346,4.515038,2799,798,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(6,51.419320,4.513879,3033,863,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(7,51.421552,4.523535,3747,1074,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(8,51.423011,4.522848,3916,1121,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(9,51.423826,4.529500,4386,1258,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(10,51.427002,4.528513,4746,1362,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(11,51.427131,4.534478,5160,1478,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(12,51.426819,4.537440,5368,1538,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(13,51.430402,4.552363,6477,1863,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(14,51.426229,4.555399,6986,2014,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(15,51.426015,4.554734,7038,2028,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(16,51.423569,4.556108,7326,2110,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(17,51.423097,4.553981,7483,2156,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(18,51.419320,4.546237,8165,2347,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(19,51.410952,4.534092,9420,2701,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(20,51.406231,4.543018,10231,2926,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(21,51.396695,4.515966,12387,3549,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(22,51.396017,4.515853,12463,3570,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(23,51.396858,4.506495,13119,3766,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(24,51.397133,4.502635,13388,3840,0,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));
INSERT INTO simplytrackme.user_sessions (id_user, id_session) VALUES (21,(SELECT id_session from simplytrackme.sessions where id_owner = 21 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 21 group by id_owner)));

--./input/Bieganko.gpx:id_user=2:id_type=0:minV13:maxV14
INSERT INTO simplytrackme.sessions (id_localsession,id_session,type,id_route, begin_time, end_time, distance, elevation, id_owner)VALUES ((SELECT max(id_localsession)+1 from simplytrackme.sessions where id_owner = 2 group by id_owner),coalesce((select max(id_session) from simplytrackme.sessions),0)+1,0, null,current_timestamp,current_timestamp + interval'2731 s',10285,0,2);
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(0,52.142658,4.495833,289,76,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(1,52.141884,4.495103,389,101,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(2,52.141262,4.493344,527,137,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(3,52.141586,4.492528,594,154,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(4,52.140854,4.488494,881,229,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(5,52.139633,4.489589,1036,270,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(6,52.138260,4.490125,1193,311,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(7,52.136028,4.491799,1466,383,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(8,52.136284,4.492872,1545,404,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(9,52.135704,4.493687,1630,427,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(10,52.135319,4.492636,1713,448,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(11,52.134804,4.492829,1772,464,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(12,52.133583,4.493988,1929,504,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(13,52.132790,4.492679,2055,537,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(14,52.131695,4.492915,2178,570,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(15,52.129356,4.495704,2500,653,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(16,52.129700,4.496841,2586,675,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(17,52.127724,4.499052,2853,747,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(18,52.126759,4.498193,2975,780,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(19,52.126156,4.498129,3042,798,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(20,52.132530,4.523728,4928,1307,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(21,52.128239,4.527311,5464,1454,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(22,52.130276,4.529757,5746,1528,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(23,52.130062,4.530830,5823,1548,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(24,52.130665,4.531839,5919,1572,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(25,52.131371,4.532075,5999,1593,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(26,52.131737,4.532976,6073,1612,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(27,52.123924,4.563189,8311,2216,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(28,52.116695,4.561751,9120,2430,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(29,52.118881,4.545979,10224,2715,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(30,52.118496,4.545357,10285,2731,0,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));
INSERT INTO simplytrackme.user_sessions (id_user, id_session) VALUES (2,(SELECT id_session from simplytrackme.sessions where id_owner = 2 AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = 2 group by id_owner)));

--./input/Bornem_Oude_Schelde_-_10_km_RT.gpx:id_user=28:id_type=0:minV12:maxV13
INSERT INTO simplytrackme.sessions (id_localsession,id_session,type,id_route, begin_time, end_time, distance, elevation, id_owner)VALUES ((SELECT max(id_localsession)+1 from simplytrackme.sessions where id_owner = 28 group by id_owner),coalesce((select max(id_session) from simplytrackme.sessions),0)+1,0, null,current_timestamp,current_timestamp + interval'2877 s',10112,0,28);
