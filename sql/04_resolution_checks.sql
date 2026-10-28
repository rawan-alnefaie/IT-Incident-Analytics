USE IT_Incident_Analytics;

SELECT
    COUNT(*) AS total_incidents,

    SUM(CASE
        WHEN opened_at IS NULL OR resolved_at IS NULL
        THEN 1 ELSE 0
    END) AS missing_resolution_dates,

    SUM(CASE
        WHEN resolved_at < opened_at
        THEN 1 ELSE 0
    END) AS negative_resolution_times,

    SUM(CASE
        WHEN resolved_at >= opened_at
        THEN 1 ELSE 0
    END) AS valid_resolution_times,

    AVG(CASE
        WHEN resolved_at >= opened_at
        THEN DATEDIFF_BIG(SECOND, opened_at, resolved_at) / 3600.0
    END) AS avg_resolution_hours

FROM dbo.vw_incidents_latest;