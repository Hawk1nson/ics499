-- Migration 028: Add per-recipient archive flag to messages
--
-- Archiving is per-user: each recipient controls their own copy independently.
-- Senders are unaffected — archived messages remain visible in Sent.

ALTER TABLE messages
    ADD COLUMN recipient_archived TINYINT(1) NOT NULL DEFAULT 0
        AFTER is_read;

ALTER TABLE messages
    ADD INDEX idx_messages_recipient_archived (recipient_user_id, recipient_archived);
