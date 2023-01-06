use if exists assurance;

# display its full description (tables, columns, constraints) by consulting the meta-data (information_schema) in mysql
select * from information_schema.tables where table_schema = 'assurance';
select * from information_schema.columns where table_schema = 'assurance';
select * from information_schema.key_column_usage where table_schema = 'assurance';
select * from information_schema.table_constraints where table_schema = 'assurance';
