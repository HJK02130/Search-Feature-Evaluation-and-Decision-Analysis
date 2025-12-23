WITH time_diff AS (
	SELECT *,
		ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY occurred_at) AS rn, #ROW_NUMBER() OVER() rn,
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
				ELSE LAG(rn) OVER (PARTITION BY user_id ORDER BY occurred_at) END ss #LAG(rn, 1) OVER (ORDER BY rn) END ss
	FROM time_diff
	WHERE (pre_diff>=10 OR post_diff>=10) OR (pre_diff IS NULL OR post_diff IS NULL)
),
ss_mm AS ( 
	SELECT user_id, ss, MIN(occurred_at) session_start, MAX(occurred_at) session_end
	FROM idx
	GROUP BY user_id, ss
),
first_search AS (
SELECT user_id, MIN(occurred_at) occurred_at_min
FROM events
WHERE event_name='search_autocomplete'
GROUP BY user_id
),
first_search_user_ss_lb AS (
SELECT events.*, first_search.occurred_at_min first_search_at, ss_mm.ss, ss_mm.session_start
FROM events INNER JOIN first_search ON (events.user_id=first_search.user_id AND first_search.occurred_at_min<='2014-08-01')
			LEFT JOIN ss_mm ON (events.user_id=ss_mm.user_id AND 
									ss_mm.session_start<=DATE_ADD(first_search.occurred_at_min, INTERVAL 30 DAY) AND
									events.occurred_at<=ss_mm.session_end AND
                                    events.occurred_at>=ss_mm.session_start)
WHERE events.event_type='engagement'
),
ss_search_cnt AS (
	SELECT ss, session_start, user_id, COUNT(CASE WHEN event_name='search_autocomplete' THEN user_id ELSE NULL END) search_cnt
	FROM first_search_user_ss_lb
	GROUP BY user_id, ss, session_start
)

SELECT search_ss_cnt, COUNT(user_id) users_cnt
FROM (
SELECT user_id, COUNT(*) search_ss_cnt #COUNT(ss) search_ss_cnt
FROM ss_search_cnt
WHERE search_cnt>0
GROUP BY user_id
) temp
GROUP BY search_ss_cnt
ORDER BY search_ss_cnt
