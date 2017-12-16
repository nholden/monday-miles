class UserSlugGenerator

  def initialize(first_name:, last_name:)
    @first_name = first_name
    @last_name = last_name
  end

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
    [@first_name, @last_name, index].compact.join('-').downcase
  end

end
