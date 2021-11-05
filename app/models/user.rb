# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friend_sent, class_name: 'Friendship', foreign_key: 'sent_by_id', inverse_of: 'sent_by', dependent: :destroy
  has_many :friend_request, class_name: 'Friendship', foreign_key: 'sent_to_id', inverse_of: 'sent_to',
                            dependent: :destroy
  has_many :friends, -> { merge(Friendship.friends) }, through: :friend_sent, source: :sent_to
  has_many :pending_requests, lambda {
                                merge(Friendship.not_friends)
                              }, through: :friend_sent, source: :sent_to
  has_many :recieved_requests, lambda {
                                 merge(Friendship.not_friends)
                               }, through: :friend_request, source: :sent_by
  has_many :notifications, dependent: :destroy

  validates :fname, presence: true, length: { in: 3..15 }
  validates :lname, presence: true, length: { in: 3..15 }

  def fullname
    "#{fname} #{lname}"
  end

  # Returns all posts from this user's friends and self
  def friends_and_own_posts
    myfriends = friends
    our_posts = []
    myfriends.each do |f|
      f.posts.each do |p|
        our_posts << p
      end
    end
    posts.each do |p|
      our_posts << p
    end

    our_posts
  end
end
