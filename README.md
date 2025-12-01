# CSE 132A Homework 4 - Recursive Queries, Regular Expressions, and Arrays


Version 1.0.0 - 2025/11/19


**Database System:** PostgreSQL

**Deliverables:** For each question, you should submit a `<problem_id>.sql` and a `<problem_id>.txt`. The SQL file should contain the SQL query, and the txt file should contain the explanation. Submit these 8 files through gradescope. The autograder score will be the final score for the homework.


**Grading (100 pts total)**

- Gradescope autograder score will be the final score of the SQL part of the homework. The txt files will be graded manually and separately.
- If there are any issue / bug you believe that autograder is causing the trouble, post a private Piazza post.

| **Problem** | **Points** | **Key Skills Tested**              |
| ----------- | ---------- | ---------------------------------- |
| 1           | 20         | Recursive traversal and self-joins |
| 2           | 25         | Recursive + regex filtering        |
| 3           | 25         | Regex + joins + arrays             |
| 4           | 30         | Recursion + regex + arrays         |



------


## Question (a): Recursive Query (Hierarchies) [20 pts]


**Goal:** Practice recursive CTEs for hierarchical traversal.

**Schema**

```sql
CREATE TABLE Employee (
  eid INT PRIMARY KEY,
  ename TEXT,
  managerid INT REFERENCES Employee(eid)
);
```



**Task**

Write a query to list each employee along with all managers above them, directly or indirectly.



**Output columns:**

```
employee_name | manager_name
```



**Instructions**

1. Use a recursive CTE named Hierarchy.
2. The base case selects (ename, managerid) for employees with a manager.
3. The recursive case joins to managers recursively using managerid.
4. Order the output by employee_name, manager_name.





**Example Output:**

```
employee_name | manager_name
--------------|--------------
Alice         | Carol
Bob           | Carol
Alice         | Dana
Bob           | Dana
```

> 💡 A CTE (Common Table Expression) is like a temporary named result — a query inside your query. You define it using the keyword `WITH`, give it a name, and then use it as if it were a real table.


------





##  Question (b): Recursive Query + Regular Expressions [25 pts]





**Goal:** Combine recursive traversal with regex filtering.





**Schema**



```sql
CREATE TABLE PageLinks (
  source TEXT,
  target TEXT
);
```

**Example data:**

```sql
('home','about'),
('home','contact'),
('about','faq'),
('faq','policies'),
('policies','refunds')
```



**Task**

Find all reachable pages from 'home' whose names contain the substring ref or polic (case-insensitive).





**Instructions**





1. Write a recursive CTE paths(src, tgt) starting from 'home'.
2. In the final query, filter with a regex condition: `WHERE tgt ~* '(ref|polic)'`. 
3. Return distinct reachable target page names.





**Output column:**

```sql
reachable_page
```



------





## Question (c): Regular Expressions + Nested Joins + Arrays [25 pts]





**Goal:** Combine regex filters, multi-table joins, and array processing.





**Schema**



```sql
CREATE TABLE Product (
  pid SERIAL PRIMARY KEY,
  pname TEXT,
  category TEXT
);

CREATE TABLE Review (
  rid SERIAL PRIMARY KEY,
  pid INT REFERENCES Product(pid),
  comments TEXT[],
  reviewer TEXT
);
```



**Task**





Find all products in category 'electronics' that have at least one review comment containing the words 'defect' or 'broken' (case-insensitive).





**Instructions**





1. Join Product and Review on pid.
2. Use unnest(comments) to expand each array element.
3. Filter using regex: `WHERE comment ~* '(defect|broken)'`
4. Return distinct product names and matching comments.





**Output columns:**

```
pname | matching_comment
```



------





## Question (d): Recursive Queries + Regular Expressions + Arrays [30 pts]





**Goal:** Integrate recursion, regex, and array manipulation.





**Schema**



```sql
CREATE TABLE Topic (
  tid INT PRIMARY KEY,
  tname TEXT,
  parent_tid INT REFERENCES Topic(tid)
);

CREATE TABLE Discussion (
  did SERIAL PRIMARY KEY,
  tid INT REFERENCES Topic(tid),
  messages TEXT[]
);
```



**Scenario**





Each topic can have subtopics (recursive hierarchy), and each discussion stores multiple messages as an array.





**Task**





Write a query to find all descendant topics of 'Support' that have at least one message containing the word 'refund' or 'return' (case-insensitive).





**Instructions**





1. Create a recursive CTE Subtopics(tid, tname, parent_tid) starting from the row where tname = 'Support'.
2. Join Subtopics with Discussion to access message arrays.
3. Use unnest(messages) to expand the array.
4. Filter messages using regex: `WHERE msg ~* '(refund|return)'`
5. Return unique topic names and the matching message text.





**Output columns:**

```sql
tname | msg
```



------