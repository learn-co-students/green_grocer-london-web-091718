require 'pry'

def consolidate_cart(cart)
  consol = cart.uniq
  new_cart = {}
  cart.uniq.each do |item|
    new_cart[item.keys[0]] = item.values[0]
    count = 0 
    cart.each do |object|
    if item == object 
      count +=1
    end
    new_cart[item.keys[0]][:count] = count
    end
  end 
  new_cart
end

def apply_coupons(cart, coupons)
  result = {}
  cart.each do |item, info|
    coupons.each do |coupon|
       if item == coupon[:item] && info[:count] >= coupon[:num]
        info[:count] = info[:count] - coupon[:num]
        if result["#{item} W/COUPON"]
          result["#{item} W/COUPON"][:count] += 1
        else
          result["#{item} W/COUPON"] = {
            :price => coupon[:cost],
            :clearance => info[:clearance],
            :count => 1
          }
         end
      end
    end
  result[item] = info
  end
  result
end

def apply_clearance(cart)
  cart.each do |item, info|
  	if info[:clearance]
  		info[:price] -= (info[:price] * 0.2)
  	end
	end
	cart
end

def checkout(cart, coupons)
  total_cost = 0 
  cart1 = consolidate_cart(cart)
  cart2 = apply_coupons(cart1, coupons)
  new_cart = apply_clearance(cart2)
  new_cart.each do |item, info|
    total_cost += info[:price] * info[:count]
  end
  if total_cost > 100 
    total_cost -= total_cost * 0.1
  end 
  total_cost
 end