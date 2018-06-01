SET DEFINE OFF
CREATE OR REPLACE PACKAGE BODY IMDB_STAGE.PKG_TITLE_BASICS AS
  PROCEDURE SP_TRUNCATE_TITLE_BASICS IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE IMDB_STAGE.TITLE_BASICS';
  END SP_TRUNCATE_TITLE_BASICS;
  
  PROCEDURE SP_INSERT_TITLE_BASICS IS
  BEGIN
  
    INSERT /*+ APPEND */ INTO IMDB_STAGE.TITLE_BASICS (
        TCONST,
        TITLE_TYPE,
        PRIMARY_TITLE,
        ORIGINAL_TITLE,
        IS_ADULT,
        START_YEAR,
        END_YEAR,
        RUNTIME_MINUTES,
        GENRES)
      SELECT TBE.TCONST,
             TBE.TITLE_TYPE,
             TBE.PRIMARY_TITLE,
             TBE.ORIGINAL_TITLE,
             TO_NUMBER(TBE.IS_ADULT),
             CASE 
              WHEN TBE.START_YEAR = '\N'
              THEN
                NULL
              ELSE
                TO_NUMBER(TBE.START_YEAR)
              END AS START_YEAR,
             CASE 
              WHEN TBE.END_YEAR = '\N'
              THEN
                NULL
              ELSE
                TO_NUMBER(TBE.END_YEAR)
              END AS END_YEAR,
             CASE 
              WHEN TBE.RUNTIME_MINUTES = '\N'
              THEN 
                NULL
              ELSE
                TO_NUMBER(TBE.RUNTIME_MINUTES)
              END AS RUNTIME_MINUTES,
             TBE.GENRES
        FROM IMDB_STAGE.TITLE_BASICS_EXT TBE
    ;

  END SP_INSERT_TITLE_BASICS;
  
  PROCEDURE SP_LOAD_TITLE_BASICS IS
  BEGIN
    SP_TRUNCATE_TITLE_BASICS;
    SP_INSERT_TITLE_BASICS;
  END SP_LOAD_TITLE_BASICS;
  
END PKG_TITLE_BASICS;
/
SHOW ERR
SET DEFINE ON 
