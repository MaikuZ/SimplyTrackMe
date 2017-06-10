
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
