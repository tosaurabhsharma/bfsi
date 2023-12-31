CREATE PROCEDURE ENVIRONMENT_PREADDUPD
(
	ENVIRONMENT		IN O_ENVIRONMENT
	,LOCALEHEADER 		IN O_LOCALEHEADER
	,REQ_ENVIRONMENT	OUT NOCOPY O_ENVIRONMENT
)
AS
V_REQ_ENVIRONMENT O_ENVIRONMENT;
--Incase there is logic to be written before inserting data in tables,then it can be written here
--When system generates this procedure,it is defined as "CREATE" only
V_CLONE_REQ_OBJECT	VARCHAR2(5) DEFAULT 'FALSE';
BEGIN
	
	--{DYNAMIC_CHECK_CONSTRAINT}
	
	--By default this section is commented - if logic is to be written to update request object,then uncomment
	
	/*
	 
	V_CLONE_REQ_OBJECT	:= 'TRUE';
		V_REQ_ENVIRONMENT  := 
	O_ENVIRONMENT
	(	
		whichEnvironment => ENVIRONMENT.whichEnvironment

	);
	*/
	--Find&Substitute/Format data as needed 
	
	IF(V_CLONE_REQ_OBJECT = 'FALSE' )THEN
		REQ_ENVIRONMENT	:= ENVIRONMENT;
	ELSE
		REQ_ENVIRONMENT	:= V_REQ_ENVIRONMENT;
	END IF;
	
	RETURN;
END;
/
CREATE PROCEDURE ENVIRONMENT_POSTADDUPD
(
	ENVIRONMENT	IN O_ENVIRONMENT
	,LOCALEHEADER 	IN O_LOCALEHEADER
	,RESPONSES_ENVIRONMENT	IN OUT NOCOPY T_ENVIRONMENT
)
AS
--Incase there is logic to be written,then it can be written here
--When system generates this procedure,it is defined as "CREATE" only
BEGIN
	
	/*STATUSADDUPD
	--If start/end date are there,then record status will vary as start/end date
	ENVIRONMENT_STATUSADDUPD
	(
		LOCALEHEADER	=> ENVIRONMENT_POSTADDUPD.{LOCALEHEADER}	
		ENVIRONMENT	=> ENVIRONMENT_POSTADDUPD.ENVIRONMENT	
		,RESPONSES_ENVIRONMENT => ENVIRONMENT_POSTADDUPD.RESPONSES_ENVIRONMENT
	);
	STATUSADDUPD*/
	RETURN;
END;
/

/
