SELECT DISTINCT
       p.pname,
       c AS matching_comment
FROM Product p
JOIN Review r
  ON p.pid = r.pid
-- expand each comment in the comments array
CROSS JOIN LATERAL unnest(r.comments) AS c
WHERE p.category = 'electronics'
  AND c ~* '(defect|broken)'      -- comment contains 'defect' or 'broken' (case-insensitive)
ORDER BY p.pname, matching_comment;
