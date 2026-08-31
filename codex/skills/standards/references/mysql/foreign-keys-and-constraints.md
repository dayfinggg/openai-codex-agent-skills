# Foreign keys and constraints

- InnoDB enforces foreign-key existence checks and supports `RESTRICT`, `CASCADE`, `SET NULL`, and `NO ACTION` actions. [M13]
- MySQL does not defer InnoDB foreign-key checks, and `NO ACTION` is treated as `RESTRICT`. [M13]
- Parent and child tables must use the same storage engine, and corresponding columns need compatible types. [M13]
- MySQL requires indexes for foreign-key columns and may create a child-side index automatically. [M13]
- Align integer sign and size, string character set, and string collation between referenced and referencing columns. [M13]
- Keep referenced keys primary or unique and name constraints explicitly so migrations can alter them deterministically. [M13] [M14]
- Choose cascade behavior as a domain rule, and test multi-row cascades and deletion failure paths before production use. [M13]
