package com.nexusbank.domain.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "transaction_categories")
public class TransactionCategory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private Integer categoryId;

    @Column(name = "category_code", nullable = false, unique = true, length = 30)
    private String categoryCode;

    @Column(name = "category_name", nullable = false, length = 100)
    private String categoryName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_category_id")
    private TransactionCategory parentCategory;

    @Column(name = "icon_class", length = 50)
    private String iconClass;

    public Integer             getCategoryId()             { return categoryId; }
    public String              getCategoryCode()           { return categoryCode; }
    public void                setCategoryCode(String v)   { this.categoryCode = v; }
    public String              getCategoryName()           { return categoryName; }
    public void                setCategoryName(String v)   { this.categoryName = v; }
    public TransactionCategory getParentCategory()         { return parentCategory; }
    public void                setParentCategory(TransactionCategory v) { this.parentCategory = v; }
    public String              getIconClass()              { return iconClass; }
    public void                setIconClass(String v)      { this.iconClass = v; }
}
