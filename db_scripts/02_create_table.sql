DROP TABLE IF EXISTS nicole_schema.posts;

CREATE TABLE nicole_schema.posts (
    id SERIAL PRIMARY KEY,
    created_at timestamptz(0) NOT NULL,
    updated_at timestamptz(0)  NOT NULL,
    title text NOT NULL
);

CREATE INDEX title_idx ON nicole_schema.posts using btree(title);

