package com.aisthea.fashion.service;

import com.aisthea.fashion.model.User;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Calendar;

/**
 * Utility class to calculate membership tier benefits.
 * Tier thresholds:
 *   MEMBER:   0 - 199 points
 *   SILVER:   200 - 999 points   → 3% discount on all orders
 *   GOLD:     1000 - 4999 points → 5% discount (implicit: free shipping included)
 *   PLATINUM: 5000+ points       → 5% discount + VIP shipping + birthday 15%
 */
public class TierService {

    private static final int SILVER_THRESHOLD = 200;
    private static final int GOLD_THRESHOLD = 1000;
    private static final int PLATINUM_THRESHOLD = 5000;

    /**
     * Returns the tier name based on user's membership points.
     */
    public static String getTierName(User user) {
        if (user == null) return "MEMBER";
        int points = user.getMembershipPoints();
        if (points >= PLATINUM_THRESHOLD) return "PLATINUM";
        if (points >= GOLD_THRESHOLD) return "GOLD";
        if (points >= SILVER_THRESHOLD) return "SILVER";
        return "MEMBER";
    }

    /**
     * Returns the automatic discount percentage for the user's current tier.
     * MEMBER  → 0%
     * SILVER  → 3%
     * GOLD    → 5%
     * PLATINUM → 5%
     */
    public static int getTierDiscountPercent(User user) {
        String tier = getTierName(user);
        switch (tier) {
            case "PLATINUM": return 5;
            case "GOLD": return 5;
            case "SILVER": return 3;
            default: return 0;
        }
    }

    /**
     * Calculates the tier discount amount for a given order subtotal.
     * Returns the actual VND amount to subtract.
     */
    public static BigDecimal calculateTierDiscount(User user, BigDecimal orderSubtotal) {
        int percent = getTierDiscountPercent(user);
        if (percent <= 0 || orderSubtotal == null || orderSubtotal.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        return orderSubtotal.multiply(BigDecimal.valueOf(percent))
                .divide(BigDecimal.valueOf(100), 0, RoundingMode.DOWN);
    }

    /**
     * Checks if the current month is the user's birthday month.
     */
    public static boolean isBirthdayMonth(User user) {
        if (user == null || user.getDob() == null) return false;
        Calendar now = Calendar.getInstance();
        Calendar dob = Calendar.getInstance();
        dob.setTime(user.getDob());
        return now.get(Calendar.MONTH) == dob.get(Calendar.MONTH);
    }

    /**
     * Returns the birthday discount percentage based on tier.
     * SILVER  → 5%
     * GOLD    → 10%
     * PLATINUM → 15%
     * Only applicable during the user's birthday month.
     */
    public static int getBirthdayDiscountPercent(User user) {
        if (!isBirthdayMonth(user)) return 0;
        String tier = getTierName(user);
        switch (tier) {
            case "PLATINUM": return 15;
            case "GOLD": return 10;
            case "SILVER": return 5;
            default: return 0;
        }
    }
}
