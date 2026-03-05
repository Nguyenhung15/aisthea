package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Voucher;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO for the `vouchers` table.
 *
 * Actual DB schema (confirmed via sp_columns):
 * voucherid INT IDENTITY PK
 * code NVARCHAR(50) NOT NULL
 * description NVARCHAR(255) NULL
 * discounttype NVARCHAR(20) NOT NULL -- CHECK: 'PERCENT' | 'FIXED'
 * discountvalue DECIMAL(10,2) NOT NULL
 * minorderamount DECIMAL(10,2) NULL DEFAULT 0
 * maxdiscount DECIMAL(10,2) NULL
 * quantity INT NOT NULL
 * usedcount INT NULL DEFAULT 0
 * startdate DATETIME NULL
 * enddate DATETIME NULL
 * status NVARCHAR(20) NULL DEFAULT 'ACTIVE'
 * createdat DATETIME NULL DEFAULT GETDATE()
 */
public class VoucherDAO {

    private static final Logger logger = Logger.getLogger(VoucherDAO.class.getName());

    // ── SQL Constants ─────────────────────────────────────────────────────
    private static final String SELECT_BY_CODE = "SELECT * FROM vouchers WHERE code = ?";

    private static final String SELECT_BY_ID = "SELECT * FROM vouchers WHERE voucherid = ?";

    private static final String SELECT_ALL = "SELECT * FROM vouchers ORDER BY createdat DESC";

    private static final String SELECT_ACTIVE = "SELECT * FROM vouchers WHERE status = 'Active' " +
            "AND (startdate IS NULL OR startdate <= GETDATE()) " +
            "AND (enddate   IS NULL OR enddate   >= GETDATE()) " +
            "AND (quantity  < 0 OR usedcount < quantity) " +
            "ORDER BY createdat DESC";

    // 7 params: code(1) desc(2) type(3) val(4) min(5) max(6) qty(7) startdate(8)
    // enddate(9) status(10)
    private static final String INSERT_SQL = "INSERT INTO vouchers " +
            "  (code, description, discounttype, discountvalue, " +
            "   minorderamount, maxdiscount, quantity, usedcount, " +
            "   startdate, enddate, status, createdat) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, 0, ?, ?, ?, GETDATE())";

    // 10 params: same order then voucherid(11)
    private static final String UPDATE_SQL = "UPDATE vouchers SET " +
            "  code=?, description=?, discounttype=?, discountvalue=?, " +
            "  minorderamount=?, maxdiscount=?, quantity=?, " +
            "  startdate=?, enddate=?, status=? " +
            "WHERE voucherid=?";

    private static final String INCREMENT_USED = "UPDATE vouchers SET usedcount = usedcount + 1 WHERE voucherid=?";

    private static final String DELETE_SQL = "DELETE FROM vouchers WHERE voucherid=?";

    private static final String TOGGLE_STATUS = "UPDATE vouchers SET status=? WHERE voucherid=?";

    // ── CRUD ─────────────────────────────────────────────────────────────

