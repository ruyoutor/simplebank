begin;

INSERT INTO public.transfers
(id, from_account_id, to_account_id, amount, created_at)
VALUES(nextval('transfers_id_seq'::regclass), 1, 2, 10, '2023-09-07 12:33:05.787609-03'::timestamp with time zone) returning *;

INSERT INTO public.entries
(id, account_id, amount, created_at)
VALUES(nextval('entries_id_seq'::regclass), 1, -10, '2023-09-07 12:33:05.787609-03'::timestamp with time zone) returning *;;

INSERT INTO public.entries
(id, account_id, amount, created_at)
VALUES(nextval('entries_id_seq'::regclass), 2, 10, '2023-09-07 12:33:05.787609-03'::timestamp with time zone) returning *;;

select * from accounts a where id = 1 for update;
update accounts balance = 90 where id = 1 returning *;

select * from accounts a where id = 2 for update;
update accounts balance = 110 where id = 2 returning *;

rollback;


SELECT
    a.application_name,
    l.relation::regclass,
    l.transactionid,
    l.mode,
    l.locktype,
    l.GRANTED,
    a.usename,
    a.query,
    a.pid
FROM pg_stat_activity a
         JOIN pg_locks l ON l.pid = a.pid
where a.application_name = 'psql'
ORDER BY a.pid;



SELECT blocked_locks.pid     AS blocked_pid,
       blocked_activity.usename  AS blocked_user,
       blocking_locks.pid     AS blocking_pid,
       blocking_activity.usename AS blocking_user,
       blocked_activity.query    AS blocked_statement,
       blocking_activity.query   AS current_statement_in_blocking_process
FROM  pg_catalog.pg_locks         blocked_locks
          JOIN pg_catalog.pg_stat_activity blocked_activity  ON blocked_activity.pid = blocked_locks.pid
          JOIN pg_catalog.pg_locks         blocking_locks
               ON blocking_locks.locktype = blocked_locks.locktype
                   AND blocking_locks.database IS NOT DISTINCT FROM blocked_locks.database
                   AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
                   AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
                   AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
                   AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
                   AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
                   AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
                   AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
                   AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
                   AND blocking_locks.pid != blocked_locks.pid
          JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;