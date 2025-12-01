WITH RECURSIVE Subtopics(tid, tname, parent_tid) AS (
    -- base: the 'Support' topic
    SELECT tid, tname, parent_tid
    FROM Topic
    WHERE tname = 'Support'

    UNION

    -- recursive: follow child topics of anything already in Subtopics
    SELECT t.tid, t.tname, t.parent_tid
    FROM Topic t
    JOIN Subtopics s
      ON t.parent_tid = s.tid
)
SELECT DISTINCT
       s.tname,
       msg
FROM Subtopics s
JOIN Discussion d
  ON d.tid = s.tid
CROSS JOIN LATERAL unnest(d.messages) AS msg
WHERE msg ~* '(refund|return)'   -- message contains 'refund' or 'return'
  AND s.tname <> 'Support'       -- keep only descendants of 'Support'
ORDER BY s.tname, msg;
