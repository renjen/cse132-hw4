WITH RECURSIVE Hierarchy(employee_name, managerid) AS (
    -- base case: each employee and their direct manager
    SELECT e.ename       AS employee_name,
           e.managerid
    FROM Employee e
    WHERE e.managerid IS NOT NULL

    UNION

    -- recursive case: climb up the management chain
    SELECT h.employee_name,
           m.managerid
    FROM Hierarchy h
    JOIN Employee m
      ON h.managerid = m.eid      -- current manager
    WHERE m.managerid IS NOT NULL -- if the manager has a manager, keep going
)
SELECT h.employee_name,
       m.ename AS manager_name
FROM Hierarchy h
JOIN Employee m
  ON h.managerid = m.eid
ORDER BY h.employee_name, manager_name;
