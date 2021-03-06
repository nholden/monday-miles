# frozen_string_literal: true

module MetaTagsHelper

  def set_title(title)
    @title = title
  end

  def title
    @title || 'Monday Miles'
  end

  def set_meta_description(description)
    @meta_description = description
  end

  def meta_description
    @meta_description || 'Mondays are hard. Celebrate your Monday Strava finishes.'
  end

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
    @twitter_card_image || 'http://www.mondaymiles.com/apple-touch-icon.png'
  end

end
