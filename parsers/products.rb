nokogiri = Nokogiri.HTML(content)

# initialize an empty hash
product = {}

#extract title
product['title'] = nokogiri.at_css('#productTitle').text.strip

#extract seller
product['seller'] = nokogiri.at_css('a#bylineInfo').text.strip

#extract number of reviews
reviews_text = nokogiri.at_css('span#acrCustomerReviewText')
reviews_count = reviews_text ? nokogiri.at_css('span#acrCustomerReviewText').text.strip.split(' ').first.gsub(',','') : nil
product['reviews_count'] = reviews_count =~ /^[0-9]*$/ ? reviews_count.to_i : 0

#extract rating
rating_text = nokogiri.at_css('#averageCustomerReviews span.a-icon-alt')
stars_num = rating_text ? nokogiri.at_css('#averageCustomerReviews span.a-icon-alt').text.strip.split(' ').first : nil
product['rating'] = stars_num =~ /^[0-9.]*$/ ? stars_num.to_f : nil

#extract price
product['price'] = nokogiri.at_css('#price_inside_buybox', '#priceblock_ourprice', '#priceblock_dealprice').text.strip.gsub(/[\$,]/,'').to_f

#extract availability
product['available'] = nokogiri.at_css('#availability').text.strip == 'In Stock.' ? true : false

#extract product description
description = ''
nokogiri.css('#feature-bullets li').each do |li|
  unless li['id'] || (li['class'] && li['class'] != 'showHiddenFeatureBullets')
    description += li.text.strip + ' '
  end
end
product['description'] = description.strip

#extract image
product['image'] = nokogiri.at_css('#main-image-container .imgTagWrapper img')['src']

# specify the collection where this record will be stored
product['_collection'] = "products"

# save the product to the job’s outputs
outputs << product
