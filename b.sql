WITH RECURSIVE paths(src, tgt) AS (
    -- base: links directly out of 'home'
    SELECT source, target
    FROM PageLinks
    WHERE source = 'home'

    UNION

    -- recursive: follow links from each newly reached page
    SELECT p.src, pl.target
    FROM paths p
    JOIN PageLinks pl
      ON p.tgt = pl.source
)
SELECT DISTINCT
       tgt AS reachable_page
FROM paths
WHERE tgt ~* '(ref|polic)'   -- name contains 'ref' or 'polic', case-insensitive
ORDER BY reachable_page;
