CREATE OR REPLACE PROCEDURE REFERENCEDATA_INQ_V1
(
	REFERENCEDATA			IN O_REFERENCEDATA
	,LOCALEHEADER 			IN O_LOCALEHEADER
	,PAGINATIONANDSORTING	IN O_PAGINATIONANDSORTING
	,RESPONSES_REFERENCEDATA			OUT NOCOPY T_REFERENCEDATA
	,RESPONSE_PAGINATIONANDSORTING 	OUT O_PAGINATIONANDSORTING
)
AS
V_RESPONSE  		T_REFERENCEDATA;
V_CURRENTPAGE    	NUMBER;
V_STARTINGROWNUMBER NUMBER;
V_ENDINGROWNUMBER   NUMBER;
V_RECORDSPERPAGE   	NUMBER;
V_TOTALRECORDSASFOUND   NUMBER;
V_TOTALPAGES        NUMBER;
V_TOTALRECORDS    	T_TOTALRECORDS ;
C_NUMBEROFROWSRETURNEDBYDEFAULT	NUMBER; 
BEGIN

    C_NUMBEROFROWSRETURNEDBYDEFAULT := GET_NUMBEROFROWTOBESRETURNED('REFERENCEDATA_INQ');
	V_RECORDSPERPAGE	:= NVL(PAGINATIONANDSORTING.RECORDSPERPAGE,C_NUMBEROFROWSRETURNEDBYDEFAULT);
    V_STARTINGROWNUMBER := ( V_RECORDSPERPAGE * ( NVL(PAGINATIONANDSORTING.NEXTPAGE,1) - 1 ) );
    V_ENDINGROWNUMBER   := ( V_RECORDSPERPAGE * ( NVL(PAGINATIONANDSORTING.NEXTPAGE,1) ) );
    
    V_CURRENTPAGE		:= NVL(PAGINATIONANDSORTING.NEXTPAGE,1);	

    SELECT
    O_REFERENCEDATA
    (	
		id => A.UUID
		,shortDescription => A.SHORTDESCRIPTION
		,longDescription => A.LONGDESCRIPTION
		,referenceDatacode => A.REFERENCEDATACODE
		,key01 => A.KEY01
		,key02 => A.KEY02
		,key03 => A.KEY03
		,key04 => A.KEY04
		,value01 => A.VALUE01
		,value02 => A.VALUE02
		,value03 => A.VALUE03
		,value04 => A.VALUE04
		,value05 => A.VALUE05
		,value06 => A.VALUE06
		,status => A.STATUS
		,startDate => A.STARTDATE
		,endDate => A.ENDDATE
		,environment => A.ENVIRONMENT
		,category => A.CATEGORY
		,isDefault => A.ISDEFAULT  
    )
    ,
    A.TOTALRECORDS   
    BULK COLLECT INTO V_RESPONSE , V_TOTALRECORDS
    FROM
    (
        SELECT
        F.*
        FROM
        (
            SELECT 
            T.*, 
            ROWNUM R
            FROM 
            (  
				SELECT
				COUNT(1) OVER ( ORDER BY 1 RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) TOTALRECORDS
				,ID
				,UUID
				,SHORTDESCRIPTION
				,LONGDESCRIPTION
				,REFERENCEDATACODE
				,KEY01
				,KEY02
				,KEY03
				,KEY04
				,VALUE01
				,VALUE02
				,VALUE03
				,VALUE04
				,VALUE05
				,VALUE06
				,STATUS
				,STARTDATE
				,ENDDATE
				,ENVIRONMENT
				,CATEGORY
				,ISDEFAULT
				,CREATED_ON
				,CREATED_BY
				,MODIFIED_ON
				,MODIFIED_BY   
				FROM
				V_REFERENCEDATA A
				WHERE
				(
					REFERENCEDATA.ID IS NULL 
					OR
					A.UUID = REFERENCEDATA.ID 
				)
					
				AND
				(
					REFERENCEDATA.REFERENCEDATACODE IS NULL
					OR
					A.REFERENCEDATACODE = REFERENCEDATA.REFERENCEDATACODE
				)
				AND
				(
					REFERENCEDATA.KEY01 IS NULL
					OR
					A.KEY01 = REFERENCEDATA.KEY01
				)
				AND
				(
					REFERENCEDATA.KEY02 IS NULL
					OR
					A.KEY02 = REFERENCEDATA.KEY02
				)
				AND
				(
					REFERENCEDATA.KEY03 IS NULL
					OR
					A.KEY03 = REFERENCEDATA.KEY03
				)
				AND
				(
					REFERENCEDATA.KEY04 IS NULL
					OR
					A.KEY04 = REFERENCEDATA.KEY04
				)
				AND
				(
					REFERENCEDATA.STATUS IS NULL
					OR
					A.STATUS = REFERENCEDATA.STATUS
				)
				AND
				(
					REFERENCEDATA.CATEGORY IS NULL
					OR
					A.CATEGORY = REFERENCEDATA.CATEGORY
				)
				AND
				(
					REFERENCEDATA.ISDEFAULT IS NULL
					OR
					A.ISDEFAULT = REFERENCEDATA.ISDEFAULT
				)
				AND
				(
					REFERENCEDATA.ID IS NOT NULL OR
					REFERENCEDATA.REFERENCEDATACODE IS NOT NULL OR
					REFERENCEDATA.KEY01 IS NOT NULL OR
					REFERENCEDATA.KEY02 IS NOT NULL OR
					REFERENCEDATA.KEY03 IS NOT NULL OR
					REFERENCEDATA.KEY04 IS NOT NULL OR
					REFERENCEDATA.STATUS IS NOT NULL OR
					REFERENCEDATA.CATEGORY IS NOT NULL OR
					REFERENCEDATA.ISDEFAULT IS NOT NULL 
				)	
					--{ADDITIONAL_LOCALE_WHERE_CONDITIONS}
				/**
				If there are more Id,then they can be used in select query - to do worked upon in subsequent iteration
				*/
            )T
            WHERE ROWNUM  <= V_ENDINGROWNUMBER
        )F    
        WHERE R >= V_STARTINGROWNUMBER 			
    )A
    ;
  
    V_TOTALRECORDSASFOUND   := CASE WHEN ( V_TOTALRECORDS.COUNT > 0 )THEN ( V_TOTALRECORDS(1) ) ELSE V_TOTALRECORDS.COUNT END;
    V_TOTALPAGES            := CASE WHEN ( V_TOTALRECORDSASFOUND > 0 )THEN (  CEIL(V_TOTALRECORDSASFOUND / V_RECORDSPERPAGE) ) ELSE 0 END;

    RESPONSE_PAGINATIONANDSORTING   := 
    O_PAGINATIONANDSORTING
    (
        currentPage => V_CURRENTPAGE
        ,previousPage => CASE WHEN ( V_CURRENTPAGE > 0 )THEN ( V_CURRENTPAGE -1 ) ELSE 0 END
        ,nextPage => CASE WHEN ( ( V_CURRENTPAGE + 1 ) >  V_TOTALPAGES ) THEN ( V_CURRENTPAGE )  ELSE ( V_CURRENTPAGE ) + 1 END    
        ,recordsPerPage => CASE WHEN ( V_RECORDSPERPAGE > V_TOTALRECORDSASFOUND )  THEN ( V_TOTALRECORDSASFOUND )  ELSE ( V_RECORDSPERPAGE ) END    
        ,totalPages => V_TOTALPAGES
        ,totalRecords => V_TOTALRECORDSASFOUND
    );
	
    RESPONSES_REFERENCEDATA    := V_RESPONSE;
	RETURN;
END;

/
