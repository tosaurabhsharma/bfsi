BEGIN
	FOR REC IN ( SELECT 1 FROM USER_OBJECTS WHERE OBJECT_NAME IN ( 'T_ENVIRONMENT' ) )
	LOOP
			EXECUTE IMMEDIATE 'DROP TYPE T_ENVIRONMENT FORCE;'
		DBMS_OUTPUT.PUT_LINE ('TYPE T_ENVIRONMENT DROPPED');
	END LOOP;
END;
/
DROP TYPE O_ENVIRONMENT FORCE
/
DROP TYPE O_BASEENVIRONMENT FORCE
/
CREATE OR REPLACE TYPE O_BASEENVIRONMENT AS OBJECT
(	
	whichEnvironment VARCHAR2 (3)
) NOT FINAL
/
