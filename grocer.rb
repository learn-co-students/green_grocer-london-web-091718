require "pry"
def consolidate_cart(cart)
  #create empty hash
  merged_hash = {}
  #array of unique hash elements
  merged_cart = cart.group_by { |h| h }.keys
  #iterate through unique hash elements
  merged_cart.each do |unique_item|
    #push unique hash elements into empty hash
    merged_hash[unique_item.keys[0]] = unique_item.values[0]
    #set hash elements counter
    item_counter = 0
    #iterate through original hash and count elements
    cart.each do |food, details|
      if food == unique_item
        item_counter += 1
      end
    end
    #push elements count
    merged_hash[unique_item.keys[0]][:count] = item_counter
  end
  merged_hash
end

def apply_coupons(cart, coupons)
  applied = {}
  cart.each do |food, details|
    applied[food] = details
    coupon_counter = 0
    coupons.each do |coupon|
      if coupon[:item] == food && details[:count] >= coupon[:num]
        coupon_counter += 1
        applied[food][:count] = applied[food][:count] - coupon[:num]
        applied["#{food} W/COUPON"] = {price: coupon[:cost], clearance: details[:clearance], count: coupon_counter}
      end
    end
  end
  applied
end

def apply_clearance(cart)
  cart.map do |food, details|
    #binding.pry
  	if details[:clearance]
  		details[:price] -= (details[:price] * 0.2)
  	end
	end
  cart
end

def checkout(cart, coupons)
  cart_total = 0
  merged_cart = consolidate_cart(cart)
  discounted = apply_coupons(merged_cart, coupons)
  final = apply_clearance(discounted)
  final.each do |food, details|
    cart_total += details[:price] * details[:count]
  end
  if cart_total > 100
    cart_total -= cart_total*0.1
  end
  cart_total
end
