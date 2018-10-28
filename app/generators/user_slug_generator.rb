# frozen_string_literal: true

class UserSlugGenerator < Struct.new(:first_name, :last_name, keyword_init: true)

  def generate
    if User.where(slug: slug).none?
      slug
    else
      index = 0
      index += 1 until User.where(slug: slug(index: index)).none?
      slug(index: index)
    end
  end

  private

  def slug(index: nil)
    [first_name, last_name, index].
      map { |str| str.to_s.gsub(/\s/, '-').gsub(/[^\w\-]/, '') }.
      select(&:present?).
      join('-').
      downcase
  end

end
