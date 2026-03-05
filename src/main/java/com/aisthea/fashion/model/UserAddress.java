package com.aisthea.fashion.model;

import java.util.Date;

public class UserAddress {
    private int addressId;
    private int userId;
    private String fullName;
    private String phone;
    private String detailedAddress;
    private boolean isDefault;
    private Date createdAt;
    private Date updatedAt;

    public UserAddress() {
    }

    public UserAddress(int addressId, int userId, String fullName, String phone, String detailedAddress,
            boolean isDefault, Date createdAt, Date updatedAt) {
        this.addressId = addressId;
        this.userId = userId;
        this.fullName = fullName;
        this.phone = phone;
        this.detailedAddress = detailedAddress;
        this.isDefault = isDefault;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDetailedAddress() {
        return detailedAddress;
    }

    public void setDetailedAddress(String detailedAddress) {
        this.detailedAddress = detailedAddress;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public boolean getIsDefault() {
        return isDefault;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}
