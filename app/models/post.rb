class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy

  has_many :categories_posts
  has_many :categories, through: :categories_posts
  belongs_to :user

  has_many :subscriptions
  has_many :subscribers,
           source: :user, through: :subscriptions

  validates :title, presence: true

  scope :reverse_order, -> (order) { order(created_at: :desc) }
  scope :published, -> { where(published: true)}
  scope :unpublished, -> { where(published: false) }

  after_create :subscribe_author

  def categories_titles
    # categories.map(&:title).join(',  ')
    categories.pluck(:title).join(', ')
  end

  def send_notification
    # raise Exception
  end

  protected

  def subscribe_author
    # user.subscribed_posts << self
    user.subscribe_to(self)
  end

  # def subscribe_to(post)
  #   subscribed_posts << post
  # end

end
