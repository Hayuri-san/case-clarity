BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "case_clarity_user_profile" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "fullName" text NOT NULL,
    "role" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "case_clarity_user_profile_user_id_idx" ON "case_clarity_user_profile" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "case_update" (
    "id" bigserial PRIMARY KEY,
    "caseId" bigint NOT NULL,
    "authorId" uuid NOT NULL,
    "kind" text NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "case_update_case_id_idx" ON "case_update" USING btree ("caseId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "legal_case" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "caseType" text NOT NULL,
    "description" text NOT NULL,
    "stage" text NOT NULL DEFAULT 'underReview'::text,
    "creatorId" uuid NOT NULL,
    "assignedLawyerId" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "legal_case_creator_id_idx" ON "legal_case" USING btree ("creatorId");
CREATE INDEX "legal_case_assigned_lawyer_id_idx" ON "legal_case" USING btree ("assignedLawyerId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "case_update"
    ADD CONSTRAINT "case_update_fk_0"
    FOREIGN KEY("caseId")
    REFERENCES "legal_case"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR case_clarity
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('case_clarity', '20261121212244454', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261121212244454', "timestamp" = now();

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
