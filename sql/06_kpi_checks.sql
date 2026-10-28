USE IT_Incident_Analytics;

SELECT
    COUNT(*) AS total_incidents,
    COUNT(sla_met) AS incidents_with_sla,

    SUM(CASE WHEN sla_met = 1 THEN 1 ELSE 0 END)
        AS sla_met_incidents,

    ROUND(
        100.0 * SUM(CASE WHEN sla_met = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(sla_met), 0),
        2
    ) AS sla_met_percentage,

    SUM(CASE WHEN reopen_count > 0 THEN 1 ELSE 0 END)
        AS reopened_incidents,

    SUM(CASE
        WHEN reopen_count IS NULL OR reopen_count < 0
        THEN 1 ELSE 0
    END) AS missing_or_invalid_reopen_count

FROM dbo.vw_incidents_reporting;