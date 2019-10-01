def consolidate_cart(cart)
	consolidated = { }
	cart.map do |item|
	  if consolidated[item.keys[0]]
		  consolidated[item.keys[0]][:count] += 1
	  else
  	  consolidated[item.keys[0]] = {
  		price: item.values[0][:price],
  		clearance: item.values[0][:clearance],
  		count: 1
  	  }
	  end
	end
	  return consolidated
end

def apply_coupons(cart, coupons)
    # Defined method which takes two arrays as arguments.
      
      coupons.each do |coupon|
       # We start by iterating into our coupons array with .each.
       
        if cart.keys.include?(coupon[:item])
        # If our cart includes the couponed item in question, carry on. If not, skip to the end of the method and return to cart.
        
          if cart[coupon[:item]][:count] >= coupon[:num]
          # If the number of these matching items in the cart is greater than or equal to the number of items redeemable against the coupon, carry on. If not, skip to end of method and return to cart.
          
            item_with_coupon = "#{coupon[:item]} W/COUPON"
            # Assign the actual coupon name (interpolating the item for abstraction) to the variable 'item_with_coupon'.
            
            if cart[item_with_coupon]
              # Does our cart include the coupon itself? It won't on first iteration (skip to 'else' to see what happens). If so, carry on.
              
              cart[item_with_coupon][:count] += coupon[:num]
              # Our cart already contains the coupon so increase the count by the number of items redeemable against the coupon.
              
              cart[coupon[:item]][:count] -= coupon[:num]
              # Reduce our coupon's count by the number of items redeemable against the coupon - the avocado coupon is now spent.
              
            else
              cart[item_with_coupon] = {}
              # Since our cart does not have the coupon, create an empty hash for the item, matching our existing hash structure.
              
              cart[item_with_coupon][:price] = (coupon[:cost] / coupon[:num])
              # Pulling values from existing coupon. Set price key at value of the coupon cost divided by the number of items required by the coupon. So the avocado coupon price is set at 2.50 (5.00 divided by two items).
              
              cart[item_with_coupon][:clearance] = cart[coupon[:item]][:clearance]
              # The clearance key is set at whether or not the original item was on clearance in the cart (this is true for avocado).
              
              cart[item_with_coupon][:count] = coupon[:num]
              # The count key for the new hash is set to the number of items redeemable against the coupon.
              
              cart[coupon[:item]][:count] -= coupon[:num]
              # Reduce our coupon's count by the number of items redeemable against the coupon - the avocado coupon is now spent.
            end

            end
          end
        end
        cart
end






def apply_clearance(cart)
  cart.each do |name, attributes|
    if attributes[:clearance]
      attributes[:price] -= attributes[:price] * 0.2
    end   
  end 
end

def checkout(cart, coupons)
  con_cart = consolidate_cart(cart)
  w_coupons = apply_coupons(con_cart, coupons)
  w_clearance = apply_clearance(w_coupons)
  total = w_clearance.reduce(0) { |acc, (key, value)| acc += value[:price] * value[:count]}
  
  total > 100 ? total * 0.9 : total  
  
end
