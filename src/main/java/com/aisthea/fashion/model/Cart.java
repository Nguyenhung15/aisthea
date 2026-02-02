package com.aisthea.fashion.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {

    private final Map<Integer, CartItem> items;

    public Cart() {
        this.items = new LinkedHashMap<>();
    }

    public Cart(Cart oldCart) {
        this.items = new LinkedHashMap<>();
        if (oldCart != null && oldCart.getItems() != null) {
            for (CartItem oldItem : oldCart.getItems()) {
                this.items.put(oldItem.getProductColorSizeId(), new CartItem(oldItem));
            }
        }
    }

    public void addItem(CartItem newItem) {
        int key = newItem.getProductColorSizeId();

        if (this.items.containsKey(key)) {
            CartItem existingItem = this.items.get(key);
            existingItem.setQuantity(existingItem.getQuantity() + newItem.getQuantity());
        } else {
            this.items.put(key, newItem);
        }
    }

    public void updateItem(int productColorSizeId, int newQuantity) {
        if (this.items.containsKey(productColorSizeId)) {
            if (newQuantity > 0) {
                this.items.get(productColorSizeId).setQuantity(newQuantity);
            } else {
                removeItem(productColorSizeId);
            }
        }
    }

    public void removeItem(int productColorSizeId) {
        this.items.remove(productColorSizeId);
    }

    public CartItem getItem(int pcsId) {
        return items.get(pcsId);
    }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public int getTotalQuantity() {
        return items.values().stream().mapToInt(CartItem::getQuantity).sum();
    }

    public int getCount() {
        return items.size();
    }

    public BigDecimal getTotalPrice() {
        return items.values().stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .setScale(2, RoundingMode.HALF_UP);
    }

    public boolean isEmpty() {
        return this.items.isEmpty();
    }

    public void clear() {
        this.items.clear();
    }
}
