require 'digest/sha1'

class Party < ActiveRecord::Base
  has_many :guests
  validates_presence_of :permalink
  before_validation :assign_permalink

  def to_param
    permalink
  end

  def after_initialize
    if new_record?
      self.begins_at ||= Time.now.monday + 5.days + 22.hours
      self.ends_at   ||= begins_at + 4.hours
    end
  end

  private

  def assign_permalink
    plaintext = "#{id}-#{Time.now.to_f}-{rand}"
    self.permalink = Digest::SHA1.hexdigest(plaintext)
  end
end
