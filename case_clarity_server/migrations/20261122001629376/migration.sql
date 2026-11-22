BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "case_document" (
    "id" bigserial PRIMARY KEY,
    "caseId" bigint NOT NULL,
    "uploaderId" uuid NOT NULL,
    "fileName" text NOT NULL,
    "mimeType" text NOT NULL,
    "sizeBytes" bigint NOT NULL,
    "storagePath" text,
    "ocrStatus" text NOT NULL DEFAULT 'pending'::text,
    "extractedText" text,
    "candidateDates" json,
    "errorMessage" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "case_document_case_id_idx" ON "case_document" USING btree ("caseId");
CREATE INDEX "case_document_uploader_id_idx" ON "case_document" USING btree ("uploaderId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "case_document"
    ADD CONSTRAINT "case_document_fk_0"
    FOREIGN KEY("caseId")
    REFERENCES "legal_case"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR case_clarity
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('case_clarity', '20261122001629376', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261122001629376', "timestamp" = now();

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
