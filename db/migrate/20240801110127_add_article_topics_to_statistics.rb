class AddArticleTopicsToStatistics < ActiveRecord::Migration[7.0]
  def change
    add_column :statistics, :article_topics, :integer, default: 0
  end
end
