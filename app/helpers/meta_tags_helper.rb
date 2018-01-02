module MetaTagsHelper

  def set_twitter_card_title(title)
    @twitter_card_title = title
  end

  def twitter_card_title
    @twitter_card_title || 'Monday Miles'
  end

  def set_twitter_card_description(description)
    @twitter_card_description = description
  end

  def twitter_card_description
    @twitter_card_description || 'Mondays are hard. Celebrate your Monday Strava finishes.'
  end

  def set_twitter_card_image(url)
    @twitter_card_image = url
  end

  def twitter_card_image
    @twitter_card_image || 'http://mondaymiles.com/apple-touch-icon.png'
  end

end
