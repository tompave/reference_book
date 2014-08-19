# Given this configuration:

ReferenceBook.write_book(title: 'Italy', library_key: :it) do |book|
  book.currency  = '€'
  book.time_zone = 'Europe/Rome'
end

ReferenceBook.write_book(title: 'UnitedKindom', library_key: :uk) do |book|
  book.currency  = '£'
  book.time_zone = 'Europe/London'
end




# All controllers can have access to the most appropriate book for the current locale:


class ApplicationController < ActionController::Base
  helper_method :ref_book

private
  
  def ref_book
    @ref_book ||= ReferenceBook.library[country_key_for_locale]
  end


  def country_key_for_locale
    case I18n.locale
      #...
    end
  end
end




# Or, to have more fine grained control:

module CustomReferenceBookMethods
  extend ActiveSupport::Concern

  included do
    helper_method :ref_book
  end

private
  
  def ref_book
    @ref_book ||= ReferenceBook.library[__safe_country_key_or_nil]
  end


  def __safe_country_key_or_nil
    if self.respond_to?(:country_key_for_locale, true)
      country_key_for_locale
    end
  end
end




class ApplicationController < ActionController::Base
  include CustomReferenceBookMethods

private

  def country_key_for_locale
    # ...
  end
end
