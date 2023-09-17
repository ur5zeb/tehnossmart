CREATE TABLE branches (
  branch_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  branch_name CHARACTER VARYING(255) NOT NULL,
  details TEXT,
  disabled SMALLINT DEFAULT 0,
  CONSTRAINT PK_branches PRIMARY KEY (branch_id)
);

CREATE TABLE contracts (
  contract_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  customer_id INTEGER,
  firm_id INTEGER,
  createdon DATE NOT NULL,
  contract_number CHARACTER VARYING(64) NOT NULL,
  disabled SMALLINT DEFAULT 0,
  details TEXT NOT NULL,
  CONSTRAINT PK_contracts PRIMARY KEY (contract_id)
);

CREATE TABLE custitems (
  custitem_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  item_id INTEGER NOT NULL,
  customer_id INTEGER NOT NULL,
  quantity DECIMAL(10, 3) DEFAULT NULL,
  price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  cust_code CHARACTER VARYING(255) NOT NULL,
  comment CHARACTER VARYING(255),
  updatedon DATE NOT NULL,
  CONSTRAINT PK_custitems PRIMARY KEY (custitem_id)

);
CREATE INDEX IF NOT EXISTS IX_custitems_item_id
ON custitems (
  item_id
);


CREATE TABLE customers (
  customer_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  customer_name CHARACTER VARYING(255) DEFAULT NULL,
  detail TEXT NOT NULL,
  email CHARACTER VARYING(64),
  phone CHARACTER VARYING(64),
  status SMALLINT NOT NULL DEFAULT 0,
  city CHARACTER VARYING(255),
  leadstatus CHARACTER VARYING(255),
  leadsource CHARACTER VARYING(255),
  createdon DATE,
  country CHARACTER VARYING(255),
  passw CHARACTER VARYING(255),
  CONSTRAINT PK_customers PRIMARY KEY (customer_id)
);
CREATE TABLE docstatelog (
  log_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  user_id INTEGER NOT NULL,
  document_id INTEGER NOT NULL,
  docstate SMALLINT NOT NULL,
  createdon TIMESTAMP NOT NULL,
  hostname CHARACTER VARYING(64) NOT NULL,
  CONSTRAINT PK_docstatelog PRIMARY KEY (log_id)

);
CREATE INDEX IF NOT EXISTS IX_docstatelog_document_id
ON docstatelog (
  document_id
);
CREATE TABLE users (
  user_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  userlogin CHARACTER VARYING(32) NOT NULL,
  userpass CHARACTER VARYING(255) NOT NULL,
  createdon DATE NOT NULL,
  email CHARACTER VARYING(255) DEFAULT NULL,
  acl TEXT NOT NULL,
  disabled SMALLINT NOT NULL DEFAULT 0,
  options TEXT,
  role_id INTEGER DEFAULT NULL,
  lastactive TIMESTAMP DEFAULT NULL,
  CONSTRAINT PK_users PRIMARY KEY (user_id)

);
CREATE UNIQUE INDEX IF NOT EXISTS IX_users_userlogin
ON users (
  userlogin
);

