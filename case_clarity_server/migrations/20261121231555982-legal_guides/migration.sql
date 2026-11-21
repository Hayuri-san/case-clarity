BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "legal_guide" (
    "id" bigserial PRIMARY KEY,
    "slug" text NOT NULL,
    "title" text NOT NULL,
    "caseType" text NOT NULL,
    "summary" text NOT NULL,
    "steps" json NOT NULL,
    "relevantSections" json NOT NULL,
    "disclaimer" text NOT NULL,
    "sortOrder" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "legal_guide_slug_idx" ON "legal_guide" USING btree ("slug");
CREATE INDEX "legal_guide_sort_order_idx" ON "legal_guide" USING btree ("sortOrder");


--
-- MIGRATION VERSION FOR case_clarity
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('case_clarity', '20261121231555982-legal_guides', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261121231555982-legal_guides', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20261015164015382', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261015164015382', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
