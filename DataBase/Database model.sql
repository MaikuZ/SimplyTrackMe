CREATE SCHEMA simplytrackme;

CREATE TABLE simplytrackme."group" ( 
	id_group             serial  NOT NULL,
	name                 varchar(32)  NOT NULL,
	private              bool  NOT NULL,
	CONSTRAINT pk_group PRIMARY KEY ( id_group )
 );

COMMENT ON COLUMN simplytrackme."group".private IS 'determine whether the group ought be private or public';

CREATE TABLE simplytrackme.node ( 
	id_node              serial  NOT NULL,
	lat                  numeric(12,10)  NOT NULL,
	lon                  numeric(12,10)  NOT NULL,
	total_distance       numeric(4,1)  NOT NULL,
	duration             numeric(8,2)  NOT NULL,
	elevation            numeric(4,1) DEFAULT 0 NOT NULL,
	CONSTRAINT pk_node PRIMARY KEY ( id_node )
 );

COMMENT ON TABLE simplytrackme.node IS 'node';

COMMENT ON COLUMN simplytrackme.node.duration IS 'in minutes';

COMMENT ON COLUMN simplytrackme.node.elevation IS 'meters';

CREATE TABLE simplytrackme.route ( 
	name                 varchar(100)  NOT NULL,
	id_route             serial  NOT NULL,
	CONSTRAINT pk_route PRIMARY KEY ( id_route )
 );

CREATE TABLE simplytrackme.track ( 
	id_session           integer  NOT NULL,
	id_node              integer  NOT NULL,
	CONSTRAINT pk_track_0 UNIQUE ( id_session ) 
 );

CREATE INDEX idx_track ON simplytrackme.track ( id_node );

CREATE TABLE simplytrackme.type_workout ( 
	id_type              serial  NOT NULL,
	name                 varchar(100)  ,
	CONSTRAINT pk_typ_treningu UNIQUE ( id_type ) ,
	CONSTRAINT pk_typ_treningu_0 PRIMARY KEY ( id_type )
 );

CREATE TABLE simplytrackme.competition ( 
	id_competition       serial  NOT NULL,
	name                 varchar(32)  NOT NULL,
	place                varchar(32)  NOT NULL,
	event_date           date  NOT NULL,
	id_type              serial  ,
	distance             numeric(8,2)  NOT NULL,
	CONSTRAINT pk_competition PRIMARY KEY ( id_competition )
 );

CREATE INDEX idx_competition ON simplytrackme.competition ( id_type );

CREATE TABLE simplytrackme."session" ( 
	id_session           serial  NOT NULL,
	"type"               integer  NOT NULL,
	route                json  NOT NULL,
	begin_time           time  NOT NULL,
	end_time             time  NOT NULL,
	distance             float8 DEFAULT 0 NOT NULL,
	elevation            float8  NOT NULL,
	id_owner             integer  NOT NULL,
	id_route             integer  ,
	CONSTRAINT "pk_trening/sesja" PRIMARY KEY ( id_session ),
	CONSTRAINT pk_session UNIQUE ( id_owner ) 
 );

ALTER TABLE simplytrackme."session" ADD CONSTRAINT ck_2 CHECK ( begin_time<end_time );


CREATE INDEX idx_session ON simplytrackme."session" ( id_route );

CREATE TABLE simplytrackme.user_session ( 
	id_user              integer  NOT NULL,
	id_session           integer  NOT NULL,
	CONSTRAINT pk_user_session UNIQUE ( id_user ) 
 );

CREATE INDEX idx_user_session ON simplytrackme.user_session ( id_session );

CREATE TABLE simplytrackme.friends ( 
	id_user              integer  NOT NULL,
	id_friend            integer  NOT NULL,
	CONSTRAINT pk_znajomi UNIQUE ( id_user ) 
 );

ALTER TABLE simplytrackme.friends ADD CONSTRAINT ck_0 CHECK ( id_user < id_friend );

COMMENT ON CONSTRAINT ck_0 ON simplytrackme.friends IS 'don''t allow redundancy.
If a is friend with b, so is b with a.';

CREATE INDEX idx_znajomi ON simplytrackme.friends ( id_friend );

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

