USE IT_Incident_Analytics;
GO

CREATE OR ALTER VIEW dbo.vw_incidents_latest AS
WITH ranked_events AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY incident_number
            ORDER BY
                updated_at DESC,
                modification_count DESC
        ) AS row_num
    FROM dbo.vw_incident_events_clean
)
SELECT
    incident_number,
    sla_met,
    reopen_count,
    incident_state,
    assigned_to,
    assignment_group,
    priority,
    opened_at,
    resolved_at,
    updated_at,
    modification_count
FROM ranked_events
WHERE row_num = 1;
GO

SELECT
    COUNT(*) AS total_incidents,
    COUNT(DISTINCT incident_number) AS unique_incidents
FROM dbo.vw_incidents_latest;