    public Voucher findByCode(String code) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_CODE)) {
            ps.setString(1, code.trim().toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRow(rs);
            }
        } catch (SQLException e) {
            log("findByCode", e);
        }
        return null;
    }

    public Voucher findById(int id) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRow(rs);
            }
        } catch (SQLException e) {
            log("findById", e);
        }
        return null;
    }

    public List<Voucher> findAll() {
        List<Voucher> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(mapRow(rs));
        } catch (SQLException e) {
            log("findAll", e);
        }
        return list;
    }

    public List<Voucher> findActiveVouchers() {
        List<Voucher> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_ACTIVE);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(mapRow(rs));
        } catch (SQLException e) {
            log("findActiveVouchers", e);
        }
        return list;
    }

    /**
     * Insert a new voucher.
     *
     * Parameter mapping for INSERT_SQL:
     * 1 code
     * 2 description
     * 3 discounttype (must be 'PERCENT' or 'FIXED' per CHECK constraint)
     * 4 discountvalue
     * 5 minorderamount
     * 6 maxdiscount
     * 7 quantity
     * 8 startdate
     * 9 enddate
     * 10 status ('Active' or 'Inactive')
     */
    public boolean insert(Voucher v) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, v.getCode().trim().toUpperCase());
            setStringOrNull(ps, 2, v.getDescription());
            // discountType must be uppercase to satisfy CHECK constraint
            ps.setString(3, v.getDiscountType() != null
                    ? v.getDiscountType().trim().toUpperCase()
                    : "PERCENT");
            ps.setBigDecimal(4, v.getDiscountValue());
            setBdOrNull(ps, 5, v.getMinOrderValue());
            setBdOrNull(ps, 6, v.getMaxDiscountAmount());
            ps.setInt(7, v.getUsageLimit());
            setTsOrNull(ps, 8, v.getStartDate());
            setTsOrNull(ps, 9, v.getEndDate());
            ps.setString(10, v.isActive() ? "Active" : "Inactive");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next())
                        v.setVoucherId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            log("insert", e);
        }
        return false;
    }

    /**
     * Update an existing voucher (all editable columns).
     *
     * Parameter mapping for UPDATE_SQL:
     * 1 code
     * 2 description
     * 3 discounttype
     * 4 discountvalue
     * 5 minorderamount
     * 6 maxdiscount
     * 7 quantity
     * 8 startdate
     * 9 enddate
     * 10 status
     * 11 voucherid (WHERE)
     */
    public boolean update(Voucher v) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {

            ps.setString(1, v.getCode().trim().toUpperCase());
            setStringOrNull(ps, 2, v.getDescription());
            ps.setString(3, v.getDiscountType() != null
                    ? v.getDiscountType().trim().toUpperCase()
                    : "PERCENT");
            ps.setBigDecimal(4, v.getDiscountValue());
            setBdOrNull(ps, 5, v.getMinOrderValue());
            setBdOrNull(ps, 6, v.getMaxDiscountAmount());
            ps.setInt(7, v.getUsageLimit());
            setTsOrNull(ps, 8, v.getStartDate());
            setTsOrNull(ps, 9, v.getEndDate());
            ps.setString(10, v.isActive() ? "Active" : "Inactive");
            ps.setInt(11, v.getVoucherId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log("update", e);
        }
        return false;
    }

    public boolean delete(int id) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log("delete", e);
        }
        return false;
    }

    public boolean toggleActive(int id, boolean active) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(TOGGLE_STATUS)) {
            ps.setString(1, active ? "Active" : "Inactive");
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log("toggleActive", e);
        }
        return false;
    }

    /** Gọi sau khi đơn hàng được tạo thành công (connection riêng) */
    public boolean incrementUsedCount(int voucherId) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(INCREMENT_USED)) {
            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log("incrementUsedCount", e);
        }
        return false;
    }

    /** Gọi trong cùng transaction khi tạo đơn hàng */
    public boolean incrementUsedCount(int voucherId, Connection conn) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(INCREMENT_USED)) {
            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────

    private Voucher mapRow(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();
        v.setVoucherId(rs.getInt("voucherid"));
        v.setCode(rs.getString("code"));
        v.setDescription(rs.getString("description"));
        v.setDiscountType(rs.getString("discounttype"));
        v.setDiscountValue(rs.getBigDecimal("discountvalue"));
        v.setMinOrderValue(rs.getBigDecimal("minorderamount"));
        v.setMaxDiscountAmount(rs.getBigDecimal("maxdiscount"));
        v.setUsageLimit(rs.getInt("quantity"));
        v.setUsedCount(rs.getInt("usedcount"));
        v.setStartDate(rs.getTimestamp("startdate"));
        v.setEndDate(rs.getTimestamp("enddate"));

        // status column: 'Active' → active=true, anything else → false
        String status = rs.getString("status");
        v.setActive("Active".equalsIgnoreCase(status));

        v.setCreatedAt(rs.getTimestamp("createdat"));
        v.setUpdatedAt(rs.getTimestamp("createdat")); // no updatedat column
        return v;
    }

    private void setBdOrNull(PreparedStatement ps, int idx, java.math.BigDecimal val)
            throws SQLException {
        if (val != null)
            ps.setBigDecimal(idx, val);
        else
            ps.setNull(idx, Types.DECIMAL);
    }

    private void setTsOrNull(PreparedStatement ps, int idx, Timestamp ts)
            throws SQLException {
        if (ts != null)
            ps.setTimestamp(idx, ts);
        else
            ps.setNull(idx, Types.TIMESTAMP);
    }

    private void setStringOrNull(PreparedStatement ps, int idx, String s)
            throws SQLException {
        if (s != null && !s.isBlank())
            ps.setString(idx, s);
        else
            ps.setNull(idx, Types.NVARCHAR);
    }

    private void log(String method, SQLException e) {
        logger.log(Level.SEVERE,
                "VoucherDAO." + method + " failed — " + e.getMessage(), e);
        // Verbose chain print for Tomcat console
        System.err.println("[VoucherDAO." + method + "] SQLState=" + e.getSQLState()
                + " ErrorCode=" + e.getErrorCode() + " Msg=" + e.getMessage());
    }
}
