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
	user_name            varchar(20)  NOT NULL,
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
	CONSTRAINT pk_znajomi UNIQUE ( id_friend_b ) 
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

COMMENT ON CONSTRAINT fk_competition ON simplytrackme.competition IS '';

COMMENT ON CONSTRAINT fk_competition ON simplytrackme.competitions IS '';

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

COMMENT ON CONSTRAINT fk_track_0 ON simplytrackme.track IS '';

ALTER TABLE simplytrackme.user_sessions ADD CONSTRAINT fk_user_sessions FOREIGN KEY ( id_user ) REFERENCES simplytrackme.users( id_user ) ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_user_sessions ON simplytrackme.user_sessions IS '';

