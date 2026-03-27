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

    // Geographic fields — matched to DB columns added via migration
    private int    provinceId;   // e.g. 201 = Da Nang
    private String provinceName;
    private int    districtId;
    private String districtName;
    private String wardCode;
    private String wardName;

    public UserAddress() {}

    // ── Core getters / setters ──────────────────────────────────────────────

    public int getAddressId() { return addressId; }
    public void setAddressId(int addressId) { this.addressId = addressId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDetailedAddress() { return detailedAddress; }
    public void setDetailedAddress(String detailedAddress) { this.detailedAddress = detailedAddress; }

    public boolean isDefault() { return isDefault; }
    public boolean getIsDefault() { return isDefault; }
    public void setDefault(boolean isDefault) { this.isDefault = isDefault; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    // ── Geographic getters / setters ────────────────────────────────────────

    public int getProvinceId() { return provinceId; }
    public void setProvinceId(int provinceId) { this.provinceId = provinceId; }

    public String getProvinceName() { return provinceName; }
    public void setProvinceName(String provinceName) { this.provinceName = provinceName; }

    public int getDistrictId() { return districtId; }
    public void setDistrictId(int districtId) { this.districtId = districtId; }

    public String getDistrictName() { return districtName; }
    public void setDistrictName(String districtName) { this.districtName = districtName; }

    public String getWardCode() { return wardCode; }
    public void setWardCode(String wardCode) { this.wardCode = wardCode; }

    public String getWardName() { return wardName; }
    public void setWardName(String wardName) { this.wardName = wardName; }

    /** Convenience: build a human-readable full address string. */
    public String getFullAddress() {
        StringBuilder sb = new StringBuilder();
        if (detailedAddress != null && !detailedAddress.isBlank()) sb.append(detailedAddress);
        if (wardName     != null && !wardName.isBlank())     sb.append(", ").append(wardName);
        if (districtName != null && !districtName.isBlank()) sb.append(", ").append(districtName);
        if (provinceName != null && !provinceName.isBlank()) sb.append(", ").append(provinceName);
        return sb.toString();
    }
}

