def consolidate_cart(cart)
  # code here
  cart.each_with_object({}) do |item, result|
    item.each do |type, attributes|
      if result[type]
        attributes[:count] += 1
      else
          attributes[:count] = 1
          result[type] = attributes
      end
    end
  end
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |name, info|
    if info[:clearance]
      update = info[:price] * 0.80
      info[:price] = update.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  total_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(total_cart, coupons)
  actual_cart = apply_clearance(coupon_cart)
  total = 0
  actual_cart.each do |name, info|
    total += info[:price] * info[:count]
  end
  total = total * 0.9 if total > 100
  total
end