CREATE TABLE simplytrackme.users ( 
	id_user              serial  NOT NULL,
	user_name            varchar(20)  NOT NULL,
	join_date            time  ,
	weight               numeric(4,1) DEFAULT 80 NOT NULL,
	height               numeric(3) DEFAULT 160 NOT NULL,
	sex                  char(1) DEFAULT 'f' NOT NULL,
	age                  numeric(2) DEFAULT 18 NOT NULL,
	CONSTRAINT pk_użytkownicy PRIMARY KEY ( id_user )
 );

--TOFIX
--ALTER TABLE simplytrackme.users ADD CONSTRAINT ck_1 CHECK ( sex like 'f' or sex like 'm' );

ALTER TABLE simplytrackme.competition ADD CONSTRAINT fk_competition FOREIGN KEY ( id_type ) REFERENCES simplytrackme.type_workout( id_type );

COMMENT ON CONSTRAINT fk_competition ON simplytrackme.competition IS '';

ALTER TABLE simplytrackme.friends ADD CONSTRAINT fk_znajomi FOREIGN KEY ( id_friend ) REFERENCES simplytrackme.users( id_user );

COMMENT ON CONSTRAINT fk_znajomi ON simplytrackme.friends IS '';

ALTER TABLE simplytrackme.group_members ADD CONSTRAINT fk_group_members FOREIGN KEY ( id_group ) REFERENCES simplytrackme."group"( id_group );

COMMENT ON CONSTRAINT fk_group_members ON simplytrackme.group_members IS '';

ALTER TABLE simplytrackme.group_members ADD CONSTRAINT fk_group_members_0 FOREIGN KEY ( id_user ) REFERENCES simplytrackme.users( id_user );

COMMENT ON CONSTRAINT fk_group_members_0 ON simplytrackme.group_members IS '';

ALTER TABLE simplytrackme.participants ADD CONSTRAINT fk_contestants FOREIGN KEY ( id_competition ) REFERENCES simplytrackme.competition( id_competition );

COMMENT ON CONSTRAINT fk_contestants ON simplytrackme.participants IS '';

ALTER TABLE simplytrackme.participants ADD CONSTRAINT fk_contestants_0 FOREIGN KEY ( id_user ) REFERENCES simplytrackme.users( id_user );

COMMENT ON CONSTRAINT fk_contestants_0 ON simplytrackme.participants IS '';

ALTER TABLE simplytrackme."session" ADD CONSTRAINT typ_treningu FOREIGN KEY ( "type" ) REFERENCES simplytrackme.type_workout( id_type ) ON DELETE SET NULL;

COMMENT ON CONSTRAINT typ_treningu ON simplytrackme."session" IS '';

ALTER TABLE simplytrackme."session" ADD CONSTRAINT "fk_trening_sesja" FOREIGN KEY ( id_session ) REFERENCES simplytrackme.track( id_session );

COMMENT ON CONSTRAINT fk_trening_sesja ON simplytrackme."session" IS '';

ALTER TABLE simplytrackme."session" ADD CONSTRAINT fk_session FOREIGN KEY ( id_route ) REFERENCES simplytrackme.route( id_route );

COMMENT ON CONSTRAINT fk_session ON simplytrackme."session" IS '';

ALTER TABLE simplytrackme.track ADD CONSTRAINT fk_track FOREIGN KEY ( id_node ) REFERENCES simplytrackme.node( id_node );

COMMENT ON CONSTRAINT fk_track ON simplytrackme.track IS '';

ALTER TABLE simplytrackme.user_session ADD CONSTRAINT fk_user_session FOREIGN KEY ( id_session ) REFERENCES simplytrackme."session"( id_session );

COMMENT ON CONSTRAINT fk_user_session ON simplytrackme.user_session IS '';

ALTER TABLE simplytrackme.users ADD CONSTRAINT fk_users FOREIGN KEY ( id_user ) REFERENCES simplytrackme.friends( id_user );

COMMENT ON CONSTRAINT fk_users ON simplytrackme.users IS '';

ALTER TABLE simplytrackme.users ADD CONSTRAINT fk_users_0 FOREIGN KEY ( id_user ) REFERENCES simplytrackme.user_session( id_user );

COMMENT ON CONSTRAINT fk_users_0 ON simplytrackme.users IS '';

ALTER TABLE simplytrackme.users ADD CONSTRAINT fk_users_1 FOREIGN KEY ( id_user ) REFERENCES simplytrackme."session"( id_owner );

COMMENT ON CONSTRAINT fk_users_1 ON simplytrackme.users IS '';

