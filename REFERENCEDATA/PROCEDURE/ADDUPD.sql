CREATE OR REPLACE PROCEDURE REFERENCEDATA_ADDUPD
(
	REFERENCEDATA	IN O_REFERENCEDATA
	,LOCALEHEADER 	IN O_LOCALEHEADER
	,PAGINATIONANDSORTING	IN O_PAGINATIONANDSORTING				
	,RESPONSES_REFERENCEDATA	OUT NOCOPY T_REFERENCEDATA
)
AS
V_REQ_REFERENCEDATA 		O_REFERENCEDATA;
BEGIN

	REFERENCEDATA_PREADDUPD
	(
		REFERENCEDATA	 	=> REFERENCEDATA
		,LOCALEHEADER 		=> LOCALEHEADER		
        ,REQ_REFERENCEDATA 	=> V_REQ_REFERENCEDATA	
	);
	
	REFERENCEDATA_ADDUPD_V1
	(
		REFERENCEDATA	 	=> V_REQ_REFERENCEDATA	
		,LOCALEHEADER 		=> LOCALEHEADER		
		,PAGINATIONANDSORTING	=> PAGINATIONANDSORTING
		,RESPONSES_REFERENCEDATA	=> REFERENCEDATA_ADDUPD.RESPONSES_REFERENCEDATA
	);
	
	REFERENCEDATA_POSTADDUPD
	(
		REFERENCEDATA		=> V_REQ_REFERENCEDATA	
		,LOCALEHEADER 		=> LOCALEHEADER		
		,RESPONSES_REFERENCEDATA	 => RESPONSES_REFERENCEDATA
	);
	
	COMMIT;
	
	RETURN;
END;
/

/
