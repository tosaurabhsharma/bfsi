CREATE OR REPLACE PROCEDURE ENVIRONMENT_INQ
(
	ENVIRONMENT	IN O_ENVIRONMENT
	,LOCALEHEADER	IN O_LOCALEHEADER
	,PAGINATIONANDSORTING	IN O_PAGINATIONANDSORTING
	,RESPONSES_ENVIRONMENT	OUT NOCOPY T_ENVIRONMENT
	,RESPONSE_PAGINATIONANDSORTING	OUT NOCOPY O_PAGINATIONANDSORTING
)
AS
BEGIN
	ENVIRONMENT_INQ_V1
	(
		ENVIRONMENT => ENVIRONMENT_INQ.ENVIRONMENT
		,LOCALEHEADER => ENVIRONMENT_INQ.LOCALEHEADER
		,PAGINATIONANDSORTING => ENVIRONMENT_INQ.PAGINATIONANDSORTING
		,RESPONSES_ENVIRONMENT => ENVIRONMENT_INQ.RESPONSES_ENVIRONMENT
		,RESPONSE_PAGINATIONANDSORTING => ENVIRONMENT_INQ.RESPONSE_PAGINATIONANDSORTING
	);
	RETURN;
END;
/
