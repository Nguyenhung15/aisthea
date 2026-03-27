package com.aisthea.fashion.service;

import java.math.BigDecimal;

public class ShippingService {

    /**
     * Calculates the shipping fee based on the destination province and total weight of the order.
     * 
     * Rule:
     * - Base fee: 
     *   - HCM (provinceId = 202) -> 30,000 VND
     *   - Hanoi (provinceId = 201) -> 40,000 VND
     *   - Da Nang (provinceId = 203) -> 35,000 VND
     *   - Others -> 50,000 VND
     * - Sub-urban/Rural surcharge can be added via district logic later.
     * 
     * - Weight surcharge:
     *   - <= 1.0 kg -> base fee
     *   - Every 0.5 kg over 1.0 kg -> + 5,000 VND
     * 
     * @param provinceId  The ID of the province/city
     * @param totalWeight The total weight in kilograms
     * @return Shipping fee as BigDecimal (VND)
     */
    public BigDecimal calculateShippingFee(int provinceId, double totalWeight) {
        return calculateShippingFee(provinceId, totalWeight, "STANDARD");
    }

    public BigDecimal calculateShippingFee(int provinceId, double totalWeight, String shippingMethod) {
        BigDecimal baseFee;

        // Note: Actual province IDs depend on your DB. 
        // We'll use these as an example mapping:
        switch (provinceId) {
            case 202: // Ho Chi Minh City
                baseFee = new BigDecimal("30000");
                break;
            case 203: // Da Nang
                baseFee = new BigDecimal("35000");
                break;
            case 201: // Ha Noi
                baseFee = new BigDecimal("40000");
                break;
            default:  // Other Provinces
                baseFee = new BigDecimal("50000");
                break;
        }

        BigDecimal weightSurcharge = BigDecimal.ZERO;
        if (totalWeight > 1.0) {
            double extraWeight = totalWeight - 1.0;
            // Every 0.5 kg over 1.0 kg adds 5k
            int extraChunks = (int) Math.ceil(extraWeight / 0.5);
            weightSurcharge = new BigDecimal("5000").multiply(new BigDecimal(extraChunks));
        }

        BigDecimal totalFee = baseFee.add(weightSurcharge);

        if ("EXPRESS".equalsIgnoreCase(shippingMethod)) {
            totalFee = totalFee.add(new BigDecimal("30000")); // Giao hỏa tốc thêm 30k
        }

        return totalFee;
    }
}
