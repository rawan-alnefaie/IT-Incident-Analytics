WITH ranked_events AS (
    SELECT
        incident_number,
        updated_at,
        modification_count,
        DENSE_RANK() OVER (
            PARTITION BY incident_number
            ORDER BY
                updated_at DESC,
                modification_count DESC
        ) AS latest_rank
    FROM dbo.vw_incident_events_clean
)
SELECT
    incident_number,
    updated_at,
    modification_count,
    COUNT(*) AS tied_events
FROM ranked_events
WHERE latest_rank = 1
GROUP BY
    incident_number,
    updated_at,
    modification_count
HAVING COUNT(*) > 1;