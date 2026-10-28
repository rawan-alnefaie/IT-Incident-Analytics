USE IT_Incident_Analytics;
GO

CREATE OR ALTER VIEW dbo.vw_incidents_reporting AS
SELECT
    *,
    CAST(opened_at AS date) AS opened_date,

    CASE
        WHEN resolved_at >= opened_at
        THEN DATEDIFF_BIG(
            SECOND, opened_at, resolved_at
        ) / 3600.0
    END AS resolution_hours,

    CASE
        WHEN opened_at IS NULL OR resolved_at IS NULL
            THEN 'Missing dates'
        WHEN resolved_at < opened_at
            THEN 'Invalid duration'
        ELSE 'Valid'
    END AS resolution_data_status

FROM dbo.vw_incidents_latest;
GO

SELECT TOP (10)
    incident_number,
    opened_date,
    resolution_hours,
    resolution_data_status
FROM dbo.vw_incidents_reporting;