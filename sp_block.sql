--from https://www.sqlservercentral.com/Forums/Topic781179-146-1.aspx
USE master;
GO
IF OBJECT_ID('dbo.sp_block', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_block
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.sp_block
AS
--------------------------------------------------------------------
-- dbo.sp_block
--------------------------------------------------------------------
-- Author:      C Howarth
-- Date:      20090331
-- Database:   master
--
-- Description
-- -----------
-- Returns the blocked process hierarchy for any blocked processes.
--
-- History
-- -------
--
--------------------------------------------------------------------
SET NOCOUNT ON

IF OBJECT_ID('tempdb..#tmp') IS NOT NULL
    DROP TABLE #tmp

SELECT  es.session_id,
        ISNULL(blocking_session_id, 0) AS blocking_session_id,
        es.host_name AS host_name,
        es.original_login_name AS login_name,
        es.program_name,
        last_wait_type,
        es.cpu_time,
        es.logical_reads + es.writes AS physical_io,
        DB_NAME(er.database_id) as database_name,
        CASE    WHEN er.statement_start_offset = 0
                AND er.statement_end_offset = 0
                THEN st.text
                WHEN er.statement_start_offset <> 0
                        AND er.statement_end_offset = -1
                        THEN RIGHT(st.text, LEN(st.text) - (er.statement_start_offset / 2) + 1)
                WHEN er.statement_start_offset <> 0
                        AND er.statement_end_offset <> - 1
                        THEN SUBSTRING(st.text, (er.statement_start_offset / 2) + 1, (er.statement_end_offset / 2) - (er.statement_start_offset / 2))
                ELSE st.text
        END AS sql_text_statement,
        wait_time,
        st.text AS sql_text,
        qp.query_plan
INTO #tmp
FROM sys.dm_exec_sessions es
    LEFT JOIN (sys.dm_exec_requests er CROSS APPLY sys.dm_exec_query_plan(er.plan_handle) qp)
        ON er.session_id = es.session_id
    LEFT JOIN (sys.dm_exec_connections ec CROSS APPLY sys.dm_exec_sql_text(ec.most_recent_sql_handle) st)
        ON ec.session_id = es.session_id;

;WITH CTE
AS
(
SELECT  session_id AS RootBlockingSPID,
        session_id,
        blocking_session_id,
        0 AS nestlevel,
        CAST(session_id AS VARCHAR(MAX)) AS blocking_chain,
        host_name,
        login_name,
        program_name,
        last_wait_type,
        cpu_time,
        physical_io,
        wait_time,
        database_name,
        sql_text_statement,
        sql_text,
        query_plan
FROM #tmp sp
WHERE blocking_session_id = 0
UNION ALL
SELECT  CTE.RootBlockingSPID,
        sp.session_id,
        sp.blocking_session_id,
        CTE.nestlevel + 1,
        blocking_chain + ' <-- ' + CAST(sp.session_id AS VARCHAR(MAX)),
        sp.host_name,
        sp.login_name,
        sp.program_name,
        sp.last_wait_type,
        sp.cpu_time,
        sp.physical_io,
        sp.wait_time,
        sp.database_name,
        sp.sql_text_statement,
        sp.sql_text,
        sp.query_plan
FROM #tmp sp
    INNER JOIN CTE
        ON CTE.session_id = sp.blocking_session_id
),
CTE2
AS
(
SELECT  RootBlockingSPID,
        session_id,
        blocking_session_id,
        blocking_chain,
        host_name,
        login_name,
        program_name,
        last_wait_type,
        cpu_time,
        physical_io,
        wait_time,
        database_name,
        sql_text_statement,
        sql_text,
        query_plan
FROM CTE
WHERE EXISTS (SELECT 1 FROM CTE CTE2 WHERE CTE2.blocking_session_id = CTE.session_id)
        AND blocking_session_id = 0
UNION ALL
SELECT  RootBlockingSPID,
        session_id,
        blocking_session_id,
        blocking_chain,
        host_name,
        login_name,
        program_name,
        last_wait_type,
        cpu_time,
        physical_io,
        wait_time,
        database_name,
        sql_text_statement,
        sql_text,
        query_plan
FROM CTE
WHERE blocking_session_id <> 0
)
SELECT  session_id,
        blocking_chain,
        host_name,
        login_name,
        program_name,
        database_name,
        wait_time,
        last_wait_type,
        cpu_time,
        physical_io,
        sql_text_statement,
        sql_text,
        query_plan
FROM CTE2
ORDER BY    RootBlockingSPID,
            blocking_chain
GO