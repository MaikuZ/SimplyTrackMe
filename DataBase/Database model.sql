CREATE SCHEMA simplytrackme;

drop table if exists simplytrackme.track cascade;
CREATE TABLE simplytrackme.track ( 
	segment              integer  NOT NULL,
	"time"               time  NOT NULL,
	id_session           integer  NOT NULL,
	CONSTRAINT pk_track_0 UNIQUE ( id_session ) 
 );

drop table if exists simplytrackme.type_workout cascade;
CREATE TABLE simplytrackme.type_workout ( 
	id_type              serial  NOT NULL,
	name                 varchar(100)  ,
	CONSTRAINT pk_typ_treningu UNIQUE ( id_type ) ,
	CONSTRAINT pk_typ_treningu_0 PRIMARY KEY ( id_type )
 );

drop table if exists simplytrackme."session" cascade;
CREATE TABLE simplytrackme."session" ( 
	id_session           serial  NOT NULL,
	"type"               integer  NOT NULL,
	route                json  NOT NULL,
	begin_time           time  NOT NULL,
	end_time             time  NOT NULL,
	distance             float8 DEFAULT 0 NOT NULL,
	elevation            float8  NOT NULL,
	id_owner             integer  NOT NULL,
	CONSTRAINT "pk_trening/sesja" PRIMARY KEY ( id_session ),
	CONSTRAINT pk_session UNIQUE ( id_owner ) 
 );

drop table if exists simplytrackme.user_session cascade;
CREATE TABLE simplytrackme.user_session ( 
	id_user              integer  NOT NULL,
	id_session           integer  NOT NULL,
	CONSTRAINT pk_user_session UNIQUE ( id_user ) 
 );

drop table if exists simplytrackme.friends cascade;
CREATE TABLE simplytrackme.friends ( 
	id_user              integer  NOT NULL,
	id_friend            integer  NOT NULL,
	CONSTRAINT pk_znajomi UNIQUE ( id_user ) 
 );

drop table if exists simplytrackme.users cascade;
CREATE TABLE simplytrackme.users ( 
	id_user              serial  NOT NULL,
	user_name            varchar(20)  NOT NULL,
	join_date            time  ,
	CONSTRAINT pk_uzytkownicy PRIMARY KEY ( id_user )
 );

ALTER TABLE simplytrackme.friends ADD CONSTRAINT fk_znajomi FOREIGN KEY ( id_friend ) REFERENCES simplytrackme.users( id_user );

ALTER TABLE simplytrackme."session" ADD CONSTRAINT typ_treningu FOREIGN KEY ( "type" ) REFERENCES simplytrackme.type_workout( id_type ) ON DELETE SET NULL;

ALTER TABLE simplytrackme."session" ADD CONSTRAINT "fk_trening/sesja" FOREIGN KEY ( id_session ) REFERENCES simplytrackme.track( id_session );

ALTER TABLE simplytrackme.user_session ADD CONSTRAINT fk_user_session FOREIGN KEY ( id_session ) REFERENCES simplytrackme."session"( id_session );

ALTER TABLE simplytrackme.users ADD CONSTRAINT fk_users FOREIGN KEY ( id_user ) REFERENCES simplytrackme.friends( id_user );

ALTER TABLE simplytrackme.users ADD CONSTRAINT fk_users_0 FOREIGN KEY ( id_user ) REFERENCES simplytrackme.user_session( id_user );

ALTER TABLE simplytrackme.users ADD CONSTRAINT fk_users_1 FOREIGN KEY ( id_user ) REFERENCES simplytrackme."session"( id_owner );

