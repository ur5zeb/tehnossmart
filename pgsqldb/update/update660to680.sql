

CREATE INDEX IF NOT EXISTS IX_customers_phone
ON customers (
  phone
);

CREATE INDEX IF NOT EXISTS IX_documents_state
ON documents (
  state
);

ALTER TABLE messages  ADD checked smallint   DEFAULT 0  ;
ALTER TABLE eventlist  ADD event_type smallint   DEFAULT 0  ;
ALTER TABLE eventlist  ADD details text DEFAULT NULL  ;


DROP VIEW messages_view;

CREATE OR REPLACE VIEW messages_view
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
 
DROP VIEW eventlist_view;

CREATE OR REPLACE VIEW eventlist_view
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
    
INSERT INTO "metadata" (meta_type, description, meta_name, menugroup, disabled) VALUES( 2, 'Кафе', 'OutFood', 'Продажі', 0);
INSERT INTO "metadata" (meta_type, description, meta_name, menugroup, disabled) VALUES( 3, 'Платіжний календар', 'PayTable', 'Каса та платежі', 0);
 
 
DELETE  FROM "options" WHERE  optname='version' ;
INSERT INTO "options" (optname, optvalue) values('version','6.8.0');     