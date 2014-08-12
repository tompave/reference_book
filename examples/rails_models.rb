# Given this configuration:

ReferenceBook.write_book(title: 'FreeAccount', library_key: :free) do |book|
  book.max_blog_posts = 5
  book.max_comments   = 10
  book.max_votes      = 0
  book.with_ads       = true
  book.auth_policy    = Proc.new { |user, resource| resource.free? && !resource.already_viewed_by?(user) }
end


ReferenceBook.write_book(title: 'SilverAccount', library_key: :silver) do |book|
  book.max_blog_posts = 50
  book.max_comments   = 10_000
  book.max_votes      = 1_000
  book.with_ads       = false
  book.auth_policy    = Proc.new { true }
end


ReferenceBook.write_book(title: 'GoldAccount', library_key: :gold) do |book|
  book.max_blog_posts = 200
  book.max_comments   = 50_000
  book.max_votes      = 10_000
  book.with_ads       = false
  book.auth_policy    = Proc.new { true }
end




# An ActiveRecord model can intercat with it directly:

class User < ActiveRecord::Base

  validates :accounty_type, presence: true,
                           inclusion: { in: %w(free silver gold) }


  def ref_book
    @ref_book ||= ReferenceBook.library[account_type.to_sym]
  end


  def max_blog_posts
    ref_book.max_blog_posts
  end


  def can_access?(resource)
    ref_book.auth_policy.call(self, resource)
  end


  def ads_list
    if ref_book.with_ads
      Ads::List.new(self)
    else
      Ads::None.new
    end
  end

end



# Or it can be implemented in a module


module CustomReferenceBookMethods
  def ref_book
    @ref_book ||= ReferenceBook.library[account_type.to_sym]
  end


  def max_blog_posts
    ref_book.max_blog_posts
  end


  def can_access?(resource)
    ref_book.auth_policy.call(self, resource)
  end


  def ads_list
    if ref_book.with_ads
      AdsList.new(self)
    else
      nil
    end
  end
end




class User < ActiveRecord::Base
  include CustomReferenceBookMethods

  validates :accounty_type, presence: true,
                           inclusion: { in: %w(free silver gold) }
end
