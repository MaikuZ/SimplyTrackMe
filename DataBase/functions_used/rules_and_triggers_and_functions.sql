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

-- create ranking of sum of distance run in the last (interval)
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
