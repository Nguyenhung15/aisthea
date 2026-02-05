package com.aisthea.fashion.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;

/**
 * Date utility methods
 */
public class DateUtil {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern(Constants.DATE_FORMAT);
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern(Constants.DATETIME_FORMAT);
    private static final DateTimeFormatter DISPLAY_DATE_FORMATTER = DateTimeFormatter
            .ofPattern(Constants.DISPLAY_DATE_FORMAT);
    private static final DateTimeFormatter DISPLAY_DATETIME_FORMATTER = DateTimeFormatter
            .ofPattern(Constants.DISPLAY_DATETIME_FORMAT);

    private DateUtil() {
        throw new IllegalStateException("Utility class");
    }

    /**
     * Get current timestamp as Date
     */
    public static Date now() {
        return new Date();
    }

    /**
     * Get current LocalDateTime
     */
    public static LocalDateTime nowLocalDateTime() {
        return LocalDateTime.now();
    }

    /**
     * Format date for display
     */
    public static String formatForDisplay(Date date) {
        if (date == null)
            return "";
        LocalDateTime localDateTime = LocalDateTime.ofInstant(
                date.toInstant(), ZoneId.systemDefault());
        return DISPLAY_DATE_FORMATTER.format(localDateTime);
    }

    /**
     * Format datetime for display
     */
    public static String formatDateTimeForDisplay(Date date) {
        if (date == null)
            return "";
        LocalDateTime localDateTime = LocalDateTime.ofInstant(
                date.toInstant(), ZoneId.systemDefault());
        return DISPLAY_DATETIME_FORMATTER.format(localDateTime);
    }

    /**
     * Parse date string
     */
    public static Date parseDate(String dateString) throws ParseException {
        if (dateString == null || dateString.trim().isEmpty()) {
            return null;
        }
        SimpleDateFormat sdf = new SimpleDateFormat(Constants.DATE_FORMAT);
        return sdf.parse(dateString);
    }

    /**
     * Add days to date
     */
    public static Date addDays(Date date, int days) {
        Instant instant = date.toInstant().plus(java.time.Duration.ofDays(days));
        return Date.from(instant);
    }

    /**
     * Add minutes to date
     */
    public static Date addMinutes(Date date, int minutes) {
        Instant instant = date.toInstant().plus(java.time.Duration.ofMinutes(minutes));
        return Date.from(instant);
    }

    /**
     * Check if date is before now
     */
    public static boolean isBeforeNow(Date date) {
        return date != null && date.before(new Date());
    }

    /**
     * Check if date is after now
     */
    public static boolean isAfterNow(Date date) {
        return date != null && date.after(new Date());
    }
}
