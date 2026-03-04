package com.aisthea.fashion.model;

import java.util.Date;

public class Category {

    private int categoryid;    // ID danh mục
    private String name;       // Tên danh mục
    private String type;       // Loại danh mục (VD: 'STYLIST', 'COLLECTION')
    private int genderid;      // Giới tính (women = 2, men = 1)
    private String parentid;      // ID danh mục cha
    private String indexName;  // Chỉ mục của danh mục
    private Date createdat;    // Thời gian tạo danh mục
    private Date updatedat;    // Thời gian cập nhật danh mục

    // Constructor
    public Category() {
    }

    public Category(int categoryid, String name, String type, int genderid, String parentid, String indexName, Date createdat, Date updatedat) {
        this.categoryid = categoryid;
        this.name = name;
        this.type = type;
        this.genderid = genderid;
        this.parentid = parentid;
        this.createdat = createdat;
        this.updatedat = updatedat;
        this.indexName = indexName;
    }

    public Category(String name, String type, int genderid, String parentid, String indexName, Date createdat, Date updatedat) {
        this.name = name;
        this.type = type;
        this.genderid = genderid;
        this.parentid = parentid;
        this.createdat = createdat;
        this.updatedat = updatedat;
        this.indexName = indexName;
    }

    public Category(String name, String type, int genderid, String parentid, String indexName) {
        this.name = name;
        this.type = type;
        this.genderid = genderid;
        this.parentid = parentid;
        this.indexName = indexName;
    }

    // Getters and Setters
    public int getCategoryid() {
        return categoryid;
    }

    public void setCategoryid(int categoryid) {
        this.categoryid = categoryid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getGenderid() {
        return genderid;
    }

    public void setGenderid(int genderid) {
        this.genderid = genderid;
    }

    public String getParentid() {
        return parentid;
    }

    public void setParentid(String parentid) {
        this.parentid = parentid;
    }

    public Date getCreatedat() {
        return createdat;
    }

    public void setCreatedat(Date createdat) {
        this.createdat = createdat;
    }

    public Date getUpdatedat() {
        return updatedat;
    }

    public void setUpdatedat(Date updatedat) {
        this.updatedat = updatedat;
    }

    public String getIndexName() {
        return indexName;
    }

    public void setIndexName(String indexName) {
        this.indexName = indexName;
    }

    @Override
    public String toString() {
        return "Category{"
                + "categoryid=" + categoryid
                + ", name='" + name + '\''
                + ", type='" + type + '\''
                + ", genderid=" + genderid
                + ", parentid=" + parentid
                + ", createdat=" + createdat
                + ", updatedat=" + updatedat
                + ", indexName='" + indexName + '\''
                + '}';
    }
}
