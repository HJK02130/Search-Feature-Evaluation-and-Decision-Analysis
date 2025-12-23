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
)

SELECT (CASE WHEN event_name LIKE '%1' THEN 1 
			   WHEN event_name LIKE '%2' THEN 2
               WHEN event_name LIKE '%3' THEN 3
               WHEN event_name LIKE '%4' THEN 4
               WHEN event_name LIKE '%5' THEN 5
               WHEN event_name LIKE '%6' THEN 6
               WHEN event_name LIKE '%7' THEN 7
               WHEN event_name LIKE '%8' THEN 8
               WHEN event_name LIKE '%9' THEN 9
               WHEN event_name LIKE '%10' THEN 10 END) result_order, COUNT(ss) clicks_cnt
FROM events_ss
WHERE event_name LIKE 'search_click_%'
GROUP BY event_name
ORDER BY (CASE WHEN event_name LIKE '%1' THEN 1 
			   WHEN event_name LIKE '%2' THEN 2
               WHEN event_name LIKE '%3' THEN 3
               WHEN event_name LIKE '%4' THEN 4
               WHEN event_name LIKE '%5' THEN 5
               WHEN event_name LIKE '%6' THEN 6
               WHEN event_name LIKE '%7' THEN 7
               WHEN event_name LIKE '%8' THEN 8
               WHEN event_name LIKE '%9' THEN 9
               WHEN event_name LIKE '%10' THEN 10 END)
