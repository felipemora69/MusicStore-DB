# Music Store Inventory System

This project showcases a collection of advanced SQL scripts designed to manage a music store’s product catalog, pricing logic, and order operations. It demonstrates how stored procedures, functions, triggers, and indexing can be used to enforce business rules, maintain data integrity, and optimize performance in a relational database.

**Project Overview**

The Music Store Database includes SQL objects that support:
- Managing product categories and inventory
- Calculating discounts and item totals
- Validating product pricing and discount rules
- Maintaining audit trails for product updates
- Automatically handling timestamps
- Improving query performance with indexing
These scripts simulate real‑world business logic for an inventory and order management system.

**Key Features**

1. Stored Procedures
- Insert new product categories
- Update product discounts with validation
- Insert new products with error handling for invalid values
2. Scalar Functions
- Calculate discounted price for an order item
- Compute total item cost based on quantity and discount
3. Triggers
- Validate discount ranges during product updates
- Automatically set DateAdded when missing
- Log product changes into an audit table
4. Indexing
- Improve lookup performance on ProductCode
- Optimize queries on OrderItems using ItemID

**Example SQL Logic Included**

The project contains SQL scripts demonstrating:
- Business rule enforcement
- Error handling using RAISERROR
- Data validation during inserts and updates
- Audit logging using INSERTED and DELETED tables
- Performance optimization with indexes

**Purpose**

This project highlights essential SQL techniques used in real business environments, including:
- Encapsulating logic in stored procedures
- Ensuring data integrity with triggers
- Creating reusable functions
- Improving performance with indexing strategies
It serves as a practical demonstration of how SQL can support inventory systems, pricing logic, and operational workflows.
