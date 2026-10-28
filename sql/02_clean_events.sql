USE IT_Incident_Analytics;
GO

CREATE OR ALTER VIEW dbo.vw_incident_events_clean AS
SELECT
    CASE LOWER(LTRIM(RTRIM([made_sla])))
        WHEN 'true' THEN 1
        WHEN 'false' THEN 0
        ELSE NULL
    END AS sla_met,

    TRY_CONVERT(
        int,
        NULLIF(NULLIF(LTRIM(RTRIM([reopen_count])), '?'), '')
    ) AS reopen_count,
    TRY_CONVERT(int, [sys_mod_count]) AS modification_count,
    NULLIF(NULLIF(LTRIM(RTRIM([number])), '?'), '')
        AS incident_number,

    NULLIF(NULLIF(LTRIM(RTRIM([incident_state])), '?'), '')
        AS incident_state,

    NULLIF(NULLIF(LTRIM(RTRIM([assigned_to])), '?'), '')
        AS assigned_to,

    NULLIF(NULLIF(LTRIM(RTRIM([assignment_group])), '?'), '')
        AS assignment_group,

    NULLIF(NULLIF(LTRIM(RTRIM([priority])), '?'), '')
        AS priority,

    TRY_CONVERT(datetime2,
        NULLIF(NULLIF(LTRIM(RTRIM([opened_at])), '?'), ''), 103)
        AS opened_at,

    TRY_CONVERT(datetime2,
        NULLIF(NULLIF(LTRIM(RTRIM([resolved_at])), '?'), ''), 103)
        AS resolved_at,

    TRY_CONVERT(datetime2,
        NULLIF(NULLIF(LTRIM(RTRIM([sys_updated_at])), '?'), ''), 103)
        AS updated_at

FROM dbo.incident_events_raw;
GO

SELECT TOP (10) *
FROM dbo.vw_incident_events_clean;