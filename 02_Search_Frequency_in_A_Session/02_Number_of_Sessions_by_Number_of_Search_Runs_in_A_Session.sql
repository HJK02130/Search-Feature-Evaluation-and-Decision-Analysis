WITH time_diff AS (
	SELECT *,
		ROW_NUMBER() OVER() rn,
		TIMESTAMPDIFF(MINUTE, LAG(occurred_at, 1) OVER (PARTITION BY user_id ORDER BY occurred_at), occurred_at) pre_diff,
        TIMESTAMPDIFF(MINUTE, occurred_at, LEAD(occurred_at, 1) OVER (PARTITION BY user_id ORDER BY occurred_at)) post_diff
	FROM events
	WHERE event_type='engagement'
    ORDER BY rn
),
idx AS (
	SELECT *,
			CASE WHEN pre_diff IS NULL THEN rn
				WHEN pre_diff >= 10 THEN rn
				ELSE LAG(rn, 1) OVER (ORDER BY rn) END ss
	FROM time_diff
	WHERE (pre_diff>=10 OR post_diff>=10) OR (pre_diff IS NULL OR post_diff IS NULL)
),
ss_mm AS ( 
	SELECT user_id, ss, MIN(occurred_at) occurred_at_min, MAX(occurred_at) occurred_at_max
	FROM idx
	GROUP BY user_id, ss
),
events_ss AS (
	SELECT events.user_id, events.occurred_at, events.event_type, events.event_name, ss_mm.ss, ss_mm.occurred_at_min
	FROM events LEFT JOIN ss_mm ON(events.user_id=ss_mm.user_id AND events.occurred_at>=ss_mm.occurred_at_min AND events.occurred_at<=occurred_at_max)
	WHERE events.event_type='engagement'
),
temp AS (
	SELECT user_id, ss, occurred_at_min,
			COUNT(CASE WHEN event_name='search_run' THEN user_id ELSE NULL END) search_runs,
			COUNT(CASE WHEN event_name='search_autocomplete' THEN user_id ELSE NULL END) search_autocompletes
	FROM events_ss
	GROUP BY occurred_at_min, ss, user_id#user_id, ss, occurred_at_min
)
SELECT search_runs, COUNT(ss) session_cnt
FROM temp
WHERE search_runs>0
GROUP BY search_runs
ORDER BY search_runs