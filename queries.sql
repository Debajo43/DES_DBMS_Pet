
-- Add a column
ALTER TABLE Pet_Owners
ADD Emergency_Contact VARCHAR(15);

-- Modify a column
ALTER TABLE Pet
MODIFY Pet_Name VARCHAR(150);

-- Rename a column
ALTER TABLE Pet
RENAME COLUMN Weight TO Weight_Kg;

-- Add a constraint
ALTER TABLE Payments
ADD CONSTRAINT chk_payment_amount
CHECK (Amount >= 0);