CREATE TABLE documents (
  document_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  document_number CHARACTER VARYING(45) NOT NULL,
  document_date DATE NOT NULL,
  user_id INTEGER NOT NULL,
  content TEXT,
  amount DECIMAL(11, 2) DEFAULT NULL,
  meta_id INTEGER NOT NULL,
  state SMALLINT NOT NULL,
  notes CHARACTER VARYING(1024)  NULL,
  customer_id INTEGER DEFAULT 0,
  payamount DECIMAL(11, 2) DEFAULT '0.00',
  payed DECIMAL(11, 2) DEFAULT '0.00',
  branch_id INTEGER DEFAULT 0,
  parent_id INTEGER DEFAULT 0,
  firm_id INTEGER DEFAULT NULL,
  lastupdate TIMESTAMP DEFAULT NULL,
  priority SMALLINT DEFAULT '100',
  CONSTRAINT PK_documents PRIMARY KEY (document_id),
  CONSTRAINT documents_ibfk_1 FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE INDEX IF NOT EXISTS IX_documents_document_date
ON documents (
  document_date
);
CREATE INDEX IF NOT EXISTS IX_documents_customer_id
ON documents (
  customer_id
);
CREATE INDEX IF NOT EXISTS IX_documents_user_id
ON documents (
  user_id
);
CREATE INDEX IF NOT EXISTS IX_documents_branch_id
ON documents (
  branch_id
);

CREATE UNIQUE INDEX IF NOT EXISTS IX_documents_unuqnumber
ON documents (
  document_number,
  branch_id
);


CREATE TABLE items (
  item_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  itemname CHARACTER VARYING(255) DEFAULT NULL,
  description TEXT,
  detail TEXT NOT NULL,
  item_code CHARACTER VARYING(64) DEFAULT NULL,
  bar_code CHARACTER VARYING(64) DEFAULT NULL,
  cat_id INTEGER NOT NULL,
  msr CHARACTER VARYING(64) DEFAULT NULL,
  disabled SMALLINT DEFAULT 0,
  minqty DECIMAL(11, 3) DEFAULT 0.000,
  manufacturer CHARACTER VARYING(355) DEFAULT NULL,
  item_type SMALLINT DEFAULT NULL,
  CONSTRAINT PK_items PRIMARY KEY (item_id)

);

CREATE INDEX IF NOT EXISTS IX_items_item_code
ON items (
  item_code
);
CREATE INDEX IF NOT EXISTS IX_items_itemname
ON items (
  itemname
);
CREATE INDEX IF NOT EXISTS IX_items_cat_id
ON items (
  cat_id
);

CREATE TABLE stores (
  store_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  storename CHARACTER VARYING(64) DEFAULT NULL,
  description CHARACTER VARYING(255) DEFAULT NULL,
  branch_id INTEGER DEFAULT 0,
  disabled SMALLINT DEFAULT 0,  
  CONSTRAINT PK_stores PRIMARY KEY (store_id)
);

CREATE TABLE store_stock (
  stock_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  item_id INTEGER NULL,
  partion DECIMAL(11, 2) DEFAULT NULL,
  store_id INTEGER NOT NULL,
  qty DECIMAL(11, 3) DEFAULT '0.000',
  snumber CHARACTER VARYING(64) DEFAULT NULL,
  sdate DATE DEFAULT NULL,
  CONSTRAINT PK_store_stock PRIMARY KEY (stock_id),

  CONSTRAINT store_stock_fk FOREIGN KEY (store_id) REFERENCES stores (store_id),
  CONSTRAINT store_stock_ibfk_1 FOREIGN KEY (item_id) REFERENCES items (item_id)
);

CREATE INDEX IF NOT EXISTS IX_store_stock_item_id
ON store_stock (
  item_id
);
CREATE INDEX IF NOT EXISTS IX_store_stock_store_id
ON store_stock (
  store_id
);


CREATE TABLE empacc (
  ea_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  emp_id INTEGER NOT NULL,
  document_id INTEGER DEFAULT NULL,
  optype INTEGER DEFAULT NULL,
  createdon DATE DEFAULT NULL,

  amount DECIMAL(10, 2) NOT NULL,
  CONSTRAINT PK_empacc PRIMARY KEY (ea_id)

);

CREATE INDEX IF NOT EXISTS IX_empacc_emp_id
ON empacc (
  emp_id
);

CREATE INDEX IF NOT EXISTS IX_empacc_document_id
ON empacc (
  document_id
);


CREATE TABLE employees (
  employee_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  login CHARACTER VARYING(64) DEFAULT NULL,
  detail TEXT,
  disabled SMALLINT DEFAULT 0,
  emp_name CHARACTER VARYING(64) NOT NULL,
  branch_id INTEGER DEFAULT 0,
  CONSTRAINT PK_employees PRIMARY KEY (employee_id)
);

CREATE TABLE entrylist (
  entry_id BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  document_id INTEGER NOT NULL,
  quantity DECIMAL(11, 3) DEFAULT '0.000',
  stock_id INTEGER DEFAULT NULL,
  service_id INTEGER DEFAULT NULL,
  outprice DECIMAL(10, 2) DEFAULT NULL,
  tag INTEGER DEFAULT 0,
  CONSTRAINT PK_entrylist PRIMARY KEY (entry_id),
  CONSTRAINT entrylist_ibfk_1 FOREIGN KEY (document_id) REFERENCES documents (document_id),
  CONSTRAINT entrylist_ibfk_2 FOREIGN KEY (stock_id) REFERENCES store_stock (stock_id)
);
CREATE INDEX IF NOT EXISTS IX_entrylist_document_id
ON entrylist (
  document_id
);


CREATE OR REPLACE FUNCTION tr () RETURNS trigger
AS $$
    BEGIN
 
        IF (TG_OP = 'DELETE') THEN
             IF old.stock_id >0 then
                update store_stock set qty=(select  coalesce(sum(quantity),0) from entrylist where stock_id=old.stock_id) where store_stock.stock_id = old.stock_id;
             END IF;            
        RETURN OLD;
 
        ELSIF (TG_OP = 'INSERT') THEN
             IF new.stock_id >0 then
                update store_stock set qty=(select  coalesce(sum(quantity),0) from entrylist where stock_id=new.stock_id) where store_stock.stock_id = new.stock_id;
             END IF;            
 
            RETURN NEW;
        END IF;
        RETURN NULL; 
    END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER tr
AFTER INSERT OR DELETE
ON entrylist
FOR EACH ROW
EXECUTE PROCEDURE tr();



CREATE TABLE equipments (
  eq_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  eq_name CHARACTER VARYING(255) DEFAULT NULL,
  detail TEXT,
  disabled SMALLINT DEFAULT 0,
  description TEXT,
  CONSTRAINT PK_equipments PRIMARY KEY (eq_id)
);


CREATE TABLE eventlist (
  user_id INTEGER NOT NULL,
  eventdate TIMESTAMP NOT NULL,
  title CHARACTER VARYING(255) NOT NULL,
  description TEXT NOT NULL,
  event_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  customer_id INTEGER NOT NULL,
  isdone SMALLINT NOT NULL DEFAULT 0,
  event_type smallint   DEFAULT 0 ,
  details text DEFAULT NULL ,
  CONSTRAINT PK_eventlist PRIMARY KEY (event_id)

);

CREATE INDEX IF NOT EXISTS IX_eventlist_user_id
ON eventlist (
  user_id
);

CREATE INDEX IF NOT EXISTS IX_eventlist_customer_id
ON eventlist (
  customer_id
);


CREATE TABLE files (
  file_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  item_id INTEGER DEFAULT NULL,
  filename CHARACTER VARYING(255) DEFAULT NULL,
  description CHARACTER VARYING(255) DEFAULT NULL,
  item_type INTEGER NOT NULL,
  mime CHARACTER VARYING(16) DEFAULT NULL,
  CONSTRAINT PK_files PRIMARY KEY (file_id)

);

CREATE INDEX IF NOT EXISTS IX_files_item_id
ON files (
  item_id
);

CREATE TABLE filesdata (
  file_id INTEGER DEFAULT NULL,
  filedata BYTEA

);

CREATE UNIQUE INDEX IF NOT EXISTS IX_filesdata_file_id
ON filesdata (
  file_id
);

CREATE TABLE firms (
  firm_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  firm_name CHARACTER VARYING(255) NOT NULL,
  details TEXT NOT NULL,
  disabled SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT PK_firms PRIMARY KEY (firm_id)
);

CREATE TABLE images (
  image_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  content BYTEA,
  mime CHARACTER VARYING(16) DEFAULT NULL,
  thumb BYTEA,
  CONSTRAINT PK_images PRIMARY KEY (image_id)
);



CREATE TABLE iostate (
  id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  document_id INTEGER NOT NULL,
  iotype SMALLINT NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  CONSTRAINT PK_iostate PRIMARY KEY (id)

);
CREATE INDEX IF NOT EXISTS IX_iostate_document_id
ON iostate (
  document_id
);

CREATE TABLE issue_history (
  hist_id BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  issue_id INT NOT NULL,
  createdon DATE NOT NULL,
  user_id INT NOT NULL,
  description CHARACTER VARYING(255) NOT NULL,
  CONSTRAINT PK_issue_history PRIMARY KEY (hist_id)

);

CREATE INDEX IF NOT EXISTS IX_issue_history_issue_id
ON issue_history (
  issue_id
);

CREATE TABLE issue_issuelist (
  issue_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  issue_name CHARACTER VARYING(255) NOT NULL,
  details TEXT NOT NULL,
  status SMALLINT NOT NULL,
  priority SMALLINT NOT NULL,
  user_id INT NULL,
  lastupdate TIMESTAMP DEFAULT NULL,
  project_id INT NOT NULL,
  CONSTRAINT PK_issue_issuelist PRIMARY KEY (issue_id)

);

CREATE INDEX IF NOT EXISTS IX_issue_issuelist_project_id
ON issue_issuelist (
  project_id
);
CREATE INDEX IF NOT EXISTS IX_issue_issuelist_user_id
ON issue_issuelist (
  user_id
);

CREATE TABLE issue_projectacc (
  id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  project_id INT NOT NULL,
  user_id INT NOT NULL,
  CONSTRAINT PK_issue_projectacc PRIMARY KEY (id)
);

CREATE TABLE issue_projectlist (
  project_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  project_name CHARACTER VARYING(255) NOT NULL,
  details TEXT NOT NULL,
  customer_id INT DEFAULT NULL,
  status SMALLINT DEFAULT NULL,
  CONSTRAINT PK_issue_projectlist PRIMARY KEY (project_id)
);

CREATE TABLE issue_time (
  id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  issue_id INT NOT NULL,
  createdon TIMESTAMP NOT NULL,
  user_id INT NOT NULL,
  duration DECIMAL(10, 2) DEFAULT NULL,
  notes CHARACTER VARYING(255) DEFAULT NULL,
  CONSTRAINT PK_issue_time PRIMARY KEY (id)

);
CREATE INDEX IF NOT EXISTS IX_issue_time_issue_id
ON issue_time (
  issue_id
);

CREATE TABLE item_cat (
  cat_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  cat_name CHARACTER VARYING(255) NOT NULL,
  detail TEXT,
  parent_id INT DEFAULT 0,
  CONSTRAINT PK_item_cat PRIMARY KEY (cat_id)
);

CREATE TABLE item_set (
  set_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  item_id INT DEFAULT NULL,
  service_id INT DEFAULT NULL,
  pitem_id INT NOT NULL,
  qty DECIMAL(11, 3) DEFAULT NULL,
  cost DECIMAL(10, 2) DEFAULT NULL,
  CONSTRAINT PK_item_set PRIMARY KEY (set_id)
);

CREATE TABLE messages (
  message_id BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  user_id INT DEFAULT NULL,
  created TIMESTAMP DEFAULT NULL,
  checked smallint   DEFAULT 0  ,
  message TEXT,
  item_id INT NOT NULL,
  item_type INT DEFAULT NULL,
  CONSTRAINT PK_messages PRIMARY KEY (message_id)

);


CREATE INDEX IF NOT EXISTS IX_messages_item_id
ON messages (
  item_id
);

CREATE TABLE metadata (
  meta_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  meta_type SMALLINT NOT NULL,
  description CHARACTER VARYING(255) DEFAULT NULL,
  meta_name CHARACTER VARYING(255) NOT NULL,
  menugroup CHARACTER VARYING(255) DEFAULT NULL,
  disabled SMALLINT NOT NULL,
  CONSTRAINT PK_metadata PRIMARY KEY (meta_id)
);


CREATE TABLE mfund (
  mf_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  mf_name CHARACTER VARYING(255) NOT NULL,
  description CHARACTER VARYING(255) DEFAULT NULL,
  branch_id INT DEFAULT 0,
  detail TEXT,
  disabled SMALLINT DEFAULT 0,  
  CONSTRAINT PK_mfund PRIMARY KEY (mf_id)
);


CREATE TABLE note_fav (
  fav_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  topic_id INT NOT NULL,
  user_id INT NOT NULL,
  CONSTRAINT PK_note_fav PRIMARY KEY (fav_id)
);

CREATE TABLE note_nodes (
  node_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  pid INT NOT NULL,
  title CHARACTER VARYING(50) NOT NULL,
  mpath CHARACTER VARYING(255) NOT NULL,
  user_id INT DEFAULT NULL,
  ispublic SMALLINT DEFAULT 0,
  CONSTRAINT PK_note_nodes PRIMARY KEY (node_id)

);

CREATE INDEX IF NOT EXISTS IX_note_nodes_user_id
ON note_nodes (
  user_id
);


CREATE TABLE note_tags (
  tag_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  topic_id INT NOT NULL,
  tagvalue CHARACTER VARYING(255) NOT NULL,
  CONSTRAINT PK_note_tags PRIMARY KEY (tag_id)

);
CREATE INDEX IF NOT EXISTS IX_note_tags_topic_id
ON note_tags (
  topic_id
);


CREATE TABLE note_topicnode (
  topic_id INT NOT NULL,
  node_id INT NOT NULL,
  tn_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  CONSTRAINT PK_note_topicnode PRIMARY KEY (tn_id)
);
CREATE INDEX IF NOT EXISTS IX_note_topicnode_topic_id
ON note_topicnode (
  topic_id
);
CREATE INDEX IF NOT EXISTS IX_note_topicnode_node_id
ON note_topicnode (
  node_id
);


CREATE TABLE note_topics (
  topic_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  title CHARACTER VARYING(255) NOT NULL,
  content TEXT NOT NULL,
  acctype SMALLINT DEFAULT 0,
  user_id INT NOT NULL,
  CONSTRAINT PK_note_topics PRIMARY KEY (topic_id)
);

CREATE TABLE notifies (
  notify_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  user_id INT NULL,
  dateshow TIMESTAMP NOT NULL,
  checked SMALLINT NOT NULL DEFAULT 0,
  message TEXT,
  sender_id INT DEFAULT NULL,
  CONSTRAINT PK_notifies PRIMARY KEY (notify_id)

);

CREATE INDEX IF NOT EXISTS IX_notifies_user_id
ON notifies (
  user_id
);

CREATE TABLE options (
  optname CHARACTER VARYING(64) NOT NULL,
  optvalue TEXT NOT NULL

);

CREATE UNIQUE INDEX IF NOT EXISTS IX_options_optname
ON options (
  optname
);

CREATE TABLE parealist (
  pa_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  pa_name CHARACTER VARYING(255) NOT NULL,
  CONSTRAINT PK_parealist PRIMARY KEY (pa_id)
);


CREATE TABLE paylist (
  pl_id BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  document_id INT NOT NULL,
  amount DECIMAL(11, 2) NOT NULL,
  mf_id INT DEFAULT NULL,
  notes CHARACTER VARYING(255) DEFAULT NULL,
  paydate TIMESTAMP DEFAULT NULL,
  user_id INT NOT NULL,
  paytype SMALLINT NOT NULL,
  detail TEXT,
  bonus INT DEFAULT NULL,
  opertype CHARACTER VARYING(255) DEFAULT NULL,
  CONSTRAINT PK_paylist PRIMARY KEY (pl_id),
  CONSTRAINT paylist_ibfk_1 FOREIGN KEY (document_id) REFERENCES documents (document_id)
);


CREATE INDEX IF NOT EXISTS IX_paylist_document_id
ON paylist (
  document_id
);

CREATE TABLE poslist (
  pos_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  pos_name CHARACTER VARYING(255) NOT NULL,
  details TEXT NOT NULL,
  branch_id INT DEFAULT 0,
  CONSTRAINT PK_poslist PRIMARY KEY (pos_id)
);

CREATE TABLE ppo_zformrep (
  id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  createdon DATE NOT NULL,
  fnpos CHARACTER VARYING(255) NOT NULL,
  fndoc CHARACTER VARYING(255) NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  cnt SMALLINT NOT NULL,
  ramount DECIMAL(10, 2) NOT NULL,
  rcnt SMALLINT NOT NULL,
  sentxml TEXT NOT NULL,
  taxanswer BYTEA NOT NULL,
  CONSTRAINT PK_ppo_zformrep PRIMARY KEY (id)
);

CREATE TABLE ppo_zformstat (
  zf_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  pos_id INT NOT NULL,
  checktype INT NOT NULL,
  createdon TIMESTAMP NOT NULL,
  amount0 DECIMAL(10, 2) NOT NULL,
  amount1 DECIMAL(10, 2) NOT NULL,
  amount2 DECIMAL(10, 2) NOT NULL,
  amount3 DECIMAL(10, 2) NOT NULL,
  fiscnumber CHARACTER VARYING(255),
  document_number CHARACTER VARYING(255) DEFAULT NULL,
  CONSTRAINT PK_ppo_zformstat PRIMARY KEY (zf_id)
);


CREATE TABLE prodproc (
  pp_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  procname CHARACTER VARYING(255) NOT NULL,
  basedoc CHARACTER VARYING(255) DEFAULT NULL,
  snumber CHARACTER VARYING(255) DEFAULT NULL,
  state SMALLINT DEFAULT 0,
  detail TEXT,
  CONSTRAINT PK_prodproc PRIMARY KEY (pp_id)
);

CREATE TABLE prodstage (
  st_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  pp_id INT NOT NULL,
  pa_id INT NOT NULL,
  state SMALLINT NOT NULL,
  stagename CHARACTER VARYING(255) NOT NULL,
  detail TEXT,
  CONSTRAINT PK_prodstage PRIMARY KEY (st_id)

);
CREATE INDEX IF NOT EXISTS IX_prodstage_pp_id
ON prodstage (
  pp_id
);
CREATE TABLE prodstageagenda (
  sta_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  st_id INT NOT NULL,
  startdate TIMESTAMP NOT NULL,
  enddate TIMESTAMP NOT NULL,
  CONSTRAINT PK_prodstageagenda PRIMARY KEY (sta_id)

);

CREATE INDEX IF NOT EXISTS IX_prodstageagenda_st_id
ON prodstageagenda (
  st_id
);


CREATE TABLE roles (
  role_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  rolename CHARACTER VARYING(255) DEFAULT NULL,
  acl TEXT,
  CONSTRAINT PK_roles PRIMARY KEY (role_id)
);

CREATE TABLE saltypes (
  st_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  salcode INT NOT NULL,
  salname CHARACTER VARYING(255) NOT NULL,
  salshortname CHARACTER VARYING(255) DEFAULT NULL,
  disabled SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT PK_saltypes PRIMARY KEY (st_id)
);

CREATE TABLE services (
  service_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  service_name CHARACTER VARYING(255) NOT NULL,
  detail TEXT,
  disabled SMALLINT DEFAULT 0,
  category CHARACTER VARYING(255) DEFAULT NULL,
  CONSTRAINT PK_services PRIMARY KEY (service_id)
);



CREATE TABLE shop_attributes (
  attribute_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  attributename CHARACTER VARYING(64) NOT NULL,
  cat_id INT NOT NULL,
  attributetype SMALLINT NOT NULL,
  valueslist TEXT,
  CONSTRAINT PK_shop_attributes PRIMARY KEY (attribute_id)
);

CREATE TABLE shop_attributes_order (
  order_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  attr_id INT NOT NULL,
  pg_id INT NOT NULL,
  ordern INT NOT NULL,
  CONSTRAINT PK_shop_attributes_order PRIMARY KEY (order_id)
);

CREATE TABLE shop_attributevalues (
  attributevalue_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  attribute_id INT NOT NULL,
  item_id INT NOT NULL,
  attributevalue CHARACTER VARYING(255) NOT NULL,
  CONSTRAINT PK_shop_attributevalues PRIMARY KEY (attributevalue_id)

);
CREATE INDEX IF NOT EXISTS IX_shop_attributevalues_attribute_id
ON shop_attributevalues (
  attribute_id
);

CREATE TABLE shop_prod_comments (
  comment_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  item_id INT NOT NULL,
  author CHARACTER VARYING(64) NOT NULL,
  comment TEXT NOT NULL,
  created TIMESTAMP NOT NULL,
  rating SMALLINT NOT NULL DEFAULT 0,
  moderated SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT PK_shop_prod_comments PRIMARY KEY (comment_id)

);
CREATE INDEX IF NOT EXISTS IX_shop_prod_comments_item_id
ON shop_prod_comments (
  item_id
);

CREATE TABLE shop_varitems (
  varitem_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  var_id INT NOT NULL,
  item_id INT NOT NULL,
  CONSTRAINT PK_shop_varitems PRIMARY KEY (varitem_id)


);
CREATE INDEX IF NOT EXISTS IX_shop_varitems_item_id
ON shop_varitems (
  item_id
);
CREATE INDEX IF NOT EXISTS IX_shop_varitems_var_id
ON shop_varitems (
  var_id
);

CREATE TABLE shop_vars (
  var_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  attr_id INT NOT NULL,
  varname CHARACTER VARYING(255) DEFAULT NULL,
  CONSTRAINT PK_shop_vars PRIMARY KEY (var_id)
);







CREATE TABLE subscribes (
  sub_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  sub_type INT DEFAULT NULL,
  reciever_type INT DEFAULT NULL,
  msg_type INT DEFAULT NULL,
  msgtext TEXT,
  detail TEXT,
  disabled INT DEFAULT 0,
  CONSTRAINT PK_subscribes PRIMARY KEY (sub_id)
);

 
CREATE TABLE timesheet (
  time_id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  emp_id INT NOT NULL,
  description CHARACTER VARYING(255) DEFAULT NULL,
  t_start TIMESTAMP DEFAULT NULL,
  t_end TIMESTAMP DEFAULT NULL,
  t_type INT DEFAULT 0,
  t_break SMALLINT DEFAULT 0,
  branch_id INT DEFAULT NULL,
  CONSTRAINT PK_timesheet PRIMARY KEY (time_id)

);

CREATE INDEX IF NOT EXISTS IX_timesheet_emp_id
ON timesheet (
  emp_id
);



CREATE

VIEW users_view
AS
SELECT
  users.user_id AS user_id,
  users.userlogin AS userlogin,
  users.userpass AS userpass,
  users.createdon AS createdon,
  users.email AS email,
  users.acl AS acl,
  users.options AS options,
  users.disabled AS disabled,
  users.lastactive AS lastactive,
  roles.rolename AS rolename,
  users.role_id AS role_id,
  roles.acl AS roleacl,
  COALESCE(employees.employee_id, 0) AS employee_id,
  (CASE WHEN employees.emp_name IS NULL THEN users.userlogin ELSE employees.emp_name END) AS username
FROM ((users
  LEFT JOIN employees
    ON (((users.userlogin = employees.login)
    AND (employees.disabled <> 1))))
  LEFT JOIN roles
    ON ((users.role_id = roles.role_id)));


CREATE

VIEW documents_view
AS
SELECT
  d.document_id AS document_id,
  d.document_number AS document_number,
  d.document_date AS document_date,
  d.user_id AS user_id,
  d.content AS content,
  d.amount AS amount,
  d.meta_id AS meta_id,
  u.username AS username,
  c.customer_id AS customer_id,
  c.customer_name AS customer_name,
  d.state AS state,
  d.notes AS notes,
  d.payamount AS payamount,
  d.payed AS payed,
  d.parent_id AS parent_id,
  d.branch_id AS branch_id,
  d.lastupdate AS lastupdate,  
  b.branch_name AS branch_name,
  d.firm_id AS firm_id,
  d.priority AS priority,
  f.firm_name AS firm_name,
  metadata.meta_name AS meta_name,
  metadata.description AS meta_desc
FROM (((((documents d
  LEFT JOIN users_view u
    ON ((d.user_id = u.user_id)))
  LEFT JOIN customers c
    ON ((d.customer_id = c.customer_id)))
  JOIN metadata
    ON ((metadata.meta_id = d.meta_id)))
  LEFT JOIN branches b
    ON ((d.branch_id = b.branch_id)))
  LEFT JOIN firms f
    ON ((d.firm_id = f.firm_id)));


CREATE VIEW contracts_view
AS
SELECT
  co.contract_id AS contract_id,
  co.customer_id AS customer_id,
  co.firm_id AS firm_id,
  co.createdon AS createdon,
  co.contract_number AS contract_number,
  co.disabled AS disabled,
  co.details AS details,
  cu.customer_name AS customer_name,
  f.firm_name AS firm_name
FROM ((contracts co
  JOIN customers cu
    ON ((co.customer_id = cu.customer_id)))
  LEFT JOIN firms f
    ON ((co.firm_id = f.firm_id)));

CREATE VIEW custitems_view
AS
SELECT
  s.custitem_id AS custitem_id,
  s.item_id AS item_id,
  s.customer_id AS customer_id,
  s.quantity AS quantity,
  s.price AS price,
  s.updatedon AS updatedon,
  s.cust_code AS cust_code,
  s.comment AS comment,
  i.itemname AS itemname,
  i.cat_id AS cat_id,
  i.item_code AS item_code,
  i.detail AS detail,
  c.customer_name AS customer_name
FROM ((custitems s
  JOIN items i
    ON ((s.item_id = i.item_id)))
  JOIN customers c
    ON ((s.customer_id = c.customer_id)))
WHERE ((i.disabled <> 1)
AND (c.status <> 1));

CREATE VIEW customers_view
AS
SELECT
  customers.customer_id AS customer_id,
  customers.customer_name AS customer_name,
  customers.detail AS detail,
  customers.email AS email,
  customers.phone AS phone,
  customers.status AS status,
  customers.city AS city,
  customers.leadsource AS leadsource,
  customers.leadstatus AS leadstatus,
  customers.country AS country,
  customers.passw AS passw,
  (SELECT
      COUNT(0)
    FROM messages m
    WHERE ((m.item_id = customers.customer_id)
    AND (m.item_type = 2)))
  AS mcnt,
  (SELECT
      COUNT(0)
    FROM files f
    WHERE ((f.item_id = customers.customer_id)
    AND (f.item_type = 2)))
  AS fcnt,
  (SELECT
      COUNT(0)
    FROM eventlist e
    WHERE ((e.customer_id = customers.customer_id)
    AND (e.eventdate >= NOW())))
  AS ecnt
FROM customers;


CREATE

VIEW docstatelog_view
AS
SELECT
  dl.log_id AS log_id,
  dl.user_id AS user_id,
  dl.document_id AS document_id,
  dl.docstate AS docstate,
  dl.createdon AS createdon,
  dl.hostname AS hostname,
  u.username AS username,
  d.document_number AS document_number,
  d.meta_desc AS meta_desc,
  d.meta_name AS meta_name
FROM ((docstatelog dl
  JOIN users_view u
    ON ((dl.user_id = u.user_id)))
  JOIN documents_view d
    ON ((d.document_id = dl.document_id)));



CREATE VIEW empacc_view
AS
SELECT
  e.ea_id AS ea_id,
  e.emp_id AS emp_id,
  e.document_id AS document_id,
  e.optype AS optype,
  d.notes AS notes,
  e.amount AS amount,
  coalesce(e.createdon,d.document_date ) AS createdon,
  d.document_number AS document_number,
  em.emp_name AS emp_name
FROM ((empacc e
  LEFT JOIN documents d
    ON ((d.document_id = e.document_id)))
  JOIN employees em
    ON ((em.employee_id = e.emp_id)));   

CREATE

VIEW entrylist_view
AS
SELECT
  entrylist.entry_id AS entry_id,
  entrylist.document_id AS document_id,
  entrylist.quantity AS quantity,
  documents.customer_id AS customer_id,
  entrylist.stock_id AS stock_id,
  entrylist.service_id AS service_id,
  entrylist.tag AS tag,
  store_stock.item_id AS item_id,
  store_stock.partion AS partion,
  documents.document_date AS document_date,
  entrylist.outprice AS outprice
FROM ((entrylist
  LEFT JOIN store_stock
    ON ((entrylist.stock_id = store_stock.stock_id)))
  JOIN documents
    ON ((entrylist.document_id = documents.document_id)));

CREATE

VIEW eventlist_view
AS
SELECT
  e.user_id AS user_id,
  e.eventdate AS eventdate,
  e.title AS title,
  e.description AS description,
  e.event_id AS event_id,
  e.customer_id AS customer_id,
  e.isdone AS isdone,
  e.event_type AS event_type,
  e.details AS details,
  c.customer_name AS customer_name,
  uv.username AS username
FROM ((eventlist e
  LEFT JOIN customers c
    ON ((e.customer_id = c.customer_id)))
  LEFT JOIN users_view uv
    ON ((uv.user_id = e.user_id))); 


CREATE

VIEW iostate_view
AS
SELECT
  s.id AS id,
  s.document_id AS document_id,
  s.iotype AS iotype,
  s.amount AS amount,
  d.document_date AS document_date,
  d.branch_id AS branch_id
FROM (iostate s
  JOIN documents d
    ON ((s.document_id = d.document_id)));

CREATE

VIEW issue_issuelist_view
AS
SELECT
  i.issue_id AS issue_id,
  i.issue_name AS issue_name,
  i.details AS details,
  i.status AS status,
  i.priority AS priority,
  i.user_id AS user_id,
  i.lastupdate AS lastupdate,
  i.project_id AS project_id,
  u.username AS username,
  p.project_name AS project_name
FROM ((issue_issuelist i
  LEFT JOIN users_view u
    ON ((i.user_id = u.user_id)))
  JOIN issue_projectlist p
    ON ((i.project_id = p.project_id)));

CREATE

VIEW issue_time_view
AS
SELECT
  t.id AS id,
  t.issue_id AS issue_id,
  t.createdon AS createdon,
  t.user_id AS user_id,
  t.duration AS duration,
  t.notes AS notes,
  u.username AS username,
  i.issue_name AS issue_name,
  i.project_id AS project_id,
  i.project_name AS project_name
FROM ((issue_time t
  JOIN users_view u
    ON ((t.user_id = u.user_id)))
  JOIN issue_issuelist_view i
    ON ((t.issue_id = i.issue_id)));



CREATE

VIEW issue_projectlist_view
AS
SELECT
  p.project_id AS project_id,
  p.project_name AS project_name,
  p.details AS details,
  p.customer_id AS customer_id,
  p.status AS status,
  c.customer_name AS customer_name,
  (SELECT
      COALESCE(SUM((CASE WHEN (i.status = 0) THEN 1 ELSE 0 END)), 0)
    FROM issue_issuelist i
    WHERE (i.project_id = p.project_id))
  AS inew,
  (SELECT
      COALESCE(SUM((CASE WHEN (i.status > 1) THEN 1 ELSE 0 END)), 0)
    FROM issue_issuelist i
    WHERE (i.project_id = p.project_id))
  AS iproc,
  (SELECT
      COALESCE(SUM((CASE WHEN (i.status = 1) THEN 1 ELSE 0 END)), 0)
    FROM issue_issuelist i
    WHERE (i.project_id = p.project_id))
  AS iclose
FROM (issue_projectlist p
  LEFT JOIN customers c
    ON ((p.customer_id = c.customer_id)));


CREATE

VIEW items_view
AS
SELECT
  items.item_id AS item_id,
  items.itemname AS itemname,
  items.description AS description,
  items.detail AS detail,
  items.item_code AS item_code,
  items.bar_code AS bar_code,
  items.cat_id AS cat_id,
  items.msr AS msr,
  items.disabled AS disabled,
  items.minqty AS minqty,
  items.item_type AS item_type,
  items.manufacturer AS manufacturer,
  item_cat.cat_name AS cat_name
FROM (items
  LEFT JOIN item_cat
    ON ((items.cat_id = item_cat.cat_id)));

 
CREATE
VIEW item_set_view
AS
SELECT
  item_set.set_id AS set_id,
  item_set.item_id AS item_id,
  item_set.pitem_id AS pitem_id,
  item_set.qty AS qty,
  item_set.service_id AS service_id,
  item_set.cost AS cost,
  items.itemname AS itemname,
  items.item_code AS item_code,
  services.service_name AS service_name
FROM ((item_set
  LEFT JOIN items
    ON (((item_set.item_id = items.item_id)
    AND (items.disabled <> 1))))
  LEFT JOIN services
    ON (((item_set.service_id = services.service_id)
    AND (services.disabled <> 1)))); 

CREATE

VIEW messages_view
AS
SELECT
  messages.message_id AS message_id,
  messages.user_id AS user_id,
  messages.created AS created,
  messages.message AS message,
  messages.item_id AS item_id,
  messages.item_type AS item_type,
  messages.checked AS checked,
  users_view.username AS username
FROM (messages
  LEFT JOIN users_view
    ON ((messages.user_id = users_view.user_id))); 

CREATE

VIEW note_nodesview
AS
SELECT
  note_nodes.node_id AS node_id,
  note_nodes.pid AS pid,
  note_nodes.title AS title,
  note_nodes.mpath AS mpath,
  note_nodes.user_id AS user_id,
  note_nodes.ispublic AS ispublic,
  (SELECT
      COUNT(note_topicnode.topic_id)
    FROM note_topicnode
    WHERE (note_topicnode.node_id = note_nodes.node_id))
  AS tcnt
FROM note_nodes;

CREATE

VIEW note_topicnodeview
AS
SELECT
  note_topicnode.topic_id AS topic_id,
  note_topicnode.node_id AS node_id,
  note_topicnode.tn_id AS tn_id,
  note_topics.title AS title,
  note_nodes.user_id AS user_id,
  note_topics.content AS content
FROM ((note_topics
  JOIN note_topicnode
    ON ((note_topics.topic_id = note_topicnode.topic_id)))
  JOIN note_nodes
    ON ((note_nodes.node_id = note_topicnode.node_id)));

CREATE

VIEW note_topicsview
AS
SELECT
  t.topic_id AS topic_id,
  t.title AS title,
  t.content AS content,
  t.acctype AS acctype,
  t.user_id AS user_id
FROM note_topics t;

CREATE

VIEW paylist_view
AS
SELECT
  pl.pl_id AS pl_id,
  pl.document_id AS document_id,
  pl.amount AS amount,
  pl.mf_id AS mf_id,
  pl.notes AS notes,
  pl.user_id AS user_id,
  pl.paydate AS paydate,
  pl.paytype AS paytype,
  pl.bonus AS bonus,
  d.document_number AS document_number,
  u.username AS username,
  m.mf_name AS mf_name,
  d.customer_id AS customer_id,
  d.customer_name AS customer_name
FROM (((paylist pl
  JOIN documents_view d
    ON ((pl.document_id = d.document_id)))
  JOIN users_view u
    ON ((pl.user_id = u.user_id)))
  LEFT JOIN mfund m
    ON ((pl.mf_id = m.mf_id)));


CREATE OR REPLACE

VIEW prodstageagenda_view
AS
SELECT
  a.sta_id AS sta_id,
  a.st_id AS st_id,
  a.startdate AS startdate,
  a.enddate AS enddate,
  pv.stagename AS stagename,
  (EXTRACT(EPOCH FROM a.enddate - a.startdate) / 3600) AS hours,


  pv.pa_id AS pa_id,
  pv.pp_id AS pp_id
FROM (prodstageagenda a
  JOIN prodstage pv
    ON ((a.st_id = pv.st_id)));



CREATE

VIEW prodstage_view
AS
SELECT
  ps.st_id AS st_id,
  ps.pp_id AS pp_id,
  ps.pa_id AS pa_id,
  ps.state AS state,
  ps.stagename AS stagename,
  COALESCE((SELECT
      MIN(pag.startdate)
    FROM prodstageagenda pag
    WHERE (pag.st_id = ps.st_id)), NULL) AS startdate,
  COALESCE((SELECT
      MAX(pag.enddate)
    FROM prodstageagenda pag
    WHERE (pag.st_id = ps.st_id)), NULL) AS enddate,
  COALESCE((SELECT
      MAX(pag.hours)
    FROM prodstageagenda_view pag
    WHERE (pag.st_id = ps.st_id)), NULL) AS hours,
  ps.detail AS detail,
  pr.procname AS procname,
  pr.snumber AS snumber,
  pr.state AS procstate,
  pa.pa_name AS pa_name
FROM ((prodstage ps
  JOIN prodproc pr
    ON ((pr.pp_id = ps.pp_id)))
  JOIN parealist pa
    ON ((pa.pa_id = ps.pa_id)));

CREATE

VIEW prodproc_view
AS
SELECT
  p.pp_id AS pp_id,
  p.procname AS procname,
  p.basedoc AS basedoc,
  p.snumber AS snumber,
  p.state AS state,
  COALESCE((SELECT
      MIN(ps.startdate)
    FROM prodstage_view ps
    WHERE (ps.pp_id = p.pp_id)), NULL) AS startdate,
  COALESCE((SELECT
      MAX(ps.enddate)
    FROM prodstage_view ps
    WHERE (ps.pp_id = p.pp_id)), NULL) AS enddate,
  COALESCE((SELECT
      COUNT(0)
    FROM prodstage ps
    WHERE (ps.pp_id = p.pp_id)), NULL) AS stagecnt,
  p.detail AS detail
FROM prodproc p;



CREATE

VIEW roles_view
AS
SELECT
  roles.role_id AS role_id,
  roles.rolename AS rolename,
  roles.acl AS acl,
  (SELECT
      COALESCE(COUNT(0), 0)
    FROM users
    WHERE (users.role_id = roles.role_id))
  AS cnt
FROM roles;

CREATE

VIEW shop_attributes_view
AS
SELECT
  shop_attributes.attribute_id AS attribute_id,
  shop_attributes.attributename AS attributename,
  shop_attributes.cat_id AS cat_id,
  shop_attributes.attributetype AS attributetype,
  shop_attributes.valueslist AS valueslist,
  shop_attributes_order.ordern AS ordern
FROM (shop_attributes
  JOIN shop_attributes_order
    ON (((shop_attributes.attribute_id = shop_attributes_order.attr_id)
    AND (shop_attributes.cat_id = shop_attributes_order.pg_id))))
ORDER BY shop_attributes_order.ordern;

CREATE

VIEW shop_products_view
AS
SELECT
  i.item_id AS item_id,
  i.itemname AS itemname,
  i.description AS description,
  i.detail AS detail,
  i.item_code AS item_code,
  i.bar_code AS bar_code,
  i.cat_id AS cat_id,
  i.msr AS msr,
  i.disabled AS disabled,
  i.minqty AS minqty,
  i.item_type AS item_type,
  i.manufacturer AS manufacturer,
  i.cat_name AS cat_name,
  COALESCE((SELECT
      SUM(store_stock.qty)
    FROM store_stock
    WHERE (store_stock.item_id = i.item_id)), 0) AS qty,
  COALESCE((SELECT
      COUNT(0)
    FROM shop_prod_comments c
    WHERE (c.item_id = i.item_id)), 0) AS comments,
  COALESCE((SELECT
      SUM(c.rating)
    FROM shop_prod_comments c
    WHERE (c.item_id = i.item_id)), 0) AS ratings
FROM items_view i;

CREATE

VIEW shop_varitems_view
AS
SELECT
  shop_varitems.varitem_id AS varitem_id,
  shop_varitems.var_id AS var_id,
  shop_varitems.item_id AS item_id,
  sv.attr_id AS attr_id,
  sa.attributevalue AS attributevalue,
  it.itemname AS itemname,
  it.item_code AS item_code
FROM (((shop_varitems
  JOIN shop_vars sv
    ON ((shop_varitems.var_id = sv.var_id)))
  JOIN shop_attributevalues sa
    ON (((sa.item_id = shop_varitems.item_id)
    AND (sv.attr_id = sa.attribute_id))))
  JOIN items it
    ON ((shop_varitems.item_id = it.item_id)));

CREATE

VIEW shop_vars_view
AS
SELECT
  shop_vars.var_id AS var_id,
  shop_vars.attr_id AS attr_id,
  shop_vars.varname AS varname,
  shop_attributes.attributename AS attributename,
  shop_attributes.cat_id AS cat_id,
  (SELECT
      COUNT(0)
    FROM shop_varitems
    WHERE (shop_varitems.var_id = shop_vars.var_id))
  AS cnt
FROM ((shop_vars
  JOIN shop_attributes
    ON ((shop_vars.attr_id = shop_attributes.attribute_id)))
  JOIN item_cat
    ON ((shop_attributes.cat_id = item_cat.cat_id)));

CREATE

VIEW store_stock_view
AS
SELECT
  st.stock_id AS stock_id,
  st.item_id AS item_id,
  st.partion AS partion,
  st.store_id AS store_id,
  i.itemname AS itemname,
  i.item_code AS item_code,
  i.cat_id AS cat_id,
  i.msr AS msr,
  i.item_type AS item_type,
  i.bar_code AS bar_code,
  i.cat_name AS cat_name,
  i.disabled AS itemdisabled,
  stores.storename AS storename,
  st.qty AS qty,
  st.snumber AS snumber,
  st.sdate AS sdate
FROM ((store_stock st
  JOIN items_view i
    ON (((i.item_id = st.item_id)
    AND (i.disabled <> 1))))
  JOIN stores
    ON ((stores.store_id = st.store_id)));

CREATE

VIEW timesheet_view
AS
SELECT
  t.time_id AS time_id,
  t.emp_id AS emp_id,
  t.description AS description,
  t.t_start AS t_start,
  t.t_end AS t_end,
  t.t_type AS t_type,
  t.t_break AS t_break,
  e.emp_name AS emp_name,
  b.branch_name AS branch_name,
  e.disabled AS disabled,
  t.branch_id AS branch_id
FROM ((timesheet t
  JOIN employees e
    ON ((t.emp_id = e.employee_id)))
  LEFT JOIN branches b
    ON ((t.branch_id = b.branch_id)));
        
                                                                                                               
                                                                                                               
CREATE VIEW cust_acc_view
AS
SELECT
  COALESCE(SUM((CASE WHEN (d.meta_name IN ('InvoiceCust', 'GoodsReceipt', 'IncomeService', 'OutcomeMoney')) THEN d.payed WHEN ((d.meta_name = 'OutcomeMoney') AND
      (d.content LIKE '%<detail>2</detail>%')) THEN d.payed WHEN (d.meta_name = 'RetCustIssue') THEN d.payamount ELSE 0 END)), 0) AS s_passive,
  COALESCE(SUM((CASE WHEN (d.meta_name IN ('IncomeService', 'GoodsReceipt')) THEN d.payamount WHEN ((d.meta_name = 'IncomeMoney') AND
      (d.content LIKE '%<detail>2</detail>%')) THEN d.payed WHEN (d.meta_name = 'RetCustIssue') THEN d.payed ELSE 0 END)), 0) AS s_active,
  COALESCE(SUM((CASE WHEN (d.meta_name IN ('GoodsIssue', 'TTN', 'PosCheck', 'OrderFood', 'ServiceAct')) THEN d.payamount WHEN ((d.meta_name = 'OutcomeMoney') AND
      (d.content LIKE '%<detail>1</detail>%')) THEN d.payed WHEN (d.meta_name = 'ReturnIssue') THEN d.payed ELSE 0 END)), 0) AS b_passive,
  COALESCE(SUM((CASE WHEN (d.meta_name IN ('GoodsIssue', 'Order', 'PosCheck', 'OrderFood', 'Invoice', 'ServiceAct')) THEN d.payed WHEN ((d.meta_name = 'IncomeMoney') AND
      (d.content LIKE '%<detail>1</detail>%')) THEN d.payed WHEN (d.meta_name = 'ReturnIssue') THEN d.payamount ELSE 0 END)), 0) AS b_active,
  d.customer_id AS customer_id
FROM documents_view d
WHERE ((d.state NOT IN (0, 1, 2, 3, 15, 8, 17))
AND (d.customer_id > 0))
GROUP BY d.customer_id;                                                                                                              
                                                                                                               
   
CREATE TABLE stats (
  id bigint  NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  category INTEGER NOT NULL,
  keyd INTEGER NOT NULL,
  vald INTEGER NOT NULL,
  dt timestamp DEFAULT NULL,
  CONSTRAINT PK_stats PRIMARY KEY (id)
)   ;   

CREATE INDEX IF NOT EXISTS IX_stats_category
ON stats (
  category
);

CREATE TABLE keyval (
  keyd CHARACTER VARYING(255) NOT NULL,
  vald text NOT NULL,
  CONSTRAINT PK_keyval PRIMARY KEY (keyd)
)
 ;
 
CREATE TABLE crontask (
  id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  created TIMESTAMP NOT NULL,
  tasktype CHARACTER VARYING(64) NOT NULL,
  taskdata text DEFAULT NULL,     
  starton TIMESTAMP DEFAULT NULL,
CONSTRAINT PK_crontask PRIMARY KEY (id)
)  ;  
 

CREATE INDEX IF NOT EXISTS IX_customers_phone
ON customers (
  phone
);

CREATE INDEX IF NOT EXISTS IX_documents_state
ON documents (
  state
);


CREATE TABLE  taglist (
  id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  tag_type smallint NOT NULL,
  item_id INTEGER NOT NULL,
  tag_name CHARACTER VARYING(255),
CONSTRAINT PK_taglist PRIMARY KEY (id)
) 